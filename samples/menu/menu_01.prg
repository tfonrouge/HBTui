/*
 *
 */

#include "hbtui.ch"

PROCEDURE Main()
    LOCAL app
    LOCAL win
    LOCAL menu

    setMode( 40, 100 )

    app := HTApplication():new()

    win := HTMainWindow():new()

    AltD()

    menu := win:menuBar():addMenu("File")

    menu:addMenu("New")
    menu:addMenu("Open")
    menu:addMenu("Print")
    menu:addSeparator()
    menu:addMenu("Close")
    menu:addAction("Quit")

    menu := win:menuBar():addMenu("Edit")

    menu:addMenu("Insert")
    menu:addMenu("Delete")
    menu:addMenu("Change")
    menu:addSeparator()
    menu:addAction("Authorize")

    win:show()

    app:exec()

RETURN
