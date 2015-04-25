/*
 *
 */

#include "hbtui.ch"

PROCEDURE Main()
    LOCAL app
    LOCAL win

    app := HTApplication():New()

    win := HTWindow():New()

    win:Show()

    app:Exec()

RETURN
