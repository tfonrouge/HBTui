/*
 *
 */

#include "hbtui.ch"

CLASS MainWindow FROM HTMainWindow
PROTECTED:
PUBLIC:
ENDCLASS

PROCEDURE Main()
    LOCAL app
    LOCAL win
    LOCAL i
    LOCAL j
    LOCAL x
    LOCAL y
    LOCAL n := 0
    LOCAL cColor

    app := HTApplication():New()

    FOR i := 1 TO 16
        x := i - 1
        FOR j := 1 TO 16
            y := (j - 1) * 5
            cColor := NToColor( n )
//            DispBox( x, y, x, y + 3, Replicate( "@", 9 ), cColor )
            DispOutAt( x, y, cColor, cColor )
            OutStd( n, cColor, e"\n" )
            ++n
        NEXT
    NEXT

    Inkey( 0 )

    win := MainWindow():New()

    win:Show()

    app:Exec()

RETURN
