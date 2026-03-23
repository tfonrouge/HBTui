/** @file controls.prg
 * HBTui Controls Demo - HTPushButton, HTCheckBox, HTRadioButton,
 * HTSpinner, HTComboBox, HTListBox with HTStatusBar feedback.
 * Tab/Shift+Tab=focus  Space=toggle/press  Arrows=navigate  ESC=quit
 */

#include "hbtui.ch"
#include "inkey.ch"

STATIC oStatusBar
STATIC oWindow

PROCEDURE Main()

    LOCAL app, w1, btn, chk, rdo, spn, cmb, lst, sep

    SetMode( 25, 55 )
    app := HTApplication():new()
    w1 := HTMainWindow():new()
    w1:setWindowTitle( " Controls Demo " )
    w1:move( 1, 1 )
    w1:resize( 53, 23 )
    oWindow := w1

    btn := HTPushButton():new( "Click Me", w1 )
    btn:move( 1, 1 )
    btn:onClicked := {|| UpdateStatus( "Button clicked!" ) }

    sep := HTSeparator():new( w1 )
    sep:move( 1, 3 )
    sep:resize( 51, 1 )
    HTLabel():new( "Options:", w1 ):move( 1, 4 )
    chk := HTCheckBox():new( "Enable notifications", w1 )
    chk:move( 1, 5 )
    chk:onToggled := {|l| UpdateStatus( "Notifications: " + IIF( l, "ON", "OFF" ) ) }
    chk := HTCheckBox():new( "Dark mode", w1 )
    chk:move( 1, 6 )
    chk:onToggled := {|l| ;
        IIF( l, HTTheme():loadDark(), HTTheme():loadDefault() ), ;
        oWindow:repaint(), ;
        UpdateStatus( "Dark mode: " + IIF( l, "ON", "OFF" ) ) ;
    }

    sep := HTSeparator():new( w1 )
    sep:move( 1, 8 )
    sep:resize( 51, 1 )
    HTLabel():new( "Priority:", w1 ):move( 1, 9 )
    rdo := HTRadioButton():new( "High", w1 )
    rdo:move( 1, 10 )
    rdo := HTRadioButton():new( "Normal", w1 )
    rdo:move( 1, 11 )
    rdo := HTRadioButton():new( "Low", w1 )
    rdo:move( 1, 12 )
    sep := HTSeparator():new( w1 )
    sep:move( 1, 14 )
    sep:resize( 51, 1 )
    spn := HTSpinner():new( w1 )
    spn:setup( "Rating", 0, 10, 1, 5 )
    spn:move( 1, 15 )
    spn:onChanged := {|n| UpdateStatus( "Rating: " + hb_ntos( n ) ) }
    HTLabel():new( "Category:", w1 ):move( 28, 4 )
    cmb := HTComboBox():new( w1 )
    cmb:move( 28, 5 )
    cmb:addItem( "General" )
    cmb:addItem( "Development" )
    cmb:addItem( "Testing" )
    cmb:addItem( "Documentation" )
    cmb:addItem( "Deployment" )
    cmb:onChanged := {|| UpdateStatus( "Category: " + cmb:currentText() ) }
    HTLabel():new( "Items:", w1 ):move( 28, 8 )
    lst := HTListBox():new( w1 )
    lst:move( 28, 9 )
    lst:resize( 22, 7 )
    lst:addItem( "Compile project" )
    lst:addItem( "Run test suite" )
    lst:addItem( "Fix bug #42" )
    lst:addItem( "Update docs" )
    lst:addItem( "Code review" )
    lst:addItem( "Deploy release" )
    lst:onChanged := {|nIdx| UpdateStatus( "Item: " + lst:itemText( nIdx ) ) }

    oStatusBar := HTStatusBar():new( w1 )
    oStatusBar:move( 1, 21 )
    oStatusBar:addSection( "Ready" )
    oStatusBar:addSection( "Tab=navigate  Space=toggle  ESC=quit" )
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
