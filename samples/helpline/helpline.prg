/** @file helpline.prg
 * HBTui Help Line Demo - Per-widget context help in status bar
 *
 * Demonstrates the help line system: each widget has a helpLine text
 * that is automatically shown in the status bar when the widget
 * receives focus. Wire it with setHelpLineWidget() on the parent.
 *
 * Tab/Shift+Tab=navigate  ESC=quit
 */

#include "hbtui.ch"
#include "inkey.ch"

STATIC cName   := "                    "
STATIC cCity   := "                    "

PROCEDURE Main()

    LOCAL app, win, oSB
    LOCAL oGet, btnOk, btnCancel

    SetMode( 20, 55 )

    app := HTApplication():new()

    win := HTMainWindow():new()
    win:setWindowTitle( " Help Line Demo " )
    win:move( 1, 1 )
    win:resize( 53, 18 )

    oGet := HTGet():new( win )
    oGet:setup( {|x| IIF( x == NIL, cName, cName := x ) }, ;
                "Name:", "@!", NIL, NIL, ;
                "Enter the full name (auto uppercased)", ;
                NIL, .F., .F., 40 )
    oGet:move( 2, 2 )

    oGet := HTGet():new( win )
    oGet:setup( {|x| IIF( x == NIL, cCity, cCity := x ) }, ;
                "City:", NIL, NIL, NIL, ;
                "Enter the city of residence", ;
                NIL, .F., .F., 40 )
    oGet:move( 2, 4 )

    btnOk := HTPushButton():new( "OK", win )
    btnOk:move( 8, 7 )
    btnOk:helpLine := "Accept the form and save"
    btnOk:onClicked := {|| HTApplication():quit() }

    btnCancel := HTPushButton():new( "Cancel", win )
    btnCancel:move( 20, 7 )
    btnCancel:helpLine := "Discard changes and exit"
    btnCancel:onClicked := {|| HTApplication():quit() }

    oSB := HTStatusBar():new( win )
    oSB:move( 1, 16 )
    oSB:addSection( "Tab to navigate between fields" )

    /* wire the status bar as help line display for this window */
    win:setHelpLineWidget( oSB )

    win:show()
    app:exec()

RETURN
