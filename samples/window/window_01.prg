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

    app := HTApplication():New()

    win := MainWindow():New()

    win:show()

    app:exec()

RETURN
