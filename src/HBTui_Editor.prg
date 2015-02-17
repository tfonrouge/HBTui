/*
   12-01-2015
*/

#include "hbtui.ch"
#include "common.ch"
#include "fileio.ch"
#include "inkey.ch"

CLASS HBTui_Editor FROM HBTui_Widget

   VAR cFile                         AS CHARACTER INIT "Untitled.txt"
   VAR nTop                          AS NUMERIC   INIT 0
   VAR nLeft                         AS NUMERIC   INIT 0
   VAR nBottom                       AS NUMERIC   INIT MAXROW()
   VAR nRight                        AS NUMERIC   INIT MAXCOL()
   VAR cColor                        AS CHARACTER INIT "W/B"

   CONSTRUCTOR New()
   METHOD View( cFile, nTop, nLeft, nBottom, nRight, cColor )

ENDCLASS

/*
   New
*/
METHOD New() CLASS HBTui_Editor

RETURN Self

/*
   View
*/
METHOD View( cFile, nTop, nLeft, nBottom, nRight, cColor )
   LOCAL nHandle                             // nDeskryptor
   LOCAL nLength                             // nDługość
   LOCAL nVert, nHoriz
   LOCAL aArray, aTarget                     // aTablica,
   LOCAL i, lMore := .F.                     // lMore := .F. !
   LOCAL nLines, nColumns := 0, nPosition := 1
   LOCAL nKey
   LOCAL nStart, nEnd, nIncrement


   IF ISNUL( cFile )
      ::cFile := ::cFile
   ENDIF
   IF ISNIL( nTop )
      ::nTop := ::nTop
   ENDIF
   IF ISNIL( nLeft )
      ::nLeft := ::nLeft
   ENDIF
   IF ISNIL( nBottom )
      ::nBottom := ::nBottom
   ENDIF
   IF ISNIL( nRight )
      ::nRight := ::nRight
   ENDIF
   IF ISNUL( cColor )
      ::cColor := ::cColor
   ENDIF
   ::cColor := SetColor( ::cColor )

   IF ( ( nHandle := FOpen( ::cFile, 32 ) ) != -1 )

      Scroll( ::nTop, ::nLeft, ::nBottom, ::nRight )

      ::nBottom--

      nLength := FSeek( nHandle, FS_SET, FS_END )

      nVert  := ::nBottom - ::nTop + 1
      nHoriz := ::nRight - ::nLeft + 1

      aTarget := {}
      aArray  := { FSeek( nHandle, FS_SET, FS_SET ) }

      i := 0

      DO WHILE ( i < nVert .AND. ATail( aArray ) < nLength )

         AAdd( aTarget, NextLine( nHandle ) )
         AAdd( aArray, FSeek( nHandle, FS_SET, FS_RELATIVE ) )

         i++

      ENDDO

      nLines := nVert := i

      DO WHILE ( ! lMore )
         IF ( nColumns != 0 )



            nPosition := Max( nPosition + nColumns, 1 )

            DispBegin()

            FOR i := 1 TO nVert
               SetPos( ::nTop + i - 1, ::nLeft )
               DispOut( Pad( SubStr( aTarget[ i ], nPosition ), nHoriz ) )
            NEXT

            DispEnd()

            nColumns := 0

         ENDIF

         IF ( nLines != 0 )

            Scroll( ::nTop, ::nLeft, ::nBottom, ::nRight, nLines )

            IF ( nLines > 0 )
               nEnd := nVert
            ELSE
               nEnd := 1
            ENDIF

            nIncrement := nLines / Abs( nLines )
            nStart     := nEnd - nLines + nIncrement

            FOR i := nStart TO nEnd STEP nIncrement

               SetPos( ::nTop - 1 + i, ::nLeft )

               DispOut( SubStr( aTarget[i], nPosition, nHoriz ) )

            NEXT

            nLines := 0

         ENDIF

         nKey:= InKey( 0 )

         DO CASE
            CASE nKey == K_ESC
               lMore := .T.

            CASE nKey == K_DOWN
               nLines := 1

            CASE nKey == K_UP
               nLines := -1

            CASE nKey == K_PGDN
               nLines := nVert

            CASE nKey == K_PGUP
               nLines := -nVert

            CASE nKey == K_CTRL_PGDN
               IF ( ATail( aArray ) < nLength )
                  aArray[1] := nLength
                  nLines := -nVert
               ENDIF

            CASE nKey == K_CTRL_PGUP
               IF ( aArray[1] > 0 )
                  aArray[nVert + 1] := 0
                  nLines := nVert
               ENDIF

            CASE nKey == K_RIGHT
               nColumns := 1

            CASE nKey == K_LEFT
               nColumns := -1

            CASE nKey == K_CTRL_RIGHT
               nColumns := 10

            CASE nKey == K_CTRL_LEFT
               nColumns := -10

            CASE nKey == K_END
               nColumns := Max( AMax( aTarget ) - nHoriz + 1, 1 ) - ( nPosition + nColumns )

            CASE nKey == K_HOME
               nColumns := 1 - nPosition

         ENDCASE

         IF ( nLines > 0 )
            FSeek( nHandle, ATail( aArray ), FS_SET )

            i := 0

            DO WHILE ( i < nLines .AND. ATail( aArray ) < nLength )

               Adel( aTarget, 1 )[nVert] := NextLine( nHandle )
               Adel( aArray, 1 )[nVert + 1] := FSeek( nHandle, 0, 1 )

               i++

            ENDDO

            nLines:= i

         ELSEIF ( nLines < 0 )
            FSeek( nHandle, aArray[1], 0 )

            i := 0

            DO WHILE ( i > nLines .AND. aArray[1] > 0 )

               AIns( aTarget, 1 ) [1] := PrevLine( nHandle )
               AIns( aArray, 1 ) [1] := FSeek( nHandle, 0, 1 )

               i--

            ENDDO

            nLines := i

         ENDIF

      ENDDO

      FClose( nHandle )

   ENDIF

   SET COLOR TO ( ::cColor )

RETURN Self

/*
   NextLine
*/
FUNCTION NextLine( nHandle )

   LOCAL cBufferVar                   // cZmienna
   LOCAL nLarger                      // nWieksza
   LOCAL cSubstring := ""             // cPodciag
   LOCAL nOffset := 0                 // nPrzesuniecie
   LOCAL nBytes
   LOCAL nPos_1, nPos_2

   LOCAL nBuffer := .F., nTeo_help := .F.

   DO WHILE ( ! ( nBuffer .OR. nTeo_help ) )

      cBufferVar := Space( 160 )
      nBuffer := ( nBytes := FRead( nHandle, @cBufferVar, 160 ) ) < 160

      cSubstring := cSubstring + SubStr( cBufferVar, 1, nBytes )

      nOffset := nOffset + nBytes

      nPos_1 := At( Chr( 13 ) + Chr( 10 ), cSubstring )
      nPos_2 := At( "", cSubstring )

      IF ( nPos_1 == 0 .OR. nPos_2 == 0 )
         nLarger := Max( nPos_1, nPos_2 )
      ELSE
         nLarger := Min( nPos_1, nPos_2 )
      ENDIF

      IF ( nTeo_help := nLarger > 0 )
         FSeek( nHandle, nLarger - nOffset + IIF( nLarger == nPos_1, 1, 0 ), 1 )
         cSubstring := SubStr( cSubstring, 1, nLarger - 1 )
      ENDIF

   ENDDO

RETURN cSubstring

/*
   PrevLine
*/
FUNCTION PrevLine( nHandle )

   LOCAL cBufferVar := " "
   LOCAL nLarger
   LOCAL cSubstring := ""
//   LOCAL nCount1 := 0       // Help
   LOCAL nOffset
   LOCAL nBytes := .F., nTeo_help := .F.
   LOCAL nPos_1, nPos_2

   IF ( FSeek( nHandle, FS_SET, FS_RELATIVE ) > 0 )
      FSeek( nHandle, -1, FS_RELATIVE )                     // F_ERROR -1

      FRead( nHandle, @cBufferVar, 1 )

      IF ( cBufferVar == "" )
         FSeek( nHandle, -1, FS_RELATIVE )
      ELSEIF ( cBufferVar == Chr( 10 ) )
         FSeek( nHandle, -2, FS_RELATIVE )
      ENDIF

   ENDIF

   DO WHILE ( ! ( nBytes .OR. nTeo_help ) )

      nBytes := ( nOffset := Min( 160, FSeek( nHandle, FS_SET, FS_RELATIVE ) ) )  < 160

      cBufferVar:= Space( nOffset )

      FSeek( nHandle, -nOffset, FS_RELATIVE )
      FRead( nHandle, @cBufferVar, nOffset )
      FSeek( nHandle, -nOffset, FS_RELATIVE )

      cSubstring := cBufferVar + cSubstring

      //nCount1 := nCount1 + nOffset

      nPos_1 := Rat( Chr( 13 ) + Chr( 10 ), cSubstring )
      nPos_2 := Rat( "", cSubstring )

      nLarger := Max( nPos_1, nPos_2 )

      IF ( nTeo_help := nLarger > 0 )

         FSeek( nHandle, nLarger + IIF( nLarger == nPos_1, 1, 0), FS_RELATIVE )
         cSubstring:= SubStr( cSubstring, nLarger + 1 + IIF( nLarger == nPos_1, 1, 0 ) )

      ENDIF

   ENDDO

RETURN cSubstring

/*
   AMax
*/
FUNCTION AMax( aTarget )

   LOCAL nLarger := 0

   AEval( aTarget, {| w | nLarger := Max( nLarger, Len( w ) ) } )           //P.

RETURN nLarger
//----------------------------------------------------------------------------//
