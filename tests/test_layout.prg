/**
 * test_layout.prg - Tests for HTBoxLayout item management.
 *
 * Note: doLayout() writes to PROTECTED widget DATA (Fx, Fy, Fwidth, Fheight)
 * which only works when called from within HTWidget:displayLayout().
 * These tests verify item management and structure, not coordinate calculations.
 *
 * Build: hbmk2 test_layout.prg hbmk.hbm
 */

#include "hbtui.ch"

STATIC nPass := 0
STATIC nFail := 0

PROCEDURE Main()

    LOCAL nTotal

    TestBoxLayoutItems()
    TestBoxLayoutStretch()
    TestGridLayoutItems()

    nTotal := nPass + nFail
    QOut( "" )
    QOut( "Results: " + hb_ntos( nPass ) + " passed, " + hb_ntos( nFail ) + " failed out of " + hb_ntos( nTotal ) )
    ErrorLevel( IIF( nFail > 0, 1, 0 ) )

RETURN

STATIC PROCEDURE Assert( cName, lCond )
    IF lCond
        nPass++
    ELSE
        nFail++
        QOut( "FAIL: " + cName )
    ENDIF
RETURN

/** Verify HTBoxLayout item management */
STATIC PROCEDURE TestBoxLayoutItems()

    LOCAL oLayout
    LOCAL oW1 := HTWidget():new()
    LOCAL oW2 := HTWidget():new()

    oLayout := HTBoxLayout():new( 2 )

    Assert( "BoxLayout empty widgetList", Len( oLayout:widgetList() ) == 0 )

    oLayout:addWidget( oW1 )
    Assert( "BoxLayout 1 widget", Len( oLayout:widgetList() ) == 1 )

    oLayout:addWidget( oW2 )
    Assert( "BoxLayout 2 widgets", Len( oLayout:widgetList() ) == 2 )

    Assert( "BoxLayout widgetList[1]", oLayout:widgetList()[ 1 ] == oW1 )
    Assert( "BoxLayout widgetList[2]", oLayout:widgetList()[ 2 ] == oW2 )

    Assert( "BoxLayout direction", oLayout:direction == 2 )

RETURN

/** Verify stretch/spacing don't appear in widgetList */
STATIC PROCEDURE TestBoxLayoutStretch()

    LOCAL oLayout
    LOCAL oW1 := HTWidget():new()
    LOCAL oW2 := HTWidget():new()

    oLayout := HTBoxLayout():new( 0 )
    oLayout:addWidget( oW1 )
    oLayout:addStretch()
    oLayout:addSpacing( 2 )
    oLayout:addWidget( oW2 )

    /* widgetList only returns actual widgets, not stretches/spacers */
    Assert( "Stretch widgetList count", Len( oLayout:widgetList() ) == 2 )
    Assert( "Stretch widgetList[1]", oLayout:widgetList()[ 1 ] == oW1 )
    Assert( "Stretch widgetList[2]", oLayout:widgetList()[ 2 ] == oW2 )

RETURN

/** Verify HTGridLayout item management */
STATIC PROCEDURE TestGridLayoutItems()

    LOCAL oLayout
    LOCAL oW1 := HTWidget():new()
    LOCAL oW2 := HTWidget():new()

    oLayout := HTGridLayout():new()

    Assert( "GridLayout empty", Len( oLayout:widgetList() ) == 0 )
    Assert( "GridLayout rowCount 0", oLayout:rowCount == 0 )
    Assert( "GridLayout colCount 0", oLayout:colCount == 0 )

    oLayout:addWidget( oW1, 0, 0 )
    Assert( "GridLayout 1 widget", Len( oLayout:widgetList() ) == 1 )
    Assert( "GridLayout rowCount 1", oLayout:rowCount == 1 )
    Assert( "GridLayout colCount 1", oLayout:colCount == 1 )

    oLayout:addWidget( oW2, 1, 2, 2, 3 )
    Assert( "GridLayout 2 widgets", Len( oLayout:widgetList() ) == 2 )
    Assert( "GridLayout rowCount 3", oLayout:rowCount == 3 )
    Assert( "GridLayout colCount 5", oLayout:colCount == 5 )

RETURN
