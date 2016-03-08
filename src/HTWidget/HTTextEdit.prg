/*
 *
 */

#include "hbtui.ch"

CLASS HTTextEdit FROM HTWidget

   DATA cFileName
   METHOD nTop    INLINE 0
   METHOD nLeft   INLINE 0
   METHOD nBottom INLINE MaxRow()
   METHOD nRight  INLINE MaxCol()

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
METHOD New( cFileName ) CLASS HTTextEdit

   ::cFileName := cFileName

   IF ::cFileName == NIL
      ::emptyFile()
   ELSE
      ::isFile()
   ENDIF

RETURN ( Self )

METHOD isFile() CLASS HTTextEdit

   LOCAL nChoice

   IF FILE( ::cFileName )
      ::loadFile()
   ELSE

      nChoice := Alert( "Cannot find the file " + '"' + ::cFileName + '";' + ";" + ;
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

METHOD loadFile() CLASS HTTextEdit

   IF ( ::nHandle := FOpen( ::cFileName, 2 ) ) == -1
      ::nError := FError()
      RETURN ( .F. )
   ENDIF

   DO WHILE .NOT. hb_FEof( ::nHandle )

      AAdd( ::aTextBuffer, ::readLine() )

   ENDDO

   ::closeFile()

   ::nRow := 0
   ::nCol := 0

   ::refresh()

RETURN ( Self )

METHOD emptyFile() CLASS HTTextEdit

   AAdd( ::aTextBuffer, "" )

   ::refresh()

RETURN ( Self )

METHOD createFile() CLASS HTTextEdit

   IF ( ::nHandle := FCreate( ::cFileName, 0 ) ) = -1
      ::nError := FError()
      RETURN ( .F. )
   ENDIF

   ::closeFile()

RETURN ( Self )

METHOD saveFile() CLASS HTTextEdit

   LOCAL i
   LOCAL cTextBuffer

   ::createFile()

   FOR i := 1 TO Len( ::aTextBuffer )
      cTextBuffer := ::aTextBuffer[ i ] + "test" + e"\n"
      FWrite( ::nHandle, cTextBuffer, Len( cTextBuffer ) )
   NEXT


RETURN ( Self )

METHOD closeFile() CLASS HTTextEdit

   IF ! FClose( ::nHandle )
      ::nError := FError()
   ENDIF

RETURN ( Self )

METHOD mouse() CLASS HTTextEdit

   ::nRow := MRow()
   ::nCol := MCol()

   SetPos( ::nRow, ::nCol )

RETURN ( Self )

METHOD up() CLASS HTTextEdit

   IF ::nRow > 0
      ::nRow--
   ELSEIF ::nStartArray > 0
      ::nStartArray--
   ENDIF

   ::refresh()

RETURN ( Self )

METHOD down() CLASS HTTextEdit

   IF ( ::nRow + 1 ) < ::nEndRow
      ::nRow++
   ELSEIF ( ::nRowArray + 1 ) < Len( ::aTextBuffer )
      ::nStartArray++
   ENDIF

   ::refresh()

RETURN ( Self )

METHOD left() CLASS HTTextEdit

   IF ::nCol > 0
      ::nCol--
   ELSEIF ::nStartArray > 0
      ::nStartArray--
   ENDIF

   ::refresh()

RETURN ( Self )

METHOD right() CLASS HTTextEdit

   IF ( ::nCol + 1 ) < ::nEndCol
      ::nCol++
   ENDIF

   ::refresh()

RETURN ( Self )

METHOD pageUp() CLASS HTTextEdit

RETURN ( Self )

METHOD pageDown() CLASS HTTextEdit

RETURN ( Self )

METHOD home() CLASS HTTextEdit

   ::nCol := 0

   SetPos( ::nRow, ::nCol )

RETURN ( Self )

METHOD end() CLASS HTTextEdit

   ::nCol := ::nEndCol

   SetPos( ::nRow, ::nCol )

RETURN ( Self )

METHOD pageHome() CLASS HTTextEdit

RETURN ( Self )

METHOD pageEnd() CLASS HTTextEdit

RETURN ( Self )

METHOD wordRight() CLASS HTTextEdit

RETURN ( Self )

METHOD wordLeft() CLASS HTTextEdit

RETURN ( Self )

METHOD refresh() CLASS HTTextEdit

   LOCAL i
   LOCAL n

   DispBegin()

   FOR i := 1 TO ::nEndRow

      SetPos( ::nTop - 1 + i, ::nLeft )

      n := i + ::nStartArray

      IF n <= Len( ::aTextBuffer )
         DispOut( PadR( ::aTextBuffer[ n ], ::nEndCol ) )
      ENDIF

   NEXT

   SetPos( ::nRow, ::nCol )

   DispEnd()

RETURN ( Self )

METHOD errorMsg() CLASS HTTextEdit

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

   cMessage := aMeaning[ FError() ]

RETURN ( Alert( cMessage ) )

METHOD readLine() CLASS HTTextEdit

   LOCAL lBytes := .F., lEnd := .F.
   LOCAL cBufferVar
   LOCAL cLine := ""
   LOCAL nOffset := 0
   LOCAL nBytes
   LOCAL nCR, nLF, eol

   DO WHILE ( ! ( lBytes .OR. lEnd ) )

      cBufferVar := Space( 128 )
      nBytes := FRead( ::nHandle, @cBufferVar, 128 )

      lBytes := nBytes < 128

      cLine := cLine + SubStr( cBufferVar, 1, nBytes )

      nOffset := nOffset + nBytes

      nCR := At( Chr( 13 ), cLine )
      nLF := At( Chr( 10 ), cline )

      DO CASE
         CASE nCR == 0
            eol := nLF
         CASE nLF == 0
            eol := nCR
         OTHERWISE
            eol := Min( nCR, nLF )
      ENDCASE

      IF ( lEnd := eol > 0 )
         FSeek( ::nHandle, eol - nOffset + 1, 1 )
         cLine := SubStr( cLine, 1, eol - 1 )
      ENDIF

   ENDDO

RETURN ( cLine )
