/*
 *
 */

#include "hbtui.ch"
#include "inkey.ch"

CLASS HTTextEdit FROM HTWidget

   DATA nTop
   DATA nLeft
   DATA nBottom
   DATA nRight

   DATA nRow         INIT 1        // aktualny numer wiersza
   DATA nCol         INIT 1        // aktualny numer kolumny
   DATA nRowWin      INIT 1        // pozycja kursora w oknie
   DATA nColWin      INIT 1        // pozycja kursora w oknie
   DATA nNumRows
   DATA nNumCols

   //DATA mode         INIT .F.

   METHOD New( nTop, nLeft, nBottom, nRight ) CONSTRUCTOR

   METHOD up()
   METHOD down()
   METHOD right()
   METHOD left()
   METHOD pageUp()
   METHOD pageDown()
   METHOD home()
   METHOD end()
   METHOD pageHome()
   METHOD pageEnd()
   METHOD wordRight()
   METHOD wordLeft()

   METHOD moveCursor( nKey )

   METHOD refresh()
   METHOD fileOpen()


ENDCLASS
/*
   New()
*/
METHOD New( nTop, nLeft, nBottom, nRight ) CLASS HTTextEdit

   ::nTop    := nTop
   ::nLeft   := nLeft
   ::nBottom := nBottom
   ::nRight  := nRight

   ::nNumCols := ::nRight - ::nLeft + 1
   ::nNumRows := ::nBottom - ::nTop + 1

RETURN ( Self )

/*
   up()
   Moves the cursor one line up.
   K_UP
*/
METHOD up() CLASS HTTextEdit

   ::nRow--

   IF ::nRowWin < ::nTop + 1
      ::refresh()
   ELSE
      SETPOS( ::nTop + ::nRow - ::nRowWin, ::nLeft + ::nCol - ::nColWin )
   ENDIF

RETURN ( Self )
/*
   down()
   Moves the cursor one line down.
   K_DOWN
*/
METHOD down() CLASS HTTextEdit

   ::nRow++

   IF ::nColWin > ( ::nBottom - ::nTop + 1 )
      ::refresh()
   ELSE
      SETPOS( ::nTop + ::nRow - ::nRowWin, ::nLeft + ::nCol - ::nColWin )
   ENDIF

RETURN ( Self )
/*
   right()
   Moves the cursor one character to the right.
   K_RIGHT
*/
METHOD right() CLASS HTTextEdit

   ::nCol++

   SETPOS( ::nTop + ::nRow - ::nRowWin, ::nLeft + ::nCol - ::nColWin )

RETURN ( Self )
/*
   left()
   Moves the cursor one character to the left.
   K_LEFT
*/
METHOD left() CLASS HTTextEdit

   ::nCol--

   IF ::nColWin < ::nLeft + 1
      ::refresh()
   ELSE
      SETPOS( ::nTop + ::nRow - ::nRowWin, ::nLeft + ::nCol - ::nColWin )
   ENDIF

RETURN ( Self )
/*
   pageUp()
   Moves the cursor one page up.
   K_PGUP
*/
METHOD pageUp() CLASS HTTextEdit

   SETPOS( ::nRow - ::nNumRows + 1, ::nCol )

   ::refresh()

RETURN ( Self )
/*
   pageDown()
   Moves the cursor one page down.
   K_PGDN
*/
METHOD pageDown() CLASS HTTextEdit

   SETPOS( ::nRow + ::nNumRows - 1, ::nCol )

	::refresh()

RETURN ( Self )
/*
   home()
   Moves the cursor to the beginning of the line.
   K_HOME
*/
METHOD home() CLASS HTTextEdit

   ::nCol := 1

   SETPOS( ::nRow, ::nCol )

   ::refresh()

RETURN ( Self )
/*
   end()
   Moves the cursor to the end of the line.
   K_END
*/
METHOD end() CLASS HTTextEdit

   ::nCol := -1

   SETPOS( ::nRow, ::nCol )

   ::refresh()

RETURN ( Self )
/*
   pageHome()
   Moves the cursor to the beginning of the text.
   K_CTRL_HOME
*/
METHOD pageHome() CLASS HTTextEdit

   ::nCol := 1

   SETPOS( ::nRowWin, ::nCol )

   ::refresh()

RETURN ( Self )
/*
   pageEnd()
   Moves the cursor to the end of the text.
   K_CTRL_END
*/
METHOD pageEnd() CLASS HTTextEdit

   ::nCol := 1

   SETPOS( ::nRowWin + ::nNumRows - 1, -1 )

RETURN ( Self )
/*
   wordRight()
   Moves the cursor one word to the right.
   K_CTRL_RIGHT
*/
METHOD wordRight() CLASS HTTextEdit

RETURN ( Self )
/*
   wordLeft()
   Moves the cursor one word to the left.
   K_CTRL_LEFT
*/
METHOD wordLeft() CLASS HTTextEdit

RETURN ( Self )
/*
   moveCursor()
*/
METHOD moveCursor( nKey )

   DO CASE
      CASE nKey == K_UP
         ::up()

      CASE nKey == K_DOWN
         ::down()

      CASE nKey == K_RIGHT
         ::right()

      CASE nKey == K_LEFT
         ::left()

      CASE nKey == K_PGUP
         ::pageUp()

      CASE nKey == K_PGDN
         ::pageDown()

      CASE nKey == K_HOME
         ::home()

      CASE nKey == K_END
         ::end()

      CASE nKey == K_CTRL_HOME
         ::pageHome()

      CASE nKey == K_CTRL_END
         ::pageEnd()

      CASE nKey == K_CTRL_RIGHT
         ::wordRight()

      CASE nKey == K_CTRL_LEFT
         ::wordLeft()

      OTHERWISE

	      RETURN( .F. )

    ENDCASE

RETURN ( .T. )
/*
   refresh()
   Causes all data to be refreshed during the next stabilize
*/
METHOD refresh() CLASS HTTextEdit

RETURN( Self )
/*
   fileOpen()

*/
METHOD fileOpen() CLASS HTTextEdit


RETURN ( Self )
