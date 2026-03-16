/*
 * Focus chain + viewport child painting test
 * Tab/Shift+Tab cycles focus between buttons
 */

#include "hbtui.ch"

PROCEDURE Main()

    LOCAL app
    LOCAL w1
    LOCAL lbl1, lbl2
    LOCAL btn1, btn2, btn3

    SetMode( 30, 80 )

    app := HTApplication():new()

    w1 := HTMainWindow():new()
    w1:setWindowTitle( "Focus Test" )
    w1:move( 5, 2 )

    /* labels (not focusable) */
    lbl1 := HTLabel():new( "Name:", w1 )
    lbl1:move( 1, 1 )

    lbl2 := HTLabel():new( "Use Tab/Shift+Tab to cycle focus", w1 )
    lbl2:move( 1, 3 )

    /* buttons (focusable) */
    btn1 := HTPushButton():new( "OK", w1 )
    btn1:move( 1, 5 )

    btn2 := HTPushButton():new( "Cancel", w1 )
    btn2:move( 10, 5 )

    btn3 := HTPushButton():new( "Help", w1 )
    btn3:move( 21, 5 )

    w1:show()

    app:exec()

RETURN
