/*
 *
 */

#include "hbtui.ch"

PROCEDURE Main()
    LOCAL app
    LOCAL w1,w2,w3
    LOCAL t
    LOCAL btn

    SetMode( 40, 120 )

    app := HTApplication():New()

    w1 := HTWidget():New()
    w1:setWindowTitle( "Window 1" )
    w1:move( 10, 5 )
    w1:resize( 60, 20 )

    w2 := HTWidget():New()
    w2:setWindowTitle( "Window 2" )
    w2:color := "10/02"
    w2:move( 13, 7 )
    w2:resize( 60, 20 )

    w3 := HTWidget():New()
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

    w1:Show()
    w2:Show()
    w3:Show()

    app:Exec()

RETURN
