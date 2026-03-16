/*
 * Full controls test: Labels, CheckBox, RadioButton, PushButton, TBrowse
 *
 * Tab / Shift+Tab to cycle focus
 * Space to toggle checkboxes / select radio buttons
 * Arrow keys to navigate browse when focused
 * Mouse click to focus any control
 */

#include "hbtui.ch"

/* sample data for TBrowse */
STATIC aData
STATIC nRecNo := 1

PROCEDURE Main()

    LOCAL app
    LOCAL w1
    LOCAL brw

    SetMode( 35, 90 )

    /* sample data */
    aData := { ;
        { "001", "Harbour",     "Programming Language" }, ;
        { "002", "HBTui",       "TUI Framework"        }, ;
        { "003", "TBrowse",     "Data Browser"          }, ;
        { "004", "CT Windows",  "Window System"         }, ;
        { "005", "GTxwc",       "Terminal Driver"       }, ;
        { "006", "hbmk2",       "Build System"          }, ;
        { "007", "hbclass",     "OOP Support"           }, ;
        { "008", "hbct",        "Clipper Tools"         }, ;
        { "009", "xHarbour",    "Extended Harbour"      }, ;
        { "010", "Clipper",     "Original Language"     }, ;
        { "011", "dBase",       "Database System"       }, ;
        { "012", "FoxPro",      "RAD Tool"              }  ;
    }

    app := HTApplication():new()

    w1 := HTMainWindow():new()
    w1:setWindowTitle( "HBTui Controls Demo" )
    w1:move( 3, 1 )
    w1:resize( 80, 30 )

    /* --- Labels --- */
    HTLabel():new( "Options:", w1 ):move( 1, 1 )

    /* --- CheckBoxes --- */
    HTCheckBox():new( "Show headers", w1 ):move( 1, 3 )
    HTCheckBox():new( "Enable color", w1 ):move( 1, 4 )
    HTCheckBox():new( "Auto-save", w1 ):move( 1, 5 )

    /* --- Radio Buttons --- */
    HTLabel():new( "Sort by:", w1 ):move( 22, 1 )
    HTRadioButton():new( "Code", w1 ):move( 22, 3 )
    HTRadioButton():new( "Name", w1 ):move( 22, 4 )
    HTRadioButton():new( "Type", w1 ):move( 22, 5 )

    /* --- TBrowse --- */
    HTLabel():new( "Data Browser:", w1 ):move( 1, 7 )

    brw := HTBrowse():new( w1 )
    brw:move( 1, 9 )

    brw:setGoTopBlock( {|| nRecNo := 1 } )
    brw:setGoBottomBlock( {|| nRecNo := Len( aData ) } )
    brw:setSkipBlock( {|n| ArraySkip( n ) } )

    brw:addColumn( "Code", {|| aData[ nRecNo, 1 ] }, 6 )
    brw:addColumn( "Name", {|| aData[ nRecNo, 2 ] }, 16 )
    brw:addColumn( "Description", {|| aData[ nRecNo, 3 ] }, 25 )

    brw:setHeadSep( e"\xC4" )
    brw:setColSep( " " + e"\xB3" + " " )

    /* --- Push Buttons --- */
    HTPushButton():new( "OK", w1 ):move( 1, 22 )
    HTPushButton():new( "Cancel", w1 ):move( 10, 22 )
    HTPushButton():new( "Help", w1 ):move( 21, 22 )

    w1:show()

    app:exec()

RETURN

/*
    ArraySkip - skip function for array-based TBrowse
*/
STATIC FUNCTION ArraySkip( nRequest )

    LOCAL nActual

    nActual := IIF( nRequest > 0, ;
        Min( nRequest, Len( aData ) - nRecNo ), ;
        Max( nRequest, 1 - nRecNo ) )

    nRecNo += nActual

RETURN nActual
