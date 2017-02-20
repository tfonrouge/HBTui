/*
 * Copyright (c) 2017 Rafał Jopek
 * https://www.harbour.edu.pl
 *
 */

/*
 * MsgBox() function (based on earlier version of Harbour's hb_Alert())
 *
 * Released to Public Domain by Vladimir Kazimirchik <v_kazimirchik@yahoo.com>
 * Copyright 1999-2017 Viktor Szakats (vszakats.net/harbour)
 *    nDelay support, dynamic remaining time display, Unicode, etc
 *
 */

#include "box.ch"
#include "color.ch"
#include "inkey.ch"
#include "setcurs.ch"
#include "hbgtinfo.ch"

FUNCTION MsgBox( xMessage, aOptions, cColorNorm, nDelay )

   LOCAL nChoice
   LOCAL aSay
   LOCAL nPos, nMaxWidth, nDefWidth, nWidth, nOpWidth, nInitRow, nInitCol, tmp
   LOCAL nKey, nKeyStd, aPos, nCurrent, aHotkey, aOptionsOK, nStart, nRemains, cMessage
   LOCAL cColorHigh

   LOCAL nOldRow
   LOCAL nOldCol
   LOCAL nOldCursor
   LOCAL cOldScreen

   Local cLine
   LOCAL nMRow, nMCol

   IF PCount() == 0
      RETURN NIL
   ENDIF

   nMaxWidth := MaxCol() - 3
   nDefWidth := Int( nMaxWidth / 4 * 3 )

   DO CASE
   CASE HB_ISARRAY( xMessage )
      cMessage := ""
      FOR EACH cLine IN xMessage
         cMessage += iif( cLine:__enumIsFirst(), "", Chr( 10 ) ) + hb_CStr( cLine )
      NEXT
   CASE HB_ISSTRING( xMessage )
      cMessage := StrTran( xMessage, ";", Chr( 10 ) )
   OTHERWISE
      cMessage := hb_CStr( xMessage )
   ENDCASE

   aSay := {}
   FOR EACH cLine IN hb_ATokens( cMessage, Chr( 10 ) )
      DO WHILE Len( cLine ) > nDefWidth
         nPos := RAt( " ", Left( cLine, nDefWidth + 1 ) )
         IF nPos == 0
            nPos := RAt( " ", Left( cLine, nMaxWidth + 1 ) )
         ENDIF
         IF nPos == 0
            AAdd( aSay, Left( cLine, nMaxWidth ) )
            cLine := SubStr( cLine, nMaxWidth + 1 )
         ELSE
            AAdd( aSay, Left( cLine, nPos - 1 ) )
            cLine := SubStr( cLine, nPos + 1 )
         ENDIF
      ENDDO
      AAdd( aSay, cLine )
   NEXT

   IF ! HB_ISSTRING( cColorNorm ) .OR. Empty( cColorNorm )
      cColorNorm := "W+/R"  // first pair color (Box line and Text)
      cColorHigh := "W+/B"  // second pair color (Options buttons)
   ELSE
      cColorNorm := hb_ColorIndex( cColorNorm, CLR_STANDARD )
      cColorHigh := hb_StrReplace( ;
         iif( ( nPos := hb_BAt( "/", cColorNorm ) ) > 0, ;
            hb_BSubStr( cColorNorm, nPos + 1 ) + "/" + hb_BLeft( cColorNorm, nPos - 1 ), ;
            "N/" + cColorNorm ), "+*" )
   ENDIF

   /* Longest line */
   nWidth := 0
   AEval( aSay, {| x | nWidth := Max( Len( x ), nWidth ) } )

   /* Cleanup the button array */
   aOptionsOK := {}
   FOR EACH tmp IN hb_defaultValue( aOptions, {} )
      IF HB_ISSTRING( tmp ) .AND. ! Empty( tmp )
         AAdd( aOptionsOK, tmp )
      ENDIF
   NEXT

   IF Len( aOptionsOK ) == 0
      aOptionsOK := { "Ok" }
   ENDIF

   /* Total width of the botton line (the one with choices) */
   nOpWidth := 0
   AEval( aOptionsOK, {| x | nOpWidth += Len( x ) + 4 } )

   /* What's wider? */
   nWidth := Max( nWidth + 2 + iif( Len( aSay ) == 1, 4, 0 ), nOpWidth + 2 )

   /* Box coordinates */
   nInitRow := Int( ( ( MaxRow() - ( Len( aSay ) + 4 ) ) / 2 ) + .5 )
   nInitCol := Int( ( ( MaxCol() - ( nWidth + 2 ) ) / 2 ) + .5 )

   /* Detect prompt positions */
   aPos := {}
   aHotkey := {}
   nCurrent := nInitCol + Int( ( nWidth - nOpWidth ) / 2 ) + 2
   IF nCurrent < 0
      nCurrent := 0
   ENDIF
   AEval( aOptionsOK, {| x | AAdd( aPos, nCurrent ), AAdd( aHotKey, Upper( Left( x, 1 ) ) ), nCurrent += Len( x ) + 4 } )

   /* Save status */
   nOldRow := Row()
   nOldCol := Col()
   nOldCursor := SetCursor( SC_NONE )
   cOldScreen := SaveScreen( nInitRow, nInitCol, nInitRow + Len( aSay ) + 3, nInitCol + nWidth + 1 )

   DispBegin()

   hb_DispBox( nInitRow, nInitCol, nInitRow + Len( aSay ) + 3, nInitCol + nWidth + 1, HB_B_SINGLE_UNI + " ", cColorNorm )

   /* Choice loop */

   hb_default( @nDelay, 0 )

   nChoice := 1
   nKey := 0
   nStart := hb_milliSeconds()

   DO WHILE nDelay == 0  .OR. ( nRemains := nDelay - Int( ( ( hb_milliSeconds() - nStart ) / 1000 ) ) ) >= 0

      hb_Scroll( nInitRow + 1, nInitCol + 1, nInitRow + Len( aSay ) + 2, nInitCol + nWidth,,, cColorNorm )
      FOR tmp := 1 TO Len( aSay )
         hb_DispOutAt( nInitRow + tmp, nInitCol + 1 + Int( ( ( nWidth - Len( aSay[ tmp ] ) ) / 2 ) + .5 ), ;
            hb_StrFormat( aSay[ tmp ], hb_ntos( nRemains ) ), cColorNorm )
      NEXT

      FOR tmp := 1 TO Len( aOptionsOK )
         hb_DispOutAt( nInitRow + Len( aSay ) + 2, aPos[ tmp ], " " + aOptionsOK[ tmp ] + " ",;
            iif( tmp == nChoice, cColorHigh, cColorNorm ) )
      NEXT
      DispEnd()

      nKey := Inkey( 1, hb_bitOr( Set( _SET_EVENTMASK, INKEY_ALL ), HB_INKEY_EXT ) )
      nKeyStd := hb_KeyStd( nKey )

      DO CASE
      CASE nKeyStd == K_ENTER .OR. ;
           nKeyStd == K_SPACE
         EXIT

      CASE nKeyStd == K_ESC

         nChoice := 0
         EXIT

      CASE nKeyStd == K_LBUTTONDOWN

         nMRow := MRow()
         nMCol := MCol()

         FOR tmp := 1 TO Len( aOptionsOK )
            IF nMRow == nInitRow + Len( aSay ) + 2 .AND. ;
               nMCol >= aPos[ tmp ] .AND. nMCol <= aPos[ tmp ] + ;
               Len( aOptionsOK[ tmp ] ) + 2 - 1
               nChoice := tmp
               EXIT
            ENDIF
         NEXT

         IF nChoice == tmp
            nChoice := 0
            EXIT
         ENDIF

      CASE ( nKeyStd == K_LEFT .OR. nKeyStd == K_SH_TAB ) .AND. Len( aOptionsOK ) > 1

         nChoice--
         IF nChoice == 0
            nChoice := Len( aOptionsOK )
         ENDIF

      CASE ( nKeyStd == K_RIGHT .OR. nKeyStd == K_TAB ) .AND. Len( aOptionsOK ) > 1

         nChoice++
         IF nChoice > Len( aOptionsOK )
            nChoice := 1
         ENDIF

      CASE ! hb_keyChar( nKey ) == ""

         IF ( tmp := hb_AScanI( aHotkey, hb_keyChar( nKey ),,, .T. ) ) > 0
            nChoice := tmp
            EXIT
         ENDIF

      ENDCASE

      DispBegin()
   ENDDO

   /* Restore status */
   RestScreen( nInitRow, nInitCol, nInitRow + Len( aSay ) + 3, nInitCol + nWidth + 1, cOldScreen )
   SetCursor( nOldCursor )
   SetPos( nOldRow, nOldCol )

   RETURN iif( nKey == 0, 0, nChoice )
