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
    AltD()
    w1:move( 5, 5 )
    w1:resize( 40, 20 )

    w2 := HTWidget():New()
    w2:setWindowTitle( "Window 2" )
    w2:color := "10/02"
    w2:move( 7, 8 )
    w2:resize( 40, 20 )

    w3 := HTWidget():New()
    w3:setWindowTitle( "Window 3" )
    w3:color := "14/05"
    w3:move( 9, 11 )
    w3:resize( 40, 20 )

    t := HTTextLine():New( w1, "Text ONE" )
    t:move( 0, 0 )

    t := HTTextLine():New( w2, "Text TWO" )
    t:move( 0, 0 )

    t := HTTextLine():New( w3, "Text THREE" )
    t:move( 0, 0 )

    btn := HTPushButton():New( w1 )
    btn:Move( 3, 0 )
    btn:text := "Ok"

    w1:Show()
    w2:Show()
    w3:Show()

    app:Exec()

RETURN
