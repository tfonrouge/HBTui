
#include "inkey.ch"
#include "hbgtinfo.ch"

FUNCTION Main( cFile )

   LOCAL oTextEdit
   LOCAL nKey
   LOCAL lMouse

//altd()

   lMouse := MSetCursor( .T. )
   Set( _SET_EVENTMASK, INKEY_ALL )

   SetMode( 25, 80 )

   oTextEdit := HTTextEdit():New( cFile )

//   Hb_GtInfo( HB_GTI_WINTITLE , oTextEdit:cFile )

   IF oTextEdit:error()
      oTextEdit:errorMsg()
   ELSE

      DO WHILE ( .T. )

         nKey := InKey( 0 )

         DO CASE
            CASE nKey == K_ESC
               RETURN ( .F. )

            CASE nKey == K_CTRL_LEFT

            CASE nKey == K_LBUTTONDOWN
               oTextEdit:mouse()

            CASE nKey == K_MWFORWARD
               oTextEdit:up()

            CASE nKey == K_MWBACKWARD
               oTextEdit:down()

            CASE nKey == K_UP
               oTextEdit:up()

            CASE nKey == K_DOWN
               oTextEdit:down()

            CASE nKey == K_RIGHT
               oTextEdit:right()

            CASE nKey == K_LEFT
               oTextEdit:left()

            CASE nKey == K_PGUP
               oTextEdit:pageUp()

            CASE nKey == K_PGDN
               oTextEdit:pageDown()

            CASE nKey == K_HOME
               oTextEdit:home()

            CASE nKey == K_END
               oTextEdit:end()

            CASE nKey == K_CTRL_HOME
               oTextEdit:pageHome()

            CASE nKey == K_CTRL_END
               oTextEdit:pageEnd()

            CASE nKey == K_CTRL_RIGHT
               oTextEdit:wordRight()

            CASE nKey == K_CTRL_LEFT
               oTextEdit:wordLeft()

            OTHERWISE

               IF ( nKey >= 32 .AND. nKey <= 256 )
                  // here edition
               ENDIF

          ENDCASE
***
//OutStd( "nRow            :", PadR( oTextEdit:nRow, 10 ), "nCol :", PadR( oTextEdit:nCol, 10 ), Chr(10)+Chr(13) )
//OutStd( "nStartArray :", PadR( oTextEdit:nStartArray, 10 ), Chr(10)+Chr(13) )
OutStd( "nRowArray   :", PadR( oTextEdit:nRowArray, 10 ), Chr(10)+Chr(13) )
OutStd( "nColArray   :", PadR( oTextEdit:nColArray, 10 ), Chr(10)+Chr(13) )
***
      ENDDO

   ENDIF

   MSetCursor( lMouse )

RETURN NIL
