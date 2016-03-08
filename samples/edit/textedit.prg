/*
 *
 */

#include "hbtui.ch"
#include "inkey.ch"

FUNCTION Main()

   LOCAL oTextEdit
   LOCAL nKey

   CLEAR SCREEN
   WOpen( 0, 0, MaxRow(), MaxCol() )

   oTextEdit := HTTextEdit():New( 0, 0, MaxRow(), MaxCol() )

   DO WHILE ( .T. )

	nKey := InKey(0)

	   oTextEdit:moveCursor( nKey )

   ENDDO

   WClose()

RETURN ( NIL )
