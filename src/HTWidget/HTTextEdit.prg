/*
 *
 */
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

   METHOD New( nTop, nLeft, nBottom, nRight ) CONSTRUCTOR

   METHOD up()
   METHOD down()
   METHOD right()
   METHOD left()
   METHOD pageUp
   METHOD pageDown
   METHOD home
   METHOD end
   METHOD goTop
   METHOD goBottom
   METHOD wordRight
   METHOD wordLeft
   METHOD pageHome
   METHOD pageEnd

   METHOD moveCursor

   METHOD refresh

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
   Moves the cursor up one row
*/
METHOD up() CLASS HTTextEdit

   ::nRow--

   SETPOS( ::nTop + ::nRow - ::nRowWin, ::nLeft + ::nCol - ::nColWin )

RETURN ( Self )
/*
   down()
   Moves the cursor down one row
*/
METHOD down() CLASS HTTextEdit

   ::nRow++

   SETPOS( ::nTop + ::nRow - ::nRowWin, ::nLeft + ::nCol - ::nColWin )

RETURN ( Self )
/*
   right()
   Moves the cursor right one column
*/
METHOD right() CLASS HTTextEdit

   ::nCol++

   SETPOS( ::nTop + ::nRow - ::nRowWin, ::nLeft + ::nCol - ::nColWin )

RETURN ( Self )
/*
   left()
   Moves the cursor left one column
*/
METHOD left() CLASS HTTextEdit

   ::nCol--

   IF ::nColWin <= 1
      ::refresh()
   ELSE
      SETPOS( ::nTop + ::nRow - ::nRowWin, ::nLeft + ::nCol - ::nColWin )
   ENDIF

RETURN ( Self )
/*
   pageUp()
   Repositions the text source upward
*/
METHOD pageUp() CLASS HTTextEdit

   SETPOS( ::nRow - ::nNumRows + 1, ::nCol )

   ::refresh()

RETURN( Self )
/*
   pageDown()
   Repositions the text source downward
*/
METHOD pageDown() CLASS HTTextEdit

   SETPOS( ::nRow + ::nNumRows - 1, ::nCol )

	::refresh()

RETURN( Self )
/*
   home()
   Moves the cursor to the leftmost visible text column
*/
METHOD home() CLASS HTTextEdit

   ::nCol := 1

   SETPOS( ::nRow, ::nCol )

   ::refresh()

RETURN( Self )
/*
   end()
   Moves the cursor to the rightmost visible text column
*/
METHOD end() CLASS HTTextEdit

   ::nCol := -1

   SETPOS( ::nRow, ::nCol )

   ::refresh()

RETURN( Self )
/*
   goTop
   Repositions the text source to the top of file
*/
METHOD goTop() CLASS HTTextEdit

   ::nRow := 1
   ::nCol := 1

   SETPOS( ::nRow, ::nCol )

   ::refresh()

RETURN( Self )
/*
   goBottom()
   Repositions the text source to the bottom of file
*/
METHOD goBottom() CLASS HTTextEdit

RETURN( Self )
/*
   wordRight()
   Move by word to right
*/
METHOD wordRight() CLASS HTTextEdit

RETURN( Self )
/*
   wordLeft()
   Move by word to left
*/
METHOD wordLeft() CLASS HTTextEdit

RETURN( Self )
/*
   pageHome()
   Moves the cursor to the beginning of the file
*/
METHOD pageHome() CLASS HTTextEdit

RETURN( Self )
/*
   pageEnd()
   Moves the cursor at the end of the file
*/
METHOD pageEnd() CLASS HTTextEdit

RETURN( Self )

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

      CASE nKey == K_CTRL_PGUP
         ::goTop()

      CASE nKey == K_CTRL_PGDN
         ::goBottom()

      CASE nKey == K_CTRL_RIGHT
         ::wordRight()

      CASE nKey == K_CTRL_LEFT
         ::wordLeft()

      CASE nKey == K_CTRL_HOME
         ::pageHome()

      CASE nKey == K_CTRL_END
	      ::pageEnd()

       OTHERWISE

	       RETURN( .F. )

    ENDCASE

RETURN( .T. )
/*
   refresh()
   Causes all data to be refreshed during the next stabilize
*/
METHOD refresh() CLASS HTTextEdit

RETURN( Self )
