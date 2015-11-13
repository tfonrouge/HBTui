/*
 *
 */

#include "inkey.ch"

STATIC aColor

FUNCTION Main()

   LOCAL i, j
   LOCAL cColor
   LOCAL nKey
   LOCAL xPos, yPos

   aColor := {}

   SETMODE( 49,128 )
   CLS

   xPos := 0
   yPos := 0

   SETBLINK( .F. )

   FOR i := 0 TO 15

      AADD( aColor, { } )

      FOR j := 0 TO 15

         cColor := SETCOLOR( LTRIM( STR( i ) + '/' + LTRIM( STR( j ) ) ) )

         AADD( ATAIL( aColor ), cColor )

         DispOutAt( yPos,     xPos, PADC( LEFT( SETCOLOR(), AT( ',', SETCOLOR() ) -1 ), 8 ) )
         DispOutAt( yPos + 1, xPos, PADC( NToColor( ColorToN( SETCOLOR() ) ) , 8 ) )
         DispOutAt( yPos + 2, xPos, REPLICATE( CHR(196), 8 ) )

         xPos += 8

		NEXT

      xPos := 0
      yPos += 3

   NEXT

   SETCLEARB( CHR( 7 ) )
   WOpen( 0, 0, 1, 7, .T. )

   xPos := 1
   yPos := 1

   DO WHILE ( nKey != K_RETURN .AND. nKey != K_ESC )

   GetColor( yPos, xPos )

   nKey := INKEY( 0 )

      DO CASE
         CASE nKey == K_LEFT .AND. xPos > 1
            --xPos

         CASE nKey == K_RIGHT .AND. xPos < 16
            ++xPos

         CASE nKey == K_UP .AND. yPos > 1
            --yPos

         CASE nKey == K_DOWN .AND. yPos < 16
            ++yPos

      ENDCASE

      WMOVE( ( yPos - 1 ) * 3 , ( xPos - 1 ) * 8 )

   ENDDO

RETURN IIF( nKey == K_ESC, NIL, GetColor( yPos, xPos ) )

/*
   GetColor( yPos, xPos )
*/
FUNCTION GetColor( yPos, xPos )

   LOCAL cColor

   cColor := aColor[xPos,yPos]

RETURN ( cColor )
