/** @file browse.prg
 * HBTui Browse Demo - Data grid with inline editing and context menu
 *
 * Demonstrates HTBrowse with array-backed data, column definitions
 * with PICTURE formatting, head/column separators, inline cell editing
 * (F2 or type to start, Enter to accept, Esc to cancel), HTContextMenu
 * with View/Edit/Delete actions, and onActivated callback.
 *
 * Up/Down=navigate  F2/type=edit  Enter=accept  Esc=cancel  Right-click=menu
 */

#include "hbtui.ch"
#include "inkey.ch"

STATIC aData
STATIC nRecNo := 1
STATIC oStatusBar

PROCEDURE Main()

    LOCAL app, w1, brw, oCtxMenu

    SetMode( 25, 70 )

    aData := { ;
        { "PRJ-01", "Harbour",    "Language",  85000.00 }, ;
        { "PRJ-02", "HBTui",      "Framework", 12500.00 }, ;
        { "PRJ-03", "TBrowse",    "Component",  8200.00 }, ;
        { "PRJ-04", "CT Windows", "Library",    6700.00 }, ;
        { "PRJ-05", "GTxwc",      "Driver",     9400.00 }, ;
        { "PRJ-06", "hbmk2",      "Build Tool",11200.00 }, ;
        { "PRJ-07", "hbclass",    "OOP",        7800.00 }, ;
        { "PRJ-08", "hbct",       "Contrib",    5300.00 }  ;
    }

    app := HTApplication():new()

    w1 := HTMainWindow():new()
    w1:setWindowTitle( " Browse Demo " )
    w1:move( 1, 1 )
    w1:resize( 68, 23 )

    brw := HTBrowse():new( w1 )
    brw:move( 1, 1 )
    brw:resize( 65, 16 )
    brw:setGoTopBlock( {|| nRecNo := 1 } )
    brw:setGoBottomBlock( {|| nRecNo := Len( aData ) } )
    brw:setSkipBlock( {|n| ArraySkip( n ) } )

    /* columns use read/write blocks for inline editing support */
    brw:addColumn( "Code",   {|x| IIF( x == NIL, aData[ nRecNo, 1 ], aData[ nRecNo, 1 ] := x ) }, 7 )
    brw:addColumn( "Name",   {|x| IIF( x == NIL, aData[ nRecNo, 2 ], aData[ nRecNo, 2 ] := x ) }, 12 )
    brw:addColumn( "Type",   {|x| IIF( x == NIL, aData[ nRecNo, 3 ], aData[ nRecNo, 3 ] := x ) }, 10 )
    brw:addColumn( "Budget", {|x| IIF( x == NIL, aData[ nRecNo, 4 ], aData[ nRecNo, 4 ] := Val( x ) ) }, 12, "999,999.99" )

    brw:setHeadSep( e"\xC4" )
    brw:setColSep( e"\xB3" )

    /* enable inline editing (F2 or type to start) */
    brw:_editable( .T. )
    brw:onBeginEdit := {|r,c| UpdateStatus( "Editing row " + hb_ntos( r ) + " col " + hb_ntos( c ) ), .T. }
    brw:onEndEdit := {|r,c,xOld,xNew| HB_SYMBOL_UNUSED( r ), HB_SYMBOL_UNUSED( c ), UpdateStatus( "Saved: " + hb_CStr( xOld ) + " -> " + hb_CStr( xNew ) ), .T. }
    brw:onActivated := {|r| UpdateStatus( "Activated: " + aData[ nRecNo, 2 ] + " (row " + hb_ntos( r ) + ")" ) }

    oCtxMenu := HTContextMenu():new()
    oCtxMenu:addAction( "View Details" ):onTriggered := {|| UpdateStatus( "View: " + aData[ nRecNo, 2 ] ) }
    oCtxMenu:addAction( "Edit Record"  ):onTriggered := {|| brw:beginEdit( 0 ) }
    oCtxMenu:addSeparator()
    oCtxMenu:addAction( "Delete" ):onTriggered := {|| UpdateStatus( "Delete: " + aData[ nRecNo, 2 ] ) }
    brw:contextMenu := oCtxMenu

    oStatusBar := HTStatusBar():new( w1 )
    oStatusBar:move( 1, 21 )
    oStatusBar:addSection( "Ready" )
    oStatusBar:addSection( "F2=edit  Enter=accept  Esc=cancel  Right-click=menu" )

    w1:show()
    app:exec()

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

STATIC FUNCTION ArraySkip( nRequest )

    LOCAL nActual

    nActual := IIF( nRequest > 0, ;
        Min( nRequest, Len( aData ) - nRecNo ), ;
        Max( nRequest, 1 - nRecNo ) )
    nRecNo += nActual

RETURN nActual
