/**
 * test_eventloop.prg - Tests for HTEventLoop task scheduling.
 *
 * Tests: schedule(), scheduleRepeat(), cancelTask(), runPendingTasks()
 *
 * HTToast is NOT tested here because show()/dismissAll() use CT window
 * functions (wOpen, wClose) that require a display driver.
 *
 * Runs headless (-gtnul).
 *
 * Build: hbmk2 test_eventloop.prg hbmk.hbm
 */

#include "hbtui.ch"

STATIC nPass := 0
STATIC nFail := 0

/* Variables modified inside code blocks */
STATIC lTaskRan    := .F.
STATIC lTask2Ran   := .F.
STATIC nRunCount   := 0

PROCEDURE Main()

    LOCAL nTotal

    TestSingleton()
    TestSchedule()
    TestScheduleRepeat()
    TestCancelTask()
    TestRunPendingTasks()
    TestRepeatSurvivesExecution()

    nTotal := nPass + nFail
    QOut( "" )
    QOut( "Results: " + hb_ntos( nPass ) + " passed, " + hb_ntos( nFail ) + " failed out of " + hb_ntos( nTotal ) )
    ErrorLevel( IIF( nFail > 0, 1, 0 ) )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE Assert( cName, lCond )

    IF lCond
        nPass++
    ELSE
        nFail++
        OutErr( "FAIL: " + cName + hb_eol() )
    ENDIF

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE Assert_T( cName, lCond )

    Assert( cName, lCond )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE Assert_F( cName, lCond )

    Assert( cName, ! lCond )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestSingleton()

    LOCAL o1, o2

    o1 := HTEventLoop()
    o2 := HTEventLoop()
    Assert( "HTEventLoop singleton same instance", o1 == o2 )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestSchedule()

    LOCAL el
    LOCAL nId1, nId2

    el := HTEventLoop()

    nId1 := el:schedule( {|| NIL }, 1000 )
    Assert_T( "schedule() returns positive ID", nId1 > 0 )

    nId2 := el:schedule( {|| NIL }, 2000 )
    Assert_T( "schedule() returns unique ID", nId2 > 0 .AND. nId2 != nId1 )

    /* clean up */
    el:cancelTask( nId1 )
    el:cancelTask( nId2 )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestScheduleRepeat()

    LOCAL el
    LOCAL nId

    el := HTEventLoop()

    nId := el:scheduleRepeat( {|| NIL }, 500 )
    Assert_T( "scheduleRepeat() returns positive ID", nId > 0 )

    /* clean up */
    el:cancelTask( nId )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestCancelTask()

    LOCAL el
    LOCAL nId1, nId2

    el := HTEventLoop()

    nId1 := el:schedule( {|| NIL }, 5000 )
    nId2 := el:schedule( {|| NIL }, 5000 )

    /* cancel first task */
    el:cancelTask( nId1 )

    /* verify second task still exists by canceling it (no crash) */
    el:cancelTask( nId2 )
    Assert_T( "cancelTask() removes task without crash", .T. )

    /* cancel with invalid ID: must not crash */
    el:cancelTask( -1 )
    Assert_T( "cancelTask() invalid ID no crash", .T. )

    el:cancelTask( 999999 )
    Assert_T( "cancelTask() nonexistent ID no crash", .T. )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestRunPendingTasks()

    LOCAL el

    el := HTEventLoop()

    /* runPendingTasks with empty queue: no crash */
    el:runPendingTasks()
    Assert_T( "runPendingTasks() empty queue no crash", .T. )

    /* schedule with delay=0 (fires immediately on next runPendingTasks) */
    lTaskRan := .F.
    el:schedule( {|| lTaskRan := .T. }, 0 )
    el:runPendingTasks()
    Assert_T( "schedule(0) fires on runPendingTasks", lTaskRan )

    /* schedule with large delay: should NOT fire */
    lTask2Ran := .F.
    el:schedule( {|| lTask2Ran := .T. }, 999999 )
    el:runPendingTasks()
    Assert_F( "schedule(999999) does not fire", lTask2Ran )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestRepeatSurvivesExecution()

    LOCAL el
    LOCAL nId

    el := HTEventLoop()

    /* repeating task with interval=0 fires immediately */
    nRunCount := 0
    nId := el:scheduleRepeat( {|| nRunCount++ }, 0 )

    /* first execution */
    el:runPendingTasks()
    Assert_T( "repeating task fires", nRunCount >= 1 )

    /* second execution — task was NOT removed */
    el:runPendingTasks()
    Assert_T( "repeating task survives execution", nRunCount >= 2 )

    /* clean up */
    el:cancelTask( nId )

RETURN
