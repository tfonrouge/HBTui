/*
 *
 */

#include "hbtui.ch"
#include "inkey.ch"

FUNCTION Main()

   LOCAL oTextEdit
   LOCAL nKey

   CLEAR SCREEN
   WOpen( 0, 0, MAXROW(), MAXCOL() )

   oTextEdit := HTTextEdit():New( 0, 0, MAXROW(), MAXCOL() )

   DO WHILE ( .T. )

	nKey := INKEY(0)

	   oTextEdit:moveCursor( nKey )

   ENDDO

   WClose()

RETURN ( NIL )
