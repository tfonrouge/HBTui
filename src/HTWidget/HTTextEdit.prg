/*
 *
 */

#include "hbtui.ch"

CLASS HTextEdit FROM HWidget

   DATA cFileName
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

   METHOD New( cFileName ) CONSTRUCTOR

   METHOD isFile()
   METHOD loadFile()
   METHOD emptyFile()
   METHOD createFile()
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

   METHOD error()   INLINE ::nError != 0
   METHOD errorMsg()

   METHOD readLine()

ENDCLASS
// -------------------------------------------------------------------------- //
METHOD New( cFileName ) CLASS HTextEdit

   ::cFileName := cFileName

   IF ::cFileName == NIL
      ::emptyFile()
   ELSE
      ::isFile()
   ENDIF

RETURN ( Self )

METHOD isFile() CLASS HTextEdit

   LOCAL nChoice

   IF FILE( ::cFileName )
      ::loadFile()
   ELSE

      nChoice := ALERT( "Cannot find the file " + '"' + ::cFileName + '";' + ";" + ;
                        "Do you want to create a new file?", { "Yes", "No", "Cancel" } )

      DO CASE
         CASE nChoice == 1
            ::createFile()
            ::loadFile()

         CASE nChoice == 2
            ::emptyFile()

         CASE nChoice == 3
            QUIT

         OTHERWISE
            QUIT

      ENDCASE

   ENDIF

RETURN ( Self )

METHOD loadFile() CLASS HTextEdit

   IF ( ::nHandle := FOPEN( ::cFileName, 2 ) ) == -1
      ::nError := FERROR()
      RETURN ( .F. )
   ENDIF

   DO WHILE .NOT. hb_FEof( ::nHandle )

      AADD( ::aTextBuffer, ::readLine() )

   ENDDO

   ::closeFile()

   ::nRow := 0
   ::nCol := 0

   ::refresh()

RETURN ( Self )

METHOD emptyFile() CLASS HTextEdit

   AADD( ::aTextBuffer, "" )

   ::refresh()

RETURN ( Self )

METHOD createFile() CLASS HTextEdit

   IF ( ::nHandle := FCREATE( ::cFileName, 0 ) ) = -1
      ::nError := FERROR()
      RETURN ( .F. )
   ENDIF

   ::closeFile()

RETURN ( Self )

METHOD saveFile() CLASS HTextEdit

   LOCAL i
   LOCAL cTextBuffer

   ::createFile()

   FOR i := 1 TO LEN( ::aTextBuffer )
      cTextBuffer := ::aTextBuffer[ i ] + "test" + e"\n"
      FWRITE( ::nHandle, cTextBuffer, LEN( cTextBuffer ) )
   NEXT


RETURN ( Self )

METHOD closeFile() CLASS HTextEdit

   IF ! FCLOSE( ::nHandle )
      ::nError := FERROR()
   ENDIF

RETURN ( Self )

METHOD mouse() CLASS HTextEdit

   ::nRow := MROW()
   ::nCol := MCOL()

   SETPOS( ::nRow, ::nCol )

RETURN ( Self )

METHOD up() CLASS HTextEdit

   IF ::nRow > 0
      ::nRow--
   ELSEIF ::nStartArray > 0
      ::nStartArray--
   ENDIF

   ::refresh()

RETURN ( Self )

METHOD down() CLASS HTextEdit

   IF ( ::nRow + 1 ) < ::nEndRow
      ::nRow++
   ELSEIF ( ::nRowArray + 1 ) < LEN( ::aTextBuffer )
      ::nStartArray++
   ENDIF

   ::refresh()

RETURN ( Self )

METHOD left() CLASS HTextEdit

   IF ::nCol > 0
      ::nCol--
   ELSEIF ::nStartArray > 0
      ::nStartArray--
   ENDIF

   ::refresh()

RETURN ( Self )

METHOD right() CLASS HTextEdit

   IF ( ::nCol + 1 ) < ::nEndCol
      ::nCol++
   ENDIF

   ::refresh()

RETURN ( Self )

METHOD pageUp() CLASS HTextEdit

RETURN ( Self )

METHOD pageDown() CLASS HTextEdit

RETURN ( Self )

METHOD home() CLASS HTextEdit

   ::nCol := 0

   SETPOS( ::nRow, ::nCol )

RETURN ( Self )

METHOD end() CLASS HTextEdit

   ::nCol := ::nEndCol

   SETPOS( ::nRow, ::nCol )

RETURN ( Self )

METHOD pageHome() CLASS HTextEdit

RETURN ( Self )

METHOD pageEnd() CLASS HTextEdit

RETURN ( Self )

METHOD wordRight() CLASS HTextEdit

RETURN ( Self )

METHOD wordLeft() CLASS HTextEdit

RETURN ( Self )

METHOD refresh() CLASS HTextEdit

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

METHOD errorMsg() CLASS HTextEdit

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

RETURN ( ALERT( cMessage ) )

METHOD readLine() CLASS HTextEdit

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
            eol := nLF
         CASE nLF == 0
            eol := nCR
         OTHERWISE
            eol := MIN( nCR, nLF )
      ENDCASE

      IF ( lEnd := eol > 0 )
         FSEEK( ::nHandle, eol - nOffset + 1, 1 )
         cLine := SUBSTR( cLine, 1, eol - 1 )
      ENDIF

   ENDDO

RETURN ( cLine )
