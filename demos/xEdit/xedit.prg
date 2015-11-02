
#include "inkey.ch"
#include "hbgtinfo.ch"

FUNCTION Main( cFile )

   LOCAL oxEdit
   LOCAL nKey
   LOCAL lMouse

//altd()

   lMouse := MSETCURSOR( .T. )
   SET( _SET_EVENTMASK, INKEY_ALL )

   SETMODE(25,80)

   oxEdit := xEdit():New( cFile )

   Hb_GtInfo( HB_GTI_WINTITLE , oxEdit:cFile )

   IF oxEdit:error()
      oxEdit:errorMsg()
   ELSE

      DO WHILE ( .T. )

         nKey := INKEY(0)

         DO CASE
            CASE nKey == K_ESC
               RETURN ( .F. )
            CASE nKey == K_CTRL_S
               alert("ok")

            CASE nKey == K_LBUTTONDOWN
               oxEdit:mouse()

            CASE nKey == K_MWFORWARD
               oxEdit:up()

            CASE nKey == K_MWBACKWARD
               oxEdit:down()

            CASE nKey == K_UP
               oxEdit:up()

            CASE nKey == K_DOWN
               oxEdit:down()

            CASE nKey == K_RIGHT
               oxEdit:right()

            CASE nKey == K_LEFT
               oxEdit:left()

            CASE nKey == K_PGUP
               oxEdit:pageUp()

            CASE nKey == K_PGDN
               oxEdit:pageDown()

            CASE nKey == K_HOME
               oxEdit:home()

            CASE nKey == K_END
               oxEdit:end()

            CASE nKey == K_CTRL_HOME
               oxEdit:pageHome()

            CASE nKey == K_CTRL_END
               oxEdit:pageEnd()

            CASE nKey == K_CTRL_RIGHT
               oxEdit:wordRight()

            CASE nKey == K_CTRL_LEFT
               oxEdit:wordLeft()

            OTHERWISE

               IF ( nKey >= 32 .AND. nKey <= 256 )
                  // here edition
               ENDIF

          ENDCASE
***
//OUTSTD( "nRow            :", PADR( oxEdit:nRow, 10 ), "nCol :", PADR( oxEdit:nCol, 10 ), CHR(10)+CHR(13) )
//OUTSTD( "nStartArray :", PADR( oxEdit:nStartArray, 10 ), CHR(10)+CHR(13) )
OUTSTD( "nRowArray   :", PADR( oxEdit:nRowArray, 10 ), CHR(10)+CHR(13) )
OUTSTD( "nColArray   :", PADR( oxEdit:nColArray, 10 ), CHR(10)+CHR(13) )
***
      ENDDO

   ENDIF

   MSETCURSOR( lMouse )

RETURN NIL
