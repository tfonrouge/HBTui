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

    setBlink( .F. )

    FOR i := 1 TO 32
        x := i - 1
        FOR j := 1 TO 16
            y := (j - 1) * 5
            cColor := NToColor( n )
//            dispBox( x, y, x, y + 3, replicate( "@", 9 ), cColor )
            dispOutAt( x, y, cColor, cColor )
            ++n
        NEXT
    NEXT

    Inkey( 0 )

RETURN
