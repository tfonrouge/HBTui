/*
 *
 */

#include "hbtui.ch"

CLASS MyMainWindow FROM HTMainWindow
PROTECTED:
PUBLIC:
    CONSTRUCTOR New( ... )
ENDCLASS

METHOD New( ... ) CLASS MyMainWindow
    LOCAL menuBar
    LOCAL menu

    ::Super:New( ... )

    menuBar := ::menuBar

    menu := menuBar:addMenu( "File" )
    menu:addAction( "New File" )
    menu:addAction( "Close File" )
    menu:addSeparator()
    menu:addAction( "Exit" )

    menu := menuBar:addMenu( "Edit" )
    menu:addAction( "Insert" )
    menu:addAction( "Delete" )
    menu:addAction( "Edit" )

RETURN Self

PROCEDURE Main()
    LOCAL app
    LOCAL w1,w2,w3
    LOCAL t
    LOCAL btn

    SetMode( 40, 120 )

    app := HTApplication():New()

    w1 := MyMainWindow():New()
    w1:setWindowTitle( "Window 1" )
    w1:move( 10, 5 )
    w1:resize( 60, 20 )

    w2 := MyMainWindow():New()
    w2:setWindowTitle( "Window 2" )
    w2:color := "10/02"
    w2:move( 13, 7 )
    w2:resize( 60, 20 )

    w3 := MyMainWindow():New()
    w3:setWindowTitle( "Window 3" )
    w3:color := "14/05"
    w3:move( 16, 9 )
    w3:resize( 60, 20 )

    t := HTLineEdit():New( "Text ONE", w1 )
    t:move( 0, 0 )

    t := HTLineEdit():New( "Text TWO", w2 )
    t:move( 0, 0 )

    t := HTLineEdit():New( "Text THREE", w3 )
    t:move( 0, 0 )

    btn := HTPushButton():New( "Ok", w1 )
    btn:Move( 3, 0 )

    w1:show()
    w2:show()
    w3:show()

    app:exec()

RETURN
