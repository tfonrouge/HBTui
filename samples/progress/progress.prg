/** @file progress.prg
 * Animated HTProgressBar Demo - Timer-driven progress with start/reset
 *
 * Demonstrates:
 *   - HTProgressBar with animated fill
 *   - HTEventLoop():scheduleRepeat() for periodic updates
 *   - HTEventLoop():cancelTask() to stop a running timer
 *   - HTToast for completion notification
 *   - HTVBoxLayout for widget arrangement
 *
 * Keyboard:
 *   Tab/Shift+Tab  - cycle focus
 *   Enter/Space    - press buttons
 *   ESC            - quit
 */

#include "hbtui.ch"
#include "inkey.ch"

STATIC nTaskId   := 0
STATIC oProgress
STATIC oLabel
STATIC oStatusBar

PROCEDURE Main()

    LOCAL app, win
    LOCAL layout
    LOCAL btn

    SetMode( 20, 55 )

    app := HTApplication():new()

    win := HTMainWindow():new()
    win:setWindowTitle( " Progress Demo " )
    win:move( 1, 1 )
    win:resize( 50, 16 )

    /* --- Vertical layout --- */
    layout := HTVBoxLayout():new( win )
    layout:spacing := 1
    layout:setContentsMargins( 2, 2, 2, 2 )

    /* --- Progress bar --- */
    oProgress := HTProgressBar():new( win )
    layout:addWidget( oProgress )

    /* --- Percentage label --- */
    oLabel := HTLabel():new( "Progress: 0%", win )
    layout:addWidget( oLabel )

    /* --- Stretch to center buttons --- */
    layout:addStretch()

    /* --- Start button --- */
    btn := HTPushButton():new( "Start", win )
    btn:onClicked := {|| StartProgress() }
    layout:addWidget( btn )

    /* --- Reset button --- */
    btn := HTPushButton():new( "Reset", win )
    btn:onClicked := {|| ResetProgress() }
    layout:addWidget( btn )

    /* --- Stretch below buttons --- */
    layout:addStretch()

    /* --- Status Bar --- */
    oStatusBar := HTStatusBar():new( win )
    oStatusBar:addSection( "Start to begin, Reset to clear" )
    oStatusBar:addSection( "ESC to quit" )
    layout:addWidget( oStatusBar )

    win:show()
    app:exec()

RETURN

STATIC PROCEDURE StartProgress()

    IF nTaskId != 0
        RETURN
    ENDIF

    UpdateStatus( "Running..." )
    nTaskId := HTEventLoop():scheduleRepeat( {|| TickProgress() }, 150 )

RETURN

STATIC PROCEDURE TickProgress()

    LOCAL nVal

    nVal := oProgress:value + 2
    oProgress:setValue( nVal )
    UpdateLabel( nVal )

    IF nVal >= 100
        HTEventLoop():cancelTask( nTaskId )
        nTaskId := 0
        UpdateStatus( "Done!" )
        HTToast():show( "Complete!" )
    ENDIF

RETURN

STATIC PROCEDURE ResetProgress()

    IF nTaskId != 0
        HTEventLoop():cancelTask( nTaskId )
        nTaskId := 0
    ENDIF

    oProgress:setValue( 0 )
    UpdateLabel( 0 )
    UpdateStatus( "Reset" )

RETURN

STATIC PROCEDURE UpdateLabel( nVal )

    LOCAL parent

    oLabel:setText( "Progress: " + LTrim( Str( nVal ) ) + "%" )
    parent := oLabel:parent()
    IF parent != NIL
        parent:repaintChild( oLabel )
    ENDIF

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
