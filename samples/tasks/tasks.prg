/** @file tasks.prg
 * Scheduled Tasks Demo - One-shot, repeating, debounce, concurrent tasks
 *
 * Demonstrates:
 *   - HTEventLoop():schedule() for one-shot delayed execution
 *   - HTEventLoop():scheduleRepeat() for periodic callbacks
 *   - HTEventLoop():cancelTask() to stop a running task
 *   - Debounce pattern (cancel + reschedule on each keystroke)
 *   - Concurrent tasks running simultaneously
 *   - HTToast for task completion feedback
 *
 * Keyboard:
 *   Tab/Shift+Tab  - cycle focus
 *   Enter/Space    - press buttons
 *   ESC            - quit
 */

#include "hbtui.ch"
#include "inkey.ch"

STATIC oStatusBar
STATIC oClockLabel
STATIC oCounterLabel
STATIC nClockTask   := 0
STATIC nCounterTask := 0
STATIC nDebounceTask := 0
STATIC nCounter     := 0

PROCEDURE Main()

    LOCAL app, win
    LOCAL btn, lbl, oEdit

    SetMode( 25, 65 )

    app := HTApplication():new()

    win := HTMainWindow():new()
    win:setWindowTitle( " Task Scheduling Demo " )
    win:move( 1, 1 )
    win:resize( 63, 23 )

    /* --- Section 1: One-shot task --- */
    lbl := HTLabel():new( "One-shot task (fires once after delay):", win )
    lbl:move( 2, 1 )

    btn := HTPushButton():new( "Fire in 2s", win )
    btn:move( 2, 2 )
    btn:onClicked := {|| StartOneShot() }

    btn := HTPushButton():new( "Fire in 5s", win )
    btn:move( 16, 2 )
    btn:onClicked := {|| StartOneShot5() }

    /* --- Section 2: Repeating task (clock) --- */
    lbl := HTLabel():new( "Repeating task (updates every second):", win )
    lbl:move( 2, 4 )

    oClockLabel := HTLabel():new( "Clock: --:--:--", win )
    oClockLabel:move( 2, 5 )

    btn := HTPushButton():new( "Start Clock", win )
    btn:move( 2, 6 )
    btn:onClicked := {|| StartClock() }

    btn := HTPushButton():new( "Stop Clock", win )
    btn:move( 17, 6 )
    btn:onClicked := {|| StopClock() }

    /* --- Section 3: Counter (concurrent with clock) --- */
    lbl := HTLabel():new( "Concurrent task (runs alongside clock):", win )
    lbl:move( 2, 8 )

    oCounterLabel := HTLabel():new( "Counter: 0", win )
    oCounterLabel:move( 2, 9 )

    btn := HTPushButton():new( "Start Counter", win )
    btn:move( 2, 10 )
    btn:onClicked := {|| StartCounter() }

    btn := HTPushButton():new( "Stop Counter", win )
    btn:move( 19, 10 )
    btn:onClicked := {|| StopCounter() }

    btn := HTPushButton():new( "Reset", win )
    btn:move( 35, 10 )
    btn:onClicked := {|| ResetCounter() }

    /* --- Section 4: Debounce pattern --- */
    lbl := HTLabel():new( "Debounce (type, waits 800ms, then searches):", win )
    lbl:move( 2, 12 )

    oEdit := HTLineEdit():new( win )
    oEdit:move( 2, 13 )
    oEdit:resize( 40, 1 )
    oEdit:onChanged := {|cText| DebounceSearch( cText ) }

    /* --- Separator + Status --- */
    HTSeparator():new( win ):move( 1, 15 )
    HTSeparator():new( win ):resize( 61, 1 )

    lbl := HTLabel():new( "Active tasks shown in status bar", win )
    lbl:move( 2, 16 )

    /* --- ESC to quit --- */
    win:onKey( K_ESC, {|| HTApplication():quit() } )

    /* --- Status Bar --- */
    oStatusBar := HTStatusBar():new( win )
    oStatusBar:move( 1, 20 )
    oStatusBar:resize( 61, 1 )
    oStatusBar:addSection( "Ready" )
    oStatusBar:addSection( "Tasks: 0" )

    win:show()
    app:exec()

RETURN

STATIC PROCEDURE StartOneShot()

    UpdateStatus( "Scheduled: fire in 2s..." )
    HTEventLoop():schedule( {|| ;
        HTToast():show( "One-shot fired! (2s)", 2000, HT_CLR_TOAST_SUCCESS ), ;
        UpdateStatus( "One-shot complete" ) ;
    }, 2000 )
    UpdateTaskCount()

RETURN

STATIC PROCEDURE StartOneShot5()

    UpdateStatus( "Scheduled: fire in 5s..." )
    HTEventLoop():schedule( {|| ;
        HTToast():show( "One-shot fired! (5s)", 2000, HT_CLR_TOAST_INFO ), ;
        UpdateStatus( "One-shot (5s) complete" ) ;
    }, 5000 )
    UpdateTaskCount()

RETURN

STATIC PROCEDURE StartClock()

    IF nClockTask > 0
        RETURN  /* already running */
    ENDIF
    nClockTask := HTEventLoop():scheduleRepeat( {|| TickClock() }, 1000 )
    UpdateStatus( "Clock started" )
    UpdateTaskCount()

RETURN

STATIC PROCEDURE StopClock()

    IF nClockTask > 0
        HTEventLoop():cancelTask( nClockTask )
        nClockTask := 0
        UpdateStatus( "Clock stopped" )
        UpdateTaskCount()
    ENDIF

RETURN

STATIC PROCEDURE TickClock()

    LOCAL parent

    oClockLabel:setText( "Clock: " + Time() )
    parent := oClockLabel:parent()
    IF parent != NIL
        parent:repaintChild( oClockLabel )
    ENDIF

RETURN

STATIC PROCEDURE StartCounter()

    IF nCounterTask > 0
        RETURN
    ENDIF
    nCounterTask := HTEventLoop():scheduleRepeat( {|| TickCounter() }, 500 )
    UpdateStatus( "Counter started (500ms)" )
    UpdateTaskCount()

RETURN

STATIC PROCEDURE StopCounter()

    IF nCounterTask > 0
        HTEventLoop():cancelTask( nCounterTask )
        nCounterTask := 0
        UpdateStatus( "Counter stopped at " + hb_ntos( nCounter ) )
        UpdateTaskCount()
    ENDIF

RETURN

STATIC PROCEDURE ResetCounter()

    LOCAL parent

    StopCounter()
    nCounter := 0
    oCounterLabel:setText( "Counter: 0" )
    parent := oCounterLabel:parent()
    IF parent != NIL
        parent:repaintChild( oCounterLabel )
    ENDIF
    UpdateStatus( "Counter reset" )

RETURN

STATIC PROCEDURE TickCounter()

    LOCAL parent

    nCounter++
    oCounterLabel:setText( "Counter: " + hb_ntos( nCounter ) )
    parent := oCounterLabel:parent()
    IF parent != NIL
        parent:repaintChild( oCounterLabel )
    ENDIF

RETURN

STATIC PROCEDURE DebounceSearch( cText )

    /* Cancel previous search task, schedule a new one after 800ms.
       This is the debounce pattern: only the LAST keystroke triggers the search. */
    IF nDebounceTask > 0
        HTEventLoop():cancelTask( nDebounceTask )
    ENDIF
    nDebounceTask := HTEventLoop():schedule( {|| ;
        HTToast():show( "Search: " + IIF( Empty( cText ), "(empty)", cText ), 2000, HT_CLR_TOAST_INFO ), ;
        UpdateStatus( "Searched: " + cText ), ;
        nDebounceTask := 0 ;
    }, 800 )

RETURN

STATIC PROCEDURE UpdateStatus( cText )

    LOCAL parent

    IF oStatusBar != NIL
        oStatusBar:setSection( 1, cText )
        parent := oStatusBar:parent()
        IF parent != NIL
            parent:repaintChild( oStatusBar )
        ENDIF
    ENDIF

RETURN

STATIC PROCEDURE UpdateTaskCount()

    LOCAL nCount := 0
    LOCAL parent

    IF nClockTask > 0
        nCount++
    ENDIF
    IF nCounterTask > 0
        nCount++
    ENDIF
    IF oStatusBar != NIL
        oStatusBar:setSection( 2, "Tasks: " + hb_ntos( nCount ) )
        parent := oStatusBar:parent()
        IF parent != NIL
            parent:repaintChild( oStatusBar )
        ENDIF
    ENDIF

RETURN
