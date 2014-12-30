/*
 *
 */

#include "hbtui.ch"

PROCEDURE Main()
    LOCAL app
    LOCAL w1,w2,w3
    LOCAL t
    LOCAL btn

    app := HBTui_App():New()

    w1 := HBTui_Widget():New()
    w1:x := 5
    w1:y := 5
    w1:height := 20
    w1:width := 40

    w2 := HBTui_Widget():New()
    w2:x := 7
    w2:y := 8
    w2:height := 20
    w2:width := 40

    w3 := HBTui_Widget():New()
    w3:x := 9
    w3:y := 11
    w3:height := 20
    w3:width := 40


    t := HBTui_TextLine():New( w1, "Text ONE" )
    t:x := 0 ; t:y := 0
    t := HBTui_TextLine():New( w2, "Text TWO" )
    t:x := 0 ; t:y := 0
    t := HBTui_TextLine():New( w3, "Text THREE" )
    t:x := 0 ; t:y := 0

    btn := HBTui_PushButton():New( w1 )
    btn:x := 3 ; btn:y := 0
    btn:text := "Ok"

    w1:Show()
    w2:Show()
    w3:Show()

    app:Exec()

RETURN
