/** @file hello.prg
 * Hello World - Minimal HBTui application
 *
 * Demonstrates:
 *   - HTMainWindow with a title
 *   - HTLabel for static text
 *   - HTStatusBar with version info
 *
 * Keyboard:
 *   ESC - quit
 */

#include "hbtui.ch"
#include "inkey.ch"

PROCEDURE Main()

    LOCAL app, win, lbl, oSB

    SetMode( 15, 50 )

    app := HTApplication():new()

    win := HTMainWindow():new()
    win:setWindowTitle( " Hello HBTui " )
    win:move( 1, 1 )
    win:resize( 45, 11 )

    lbl := HTLabel():new( "Hello, World!", win )
    lbl:move( 16, 3 )
    lbl:setAlignment( HT_ALIGN_CENTER )

    lbl := HTLabel():new( "Press ESC to quit", win )
    lbl:move( 14, 5 )
    lbl:setAlignment( HT_ALIGN_CENTER )

    oSB := HTStatusBar():new( win )
    oSB:move( 1, 8 )
    oSB:addSection( "HBTui v0.3" )

    win:show()
    app:exec()

RETURN
