/*
 *
 */

PROCEDURE Main()
    LOCAL i
    LOCAL j
    LOCAL x
    LOCAL y
    LOCAL n := 0
    LOCAL cColor

    CLS

    SetBlink( .F. )

    FOR i := 1 TO 32
        x := i - 1
        FOR j := 1 TO 16
            y := (j - 1) * 5
            cColor := NToColor( n )
//            DispBox( x, y, x, y + 3, Replicate( "@", 9 ), cColor )
            DispOutAt( x, y, cColor, cColor )
            ++n
        NEXT
    NEXT

    Inkey( 0 )

RETURN
