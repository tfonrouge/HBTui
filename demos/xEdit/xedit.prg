
#include "inkey.ch"
#include "hbgtinfo.ch"

FUNCTION Main( cFile )

   LOCAL oTextEdit
   LOCAL nKey
   LOCAL lMouse

//altd()

   lMouse := MSETCURSOR( .T. )
   SET( _SET_EVENTMASK, INKEY_ALL )

   SETMODE(25,80)

   oTextEdit := HTextEdit():New( cFile )

//   Hb_GtInfo( HB_GTI_WINTITLE , oTextEdit:cFile )

   IF oTextEdit:error()
      oTextEdit:errorMsg()
   ELSE

      DO WHILE ( .T. )

         nKey := INKEY( 0 )

         DO CASE
            CASE nKey == K_ESC
               RETURN ( .F. )

            CASE nKey == K_CTRL_LEFT
               alert("K_CTRL_LEFT")

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
//OUTSTD( "nRow            :", PADR( oTextEdit:nRow, 10 ), "nCol :", PADR( oTextEdit:nCol, 10 ), CHR(10)+CHR(13) )
//OUTSTD( "nStartArray :", PADR( oTextEdit:nStartArray, 10 ), CHR(10)+CHR(13) )
OUTSTD( "nRowArray   :", PADR( oTextEdit:nRowArray, 10 ), CHR(10)+CHR(13) )
OUTSTD( "nColArray   :", PADR( oTextEdit:nColArray, 10 ), CHR(10)+CHR(13) )
***
      ENDDO

   ENDIF

   MSETCURSOR( lMouse )

RETURN NIL
