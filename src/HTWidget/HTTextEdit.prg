/*
 *
 */

#include "hbtui.ch"
#include "inkey.ch"

CLASS xtEdit FROM HTWidget

   METHOD nTop    INLINE 0
   METHOD nLeft   INLINE 0
   METHOD nBottom INLINE MAXROW()
   METHOD nRight  INLINE MAXCOL()

   DATA nRow        INIT 0
   DATA nCol        INIT 0
   DATA nStartArray INIT 0
   METHOD nRowArray INLINE ::nRow + ::nStartArray
   METHOD nColArray INLINE ::nCol + 1

   METHOD nEndRow INLINE ::nBottom - ::nTop + 1
   METHOD nEndCol INLINE ::nRight - ::nLeft + 1

   DATA nHandle
   DATA nError  INIT 0

   DATA aTextBuffer  INIT {}

   METHOD New( cFile ) CONSTRUCTOR

   METHOD loadFile( cFile )
   METHOD newFile()
   METHOD createFile( cFile )
   METHOD saveFile()
   METHOD closeFile()

   METHOD mouse()
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

   METHOD refresh()

   METHOD error()
   METHOD errorMsg()

   METHOD readLine()

ENDCLASS
//----------------------------------------------------------------------------//

/*
   New( cFile )
*/
METHOD New( cFile ) CLASS xEdit

   IF FILE( cFile )
      ::loadFile( cFile )
   ELSE
      cFile := IIF( ::cFile == NIL, "Untitled1.prg", ::cFile )
      ::newFile( )
   ENDIF

RETURN ( Self )

/*
   loadFile()
*/
METHOD loadFile( cFile ) CLASS xEdit

   IF ( ::nHandle := FOPEN( cFile, 2 ) ) == -1
      ::nError := FERROR()
      RETURN ( .F. )
   ENDIF

   DO WHILE .NOT. hb_FEof( ::nHandle )

      AADD( ::aTextBuffer, ::readLine() )

   ENDDO

   //::closeFile()

   ::nRow := 0
   ::nCol := 0

   ::refresh()

RETURN ( Self )

/*
   newFile()
*/
METHOD newFile() CLASS xEdit

   AADD( ::aTextBuffer, "" )

   ::refresh()

RETURN ( Self )

/*
   createFile()
*/
METHOD createFile( cFile ) CLASS xEdit

   IF ( ::nHandle := FCREATE( cFile, 0 ) ) = -1
      ::nError := FERROR()
      RETURN ( .F. )
   ENDIF

   //::closeFile()

RETURN ( Self )

/*
   saveFile()
*/
METHOD saveFile() CLASS xEdit

   LOCAL i
   LOCAL cTextBuffer

   ::createFile()

   FOR i := 1 TO LEN( ::aTextBuffer )
      cTextBuffer := ::aTextBuffer[ i ] + "test" + e"\n"
      FWRITE( ::nHandle, cTextBuffer, LEN( cTextBuffer ) )
   NEXT


RETURN ( Self )

/*
   closeFile()
*/
METHOD closeFile() CLASS xEdit

   IF ! FCLOSE( ::nHandle )
      ::nError := FERROR()
   ENDIF

RETURN ( Self )

/*
   mouse()
*/
METHOD mouse() CLASS xEdit

   ::nRow := MROW()
   ::nCol := MCOL()

   SETPOS( ::nRow, ::nCol )

RETURN ( Self )

/*
   up()
*/
METHOD up() CLASS xEdit

   IF ::nRow > 0
      ::nRow--
   ELSEIF ::nStartArray > 0
      ::nStartArray--
   ENDIF

   ::refresh()

RETURN ( Self )

/*
   down()
*/
METHOD down() CLASS xEdit

   IF ( ::nRow + 1 ) < ::nEndRow
      ::nRow++
   ELSEIF ( ::nRowArray + 1 ) < LEN( ::aTextBuffer )
      ::nStartArray++
   ENDIF

   ::refresh()

RETURN ( Self )

/*
   left()
*/
METHOD left() CLASS xEdit

   IF ::nCol > 0
      ::nCol--
   ELSEIF ::nStartArray > 0
      ::nStartArray--
   ENDIF

   ::refresh()

RETURN ( Self )

/*
   right()
*/
METHOD right() CLASS xEdit

   IF ( ::nCol + 1 ) < ::nEndCol
      ::nCol++
   ENDIF

   ::refresh()

RETURN ( Self )

/*
   pageUp()
*/
METHOD pageUp() CLASS xEdit

RETURN ( Self )

/*
   pageDown()
*/
METHOD pageDown() CLASS xEdit

RETURN ( Self )

/*
   home()
*/
METHOD home() CLASS xEdit

   ::nCol := 0

   SETPOS( ::nRow, ::nCol )

RETURN ( Self )

/*
   end()
*/
METHOD end() CLASS xEdit

   ::nCol := ::nEndCol

   SETPOS( ::nRow, ::nCol )

RETURN ( Self )

/*
   pageHome()
*/
METHOD pageHome() CLASS xEdit

RETURN ( Self )

/*
   pageEnd()
*/
METHOD pageEnd() CLASS xEdit

RETURN ( Self )

/*
   wordRight()
*/
METHOD wordRight() CLASS xEdit

RETURN ( Self )

/*
   wordLeft()
*/
METHOD wordLeft() CLASS xEdit

RETURN ( Self )

/*
   refresh()
*/
METHOD refresh() CLASS xEdit

   LOCAL i
   LOCAL n

   DISPBEGIN()

   FOR i := 1 TO ::nEndRow

      SETPOS( ::nTop - 1 + i, ::nLeft )

      n := i + ::nStartArray

      IF n <= LEN( ::aTextBuffer )
         DISPOUT( PADR( ::aTextBuffer[ n ], ::nEndCol ) )
      ENDIF

   NEXT

   SETPOS( ::nRow, ::nCol )

   DISPEND()

RETURN ( Self )

/*
   error()
   Returns .T. if an error exists
*/
METHOD error() CLASS xEdit

RETURN ( ::nError != 0 )

/*
   errorMsg()
   Returns formatted error message.
*/
METHOD errorMsg() CLASS xEdit

   LOCAL cMessage
   LOCAL aMeaning := { "Successful",;
                       "File not found",;
                       "Path not found",;
                       "Too many files open",;
                       "Access denied",;
                       "Invalid handle",;
                       "Insufficient memory",;
                       "Invalid drive specified",;
                       "Attempted to write to a write-protected disk",;
                       "Drive not ready",;
                       "Data CRC error",;
                       "Write fault",;
                       "Read fault",;
                       "Sharing violation",;
                       "Lock Violation" }

   cMessage := aMeaning[ FERROR() ]

RETURN ( hb_Alert( cMessage, , , 3 ) )

/*
   readLine()
*/
METHOD readLine() CLASS xEdit

   LOCAL lBytes := .F., lEnd := .F.
   LOCAL cBufferVar
   LOCAL cLine := ""
   LOCAL nOffset := 0
   LOCAL nBytes
   LOCAL nCR, nLF, eol

   DO WHILE ( ! ( lBytes .OR. lEnd ) )

      cBufferVar := SPACE( 128 )
      nBytes := FREAD( ::nHandle, @cBufferVar, 128 )

      lBytes := nBytes < 128

      cLine := cLine + SUBSTR( cBufferVar, 1, nBytes )

      nOffset := nOffset + nBytes

      nCR := AT( CHR( 13 ), cLine )
      nLF := AT( CHR( 10 ), cline )

      DO CASE
      CASE nCR == 0
         // Jeœli nie mam CR, u¿yj pozycji LF.
         eol := nLF
      CASE nLF == 0
         // Jeœli nie ma LF, u¿yj pozycji CR.
         eol := nCR
      OTHERWISE
         // Jeœli istnieje zarówno CR i LF u¿yj pozycji pierwszej.
         eol := MIN( nCR, nLF )
      ENDCASE

      IF ( lEnd := eol > 0 )
         FSEEK( ::nHandle, eol - nOffset + 1, 1 )
         cLine := SUBSTR( cLine, 1, eol - 1 )
      ENDIF

   ENDDO

RETURN ( cLine )
