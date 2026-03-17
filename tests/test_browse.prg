/**
 * test_browse.prg - Headless tests for HTBrowse.
 *
 * Tests column management and callback configuration; does not exercise
 * TBrowse rendering or keyboard navigation (those require a real GT).
 *
 * Build: hbmk2 test_browse.prg hbmk.hbm
 */

#include "hbtui.ch"

STATIC nPass := 0
STATIC nFail := 0

PROCEDURE Main()

    LOCAL nTotal

    TestBrowseInit()
    TestBrowseColumns()
    TestBrowseCallbacks()

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

STATIC PROCEDURE TestBrowseInit()

    LOCAL o

    o := HTBrowse():new()
    Assert( "HTBrowse:columnCount 0 on new",  o:columnCount() == 0 )
    Assert( "HTBrowse:editable default .F.",   ! o:editable )
    Assert( "HTBrowse:onActivated default NIL", o:onActivated == NIL )
    Assert( "HTBrowse:onBeginEdit default NIL", o:onBeginEdit == NIL )
    Assert( "HTBrowse:onEndEdit default NIL",   o:onEndEdit == NIL )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestBrowseColumns()

    LOCAL o
    LOCAL oCol

    o := HTBrowse():new()

    /* addColumn: convenience form (heading + block) */
    o:addColumn( "Name", {|| "Alice"} )
    Assert( "HTBrowse:columnCount 1 after addColumn",  o:columnCount() == 1 )

    o:addColumn( "Age", {|| 30}, 5 )
    Assert( "HTBrowse:columnCount 2 after second add", o:columnCount() == 2 )

    /* addColumn: TBColumn object form */
    oCol := TBColumnNew( "City", {|| "Paris"} )
    oCol:width := 12
    o:addColumn( oCol )
    Assert( "HTBrowse:columnCount 3 after TBColumn add", o:columnCount() == 3 )

    /* browse() accessor returns the underlying TBrowse */
    Assert( "HTBrowse:browse() not NIL",               o:browse() != NIL )
    Assert( "HTBrowse:browse():colCount == 3",          o:browse():colCount == 3 )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestBrowseCallbacks()

    LOCAL o
    LOCAL lSkipFired  := .F.
    LOCAL lTopFired   := .F.
    LOCAL lBotFired   := .F.

    o := HTBrowse():new()

    /* set navigation blocks — verify they are stored and callable */
    o:setSkipBlock(    {|n| lSkipFired := ( n != NIL ) } )
    o:setGoTopBlock(   {|| lTopFired   := .T. } )
    o:setGoBottomBlock({|| lBotFired   := .T. } )

    Eval( o:browse():skipBlock, 1 )
    Assert( "HTBrowse:setSkipBlock stored and callable", lSkipFired )

    Eval( o:browse():goTopBlock )
    Assert( "HTBrowse:setGoTopBlock stored and callable", lTopFired )

    Eval( o:browse():goBottomBlock )
    Assert( "HTBrowse:setGoBottomBlock stored and callable", lBotFired )

    /* callback properties writable */
    o:onActivated := {|r, c| lBotFired := ( r >= 0 .AND. c >= 0 ) }
    Assert( "HTBrowse:onActivated set",  o:onActivated != NIL )

    Assert( "HTBrowse:editable still .F.", ! o:editable )

RETURN
