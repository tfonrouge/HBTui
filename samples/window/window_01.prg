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

    app := HTApplication():new()

    win := MainWindow():new()

    win:show()

    app:exec()

RETURN
