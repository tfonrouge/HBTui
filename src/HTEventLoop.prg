/** @class HTEventLoop
 * Unified event loop singleton. Provides shared event polling and dispatch
 * for all modal contexts (main window, dialogs, dropdown menus).
 *
 * Phase 1: poll() + run() — unified input handling with mouse movement.
 * Phase 2: schedule()/scheduleRepeat() — task queue for deferred execution.
 *
 * @example
 *   /* Main application */
 *   HTEventLoop():run( mainWindow, {|| app:isRunning() } )
 *
 *   /* Modal dialog */
 *   HTEventLoop():run( dialog, {|| dialog:isRunning() } )
 *
 *   /* Schedule a task (Phase 2) */
 *   hTask := HTEventLoop():schedule( {|| RefreshData() }, 5000 )
 *   hTask:cancel()
 */

#include "hbtui.ch"
#include "inkey.ch"

SINGLETON CLASS HTEventLoop

PROTECTED:

    DATA FmouseRow INIT -1
    DATA FmouseCol INIT -1
    DATA FaTasks   INIT {}    /* Phase 2: { { nRunAtSec, bTask, lRepeat, nIntervalSec, nId }, ... } */
    DATA FnNextId  INIT 0

PUBLIC:

    CONSTRUCTOR new()

    METHOD poll( nTimeout )
    METHOD run( oTarget, bCondition )
    METHOD runPendingTasks()

    /* Phase 2: task scheduling */
    METHOD schedule( bTask, nDelayMs )
    METHOD scheduleRepeat( bTask, nIntervalMs )
    METHOD cancelTask( nTaskId )

    METHOD handleResize()

ENDCLASS

/** Creates the singleton instance. */
METHOD new() CLASS HTEventLoop
RETURN self

/** Polls for one input event (keyboard, mouse click, or mouse movement).
 * Also checks for toast expiration and runs pending tasks.
 * @param nTimeout Inkey timeout in seconds (default 0.05)
 * @return HTEvent instance, or NIL if no event
 */
METHOD FUNCTION poll( nTimeout ) CLASS HTEventLoop

    LOCAL nKey
    LOCAL nRow, nCol

    DEFAULT nTimeout := 0.05

    /* check toast expiration */
    HTToast():checkExpired()

    /* run pending scheduled tasks */
    ::runPendingTasks()

    /* detect mouse movement */
    nRow := mRow( .T. )
    nCol := mCol( .T. )

    IF ::FmouseRow >= 0 .AND. ( nRow != ::FmouseRow .OR. nCol != ::FmouseCol )
        ::FmouseRow := nRow
        ::FmouseCol := nCol
        RETURN HTMouseEvent():new( K_MOUSEMOVE )
    ENDIF

    ::FmouseRow := nRow
    ::FmouseCol := nCol

    /* poll for keyboard/mouse input */
    nKey := Inkey( nTimeout )

    IF nKey = 0
        RETURN NIL
    ENDIF

    IF nKey >= K_MINMOUSE .AND. nKey <= K_MAXMOUSE
        RETURN HTMouseEvent():new( nKey )
    ENDIF

    IF nKey = HB_K_RESIZE
        ::handleResize()
        RETURN NIL
    ENDIF

RETURN HTKeyEvent():new( nKey )

/** Core event loop. Polls for events, dispatches to the target widget,
 * and repeats until the condition block returns .F.
 * @param oTarget HTWidget to receive events
 * @param bCondition Code block returning .T. to continue, .F. to stop
 */
METHOD PROCEDURE run( oTarget, bCondition ) CLASS HTEventLoop

    LOCAL event

    DO WHILE Eval( bCondition )

        event := ::poll()

        IF event != NIL
            event:setWidget( oTarget )
            oTarget:event( event )
        ENDIF

    ENDDO

RETURN

/** Runs any pending scheduled tasks whose execution time has arrived. */
METHOD PROCEDURE runPendingTasks() CLASS HTEventLoop

    LOCAL i, nNow, task

    IF Len( ::FaTasks ) = 0
        RETURN
    ENDIF

    nNow := Seconds()

    FOR i := Len( ::FaTasks ) TO 1 STEP -1
        task := ::FaTasks[ i ]
        IF nNow >= task[ 1 ]
            /* execute the task */
            Eval( task[ 2 ] )
            IF task[ 3 ]
                /* repeating: reschedule */
                task[ 1 ] := nNow + task[ 4 ]
            ELSE
                /* one-shot: remove */
                ADel( ::FaTasks, i )
                ASize( ::FaTasks, Len( ::FaTasks ) - 1 )
            ENDIF
        ENDIF
    NEXT

RETURN

/** Schedules a one-shot task to run after a delay.
 * @param bTask Code block to execute
 * @param nDelayMs Delay in milliseconds
 * @return Numeric task ID (use cancelTask() to cancel)
 */
METHOD FUNCTION schedule( bTask, nDelayMs ) CLASS HTEventLoop

    LOCAL nId

    DEFAULT nDelayMs := 0

    ::FnNextId++
    nId := ::FnNextId

    AAdd( ::FaTasks, { Seconds() + nDelayMs / 1000, bTask, .F., 0, nId } )

RETURN nId

/** Schedules a repeating task at a fixed interval.
 * @param bTask Code block to execute
 * @param nIntervalMs Interval in milliseconds
 * @return Numeric task ID (use cancelTask() to cancel)
 */
METHOD FUNCTION scheduleRepeat( bTask, nIntervalMs ) CLASS HTEventLoop

    LOCAL nId

    DEFAULT nIntervalMs := 1000

    ::FnNextId++
    nId := ::FnNextId

    AAdd( ::FaTasks, { Seconds() + nIntervalMs / 1000, bTask, .T., nIntervalMs / 1000, nId } )

RETURN nId

/** Cancels a scheduled task by its ID.
 * @param nTaskId Task ID returned by schedule() or scheduleRepeat()
 */
METHOD PROCEDURE cancelTask( nTaskId ) CLASS HTEventLoop

    LOCAL i

    FOR i := Len( ::FaTasks ) TO 1 STEP -1
        IF ::FaTasks[ i ][ 5 ] == nTaskId
            ADel( ::FaTasks, i )
            ASize( ::FaTasks, Len( ::FaTasks ) - 1 )
            EXIT
        ENDIF
    NEXT

RETURN

/** Handles terminal resize (HB_K_RESIZE).
 * Updates the desktop dimensions, resets the CT board, and repaints
 * all top-level windows so they render correctly in the new grid.
 */
METHOD PROCEDURE handleResize() CLASS HTEventLoop

    LOCAL app, desktop, window, key

    app := HTApplication()
    IF app = NIL
        RETURN
    ENDIF

    /* update desktop to new screen dimensions */
    desktop := app:desktop
    IF desktop != NIL
        desktop:setGeometry( 0, 0, MaxCol() + 1, MaxRow() + 1 )
        wSelect( 0 )
        wBoard()
        desktop:paintEvent( HTPaintEvent():new() )
    ENDIF

    /* repaint all top-level windows */
    FOR EACH key IN hb_hKeys( app:topLevelWindows )
        window := app:topLevelWindows[ key ]
        IF window != NIL .AND. window:isDerivedFrom( "HTWidget" )
            window:repaint()
        ENDIF
    NEXT

    /* reset mouse tracking (grid changed) */
    ::FmouseRow := -1
    ::FmouseCol := -1

RETURN
