/*
 * Full controls demo: ListBox, ComboBox, enhanced menus, Dialog
 *
 * Tab / Shift+Tab to cycle focus
 * F10 to activate menu bar
 * Space to toggle checkboxes / open combo dropdown
 * Arrow keys to navigate browse/listbox/combo
 * Mouse click on any control
 */

#include "hbtui.ch"
#include "inkey.ch"

/* sample data for TBrowse */
STATIC aData
STATIC nRecNo := 1

PROCEDURE Main()

    LOCAL app
    LOCAL w1
    LOCAL brw, lst, cmb
    LOCAL menuBar, menu

    SetMode( 35, 90 )

    aData := { ;
        { "001", "Harbour",     "Programming Language" }, ;
        { "002", "HBTui",       "TUI Framework"        }, ;
        { "003", "TBrowse",     "Data Browser"          }, ;
        { "004", "CT Windows",  "Window System"         }, ;
        { "005", "GTxwc",       "Terminal Driver"       }, ;
        { "006", "hbmk2",       "Build System"          }, ;
        { "007", "hbclass",     "OOP Support"           }, ;
        { "008", "hbct",        "Clipper Tools"         }  ;
    }

    app := HTApplication():new()

    w1 := HTMainWindow():new()
    w1:setWindowTitle( "HBTui Controls Demo v2" )
    w1:move( 3, 1 )
    w1:resize( 82, 30 )

    /* --- Menus --- */
    menuBar := w1:menuBar
    menu := menuBar:addMenu( "File" )
    menu:addAction( "New" )
    menu:addAction( "Open" )
    menu:addSeparator()
    menu:addAction( "Exit" )
    menu := menuBar:addMenu( "Edit" )
    menu:addAction( "Cut" )
    menu:addAction( "Copy" )
    menu:addAction( "Paste" )
    menu := menuBar:addMenu( "Help" )
    menu:addAction( "About" )

    /* --- Left column: ListBox --- */
    HTLabel():new( "ListBox:", w1 ):move( 1, 1 )

    lst := HTListBox():new( w1 )
    lst:move( 1, 2 )
    lst:addItem( "Apple" )
    lst:addItem( "Banana" )
    lst:addItem( "Cherry" )
    lst:addItem( "Date" )
    lst:addItem( "Elderberry" )
    lst:addItem( "Fig" )
    lst:addItem( "Grape" )
    lst:addItem( "Honeydew" )

    /* --- ComboBox --- */
    HTLabel():new( "ComboBox:", w1 ):move( 1, 9 )

    cmb := HTComboBox():new( w1 )
    cmb:move( 1, 10 )
    cmb:addItem( "Red" )
    cmb:addItem( "Green" )
    cmb:addItem( "Blue" )
    cmb:addItem( "Yellow" )
    cmb:addItem( "Cyan" )
    cmb:addItem( "Magenta" )

    /* --- CheckBoxes --- */
    HTCheckBox():new( "Option A", w1 ):move( 1, 12 )
    HTCheckBox():new( "Option B", w1 ):move( 1, 13 )

    /* --- Radio Buttons --- */
    HTLabel():new( "Mode:", w1 ):move( 1, 15 )
    HTRadioButton():new( "Fast", w1 ):move( 1, 16 )
    HTRadioButton():new( "Normal", w1 ):move( 1, 17 )
    HTRadioButton():new( "Safe", w1 ):move( 1, 18 )

    /* --- Right column: TBrowse --- */
    HTLabel():new( "Data:", w1 ):move( 25, 1 )

    brw := HTBrowse():new( w1 )
    brw:move( 25, 2 )

    brw:setGoTopBlock( {|| nRecNo := 1 } )
    brw:setGoBottomBlock( {|| nRecNo := Len( aData ) } )
    brw:setSkipBlock( {|n| ArraySkip( n ) } )

    brw:addColumn( "Code", {|| aData[ nRecNo, 1 ] }, 6 )
    brw:addColumn( "Name", {|| aData[ nRecNo, 2 ] }, 16 )
    brw:addColumn( "Type", {|| aData[ nRecNo, 3 ] }, 20 )

    brw:setHeadSep( e"\xC4" )
    brw:setColSep( " " + e"\xB3" + " " )

    /* --- Buttons --- */
    HTPushButton():new( "OK", w1 ):move( 1, 21 )
    HTPushButton():new( "Cancel", w1 ):move( 10, 21 )

    w1:show()

    app:exec()

RETURN

STATIC FUNCTION ArraySkip( nRequest )

    LOCAL nActual

    nActual := IIF( nRequest > 0, ;
        Min( nRequest, Len( aData ) - nRecNo ), ;
        Max( nRequest, 1 - nRecNo ) )

    nRecNo += nActual

RETURN nActual
