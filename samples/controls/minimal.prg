/*
 * Minimal test: one window, one label
 */

#include "hbtui.ch"

PROCEDURE Main()

    LOCAL app
    LOCAL w1
    LOCAL lbl

    SetMode( 30, 80 )

    app := HTApplication():new()

    w1 := HTMainWindow():new()
    w1:setWindowTitle( "Minimal" )

    lbl := HTLabel():new( "Hello World!", w1 )
    lbl:move( 2, 2 )

    w1:show()

    app:exec()

RETURN
