/*
 *
 */

#include "hbtui.ch"

PROCEDURE Main()
    LOCAL app
    LOCAL win
    LOCAL menu

    app := HTApplication():new()

    win := HTMainWindow():new()

    menu := win:menuBar():addMenu("File")

    menu:addMenu("New")
    menu:addMenu("Open")
    menu:addMenu("Print")
    menu:addSeparator()
    menu:addMenu("Close")
    menu:addAction("Quit")

    win:show()

    app:exec()

RETURN
