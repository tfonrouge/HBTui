/** @file browse.prg
 * HBTui Browse Demo - Data grid with context menu
 *
 * Demonstrates HTBrowse with array-backed data, column definitions
 * with PICTURE formatting, head/column separators, HTContextMenu
 * with View/Edit/Delete actions, and onActivated callback.
 *
 * Up/Down=navigate  Enter=activate  Right-click=menu  ESC=quit
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
    brw:addColumn( "Code",   {|| aData[ nRecNo, 1 ] }, 7 )
    brw:addColumn( "Name",   {|| aData[ nRecNo, 2 ] }, 12 )
    brw:addColumn( "Type",   {|| aData[ nRecNo, 3 ] }, 10 )
    brw:addColumn( "Budget", {|| aData[ nRecNo, 4 ] }, 12, "999,999.99" )
    brw:setHeadSep( e"\xC4" )
    brw:setColSep( e"\xB3" )
    brw:onActivated := {|r| UpdateStatus( "Activated: " + aData[ nRecNo, 2 ] + " (row " + hb_ntos( r ) + ")" ) }

    oCtxMenu := HTContextMenu():new()
    oCtxMenu:addAction( "View Details" ):onTriggered := {|| UpdateStatus( "View: " + aData[ nRecNo, 2 ] ) }
    oCtxMenu:addAction( "Edit Record"  ):onTriggered := {|| UpdateStatus( "Edit: " + aData[ nRecNo, 2 ] ) }
    oCtxMenu:addSeparator()
    oCtxMenu:addAction( "Delete" ):onTriggered := {|| UpdateStatus( "Delete: " + aData[ nRecNo, 2 ] ) }
    brw:contextMenu := oCtxMenu

    oStatusBar := HTStatusBar():new( w1 )
    oStatusBar:move( 1, 21 )
    oStatusBar:addSection( "Ready" )
    oStatusBar:addSection( "Enter=activate  Right-click=menu  ESC=quit" )

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
