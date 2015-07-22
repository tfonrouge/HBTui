/*
 *
 */

#include "inkey.ch"

FUNCTION Main()
   LOCAL i
   LOCAL j
   LOCAL y
   LOCAL x
   LOCAL n := 0
   LOCAL cColor
   LOCAL nKey
   LOCAL nCursor := SETCURSOR( 0 )

   CLS

   SetBlink( .F. )

   FOR i := 1 TO 32

      y := i - 1

      FOR j := 1 to 16

         x := (j - 1) * 5

         cColor := nToColor( n )

         DispOutAt( y, x, cColor, cColor )

         ++n

      NEXT

   NEXT

   DO WHILE ( nKey != K_ESC .AND. nKey != K_RETURN )

      @ y, x SAY "     " // COLOR cColor + "I" SelectColor( y, x )

      nKey := INKEY(0)

      DO CASE
         CASE nKey == K_DOWN
            y++
         CASE nKey == K_UP
            y--
         CASE nKey == K_RIGHT
            x++
         CASE nKey == K_LEFT
            x--
      ENDCASE

      y := MAX( 0, MIN( y, 16 ) )
      x := MAX( 0, MIN( x, 16 ) )

   ENDDO

   SETCURSOR( nCursor )

RETURN NIL // ( IF( nKey == K_ESC, Nil, SelectColor( y, x ) ) )

FUNCTION SelectColor(  ) // y, x


RETURN NIL // color
