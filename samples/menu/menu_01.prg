/*
 *
 */

#include "hbtui.ch"

PROCEDURE Main()

    LOCAL app
    LOCAL win
    LOCAL menu

    SetMode( 30, 90 )

    app := HApplication():new()

    win := HMainWindow():new()

    menu := win:menuBar():addMenu("File")

    menu:addAction("New")
    menu:addAction("Open")
    menu:addAction("Print")
    menu:addSeparator()
    menu:addAction("Close")
    menu:addAction("Quit")

    menu := win:menuBar():addMenu("Edit")

    menu:addAction("Insert")
    menu:addAction("Delete")
    menu:addAction("Change")
    menu:addSeparator()
    menu:addAction("Authorize")

    win:show()

    app:exec()

RETURN
