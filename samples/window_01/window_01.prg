/*
 *
 */

#include "hbtui.ch"

PROCEDURE Main()
    LOCAL oApp
    LOCAL oWin
    LOCAL oBtn

    oApp := HTApplication():New()

    oWin := HTWindow():New()

    btn := HTPushButton():New( oWin )
    btn:text := "Ok"

    w1:Show()

    app:Exec()

RETURN
