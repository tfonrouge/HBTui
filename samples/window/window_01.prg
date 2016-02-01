/*
 *
 */

#include "hbtui.ch"

CLASS MainWindow FROM HMainWindow
PROTECTED:
PUBLIC:
ENDCLASS

PROCEDURE Main()
    LOCAL app
    LOCAL win

    SetMode( 40, 100 )

    app := HApplication():new()

    win := MainWindow():new()

    win:show()

    app:exec()

RETURN
