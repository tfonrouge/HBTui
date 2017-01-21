/*
 *
 */

#include "hbtui.ch"

CLASS MainWindow FROM HTMainWindow
PROTECTED:
PUBLIC:
ENDCLASS

PROCEDURE Main()
    LOCAL app
    LOCAL win
    LOCAL i

    SetMode( 40, 100 )

    app := HTApplication():new()

    FOR i := 1 TO 3
        win := MakeWindow()
        win:show()
    NEXT

    app:exec()

RETURN

STATIC FUNCTION MakeWindow()
    LOCAL w

    w := MainWindow():new()

RETURN w
