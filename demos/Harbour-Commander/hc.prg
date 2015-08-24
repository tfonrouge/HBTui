#include "hbgtinfo.ch"
#include "box.ch"
#include "inkey.ch"

FUNCTION Main()

   LOCAL nTop    :=  1
   LOCAL nLeft   := 51
   LOCAL nBottom := 26
   LOCAL nRight  := 98
   LOCAL aDirectory
   LOCAL oTBrowse
   LOCAL nLen    := 1
   LOCAL nSubs   := 1
   LOCAL y       := 0
   LOCAL oTBColumn
   LOCAL TheEnd := .T.
   LOCAL cDrive := DISKNAME()
   LOCAL cDirectory := CURDIR()
   LOCAL nKey
   LOCAL nCount, nMrow, nMcol
   LOCAL xReturn
   LOCAL lMode := .T.

   SETMODE( 31, 100 )
   Hb_GtInfo( HB_GTI_WINTITLE, "Harbour Commander" )

   CLS

   SETCOLOR( "W+/B" )

   aDirectory := GetDirectory( @nLen )

   oTBrowse := TBrowseNew( nTop, nLeft, nBottom, nRight )

   DISPBOX( 0, 50, 28, 99, B_DOUBLE + CHR( 255 ), "W+/B" )

   StatusBar()

   oTBrowse:footSep := CHR( 196 )
   oTBrowse:colSep  := CHR( 179 )
   oTBrowse:skipBlock := { | x | y := IIF( ABS( x ) >= IIF( x >= 0, nLen - nSubs, nSubs - 1 ), ;
                         IIF( x >= 0, nLen - nSubs, 1 - nSubs ), x ), nSubs += y, y }

   oTBrowse:goTopBlock    := { || nSubs := 1 }
   oTBrowse:goBottomBlock := { || nSubs := nLen }
   oTBColumn := TBColumnNew( "Name", { || aDirectory[ nSubs, 1 ] } )
   oTBColumn:width := 20

   oTBrowse:addColumn( oTBColumn )
   oTBColumn := TBColumnNew( "Size", { || aDirectory[ nSubs, 2 ] } )
   oTBColumn:width :=  9

   oTBrowse:addColumn( oTBColumn )
   oTBColumn := TBColumnNew( "Date", { || aDirectory[ nSubs, 3 ] } )
   oTBColumn:width :=  8

   oTBrowse:addColumn( oTBColumn )
   oTBColumn := TBColumnNew( "Time", { || aDirectory[ nSubs, 4 ] } )
   oTBColumn:width :=  8

   oTBrowse:addColumn( oTBColumn )
   oTBrowse:freeze := 3

   DO WHILE TheEnd

      oTBrowse:colorRect( { oTBrowse:rowPos, 1, oTBrowse:rowPos, oTBrowse:colCount }, { 1, 1 } )

      WHILE !oTBrowse:stabilize()
      END

      IF oTBrowse:stable()
         oTBrowse:colorRect( { oTBrowse:rowPos, 1, oTBrowse:rowPos, oTBrowse:colCount }, { 2, 2 } )

         @ 0, 51 SAY cDrive + ":\" + cDirectory COLOR "N/BG"

         @ 29, 0 SAY cDrive + ":\" COLOR "W/N"

         @ 27, 51      Say EVAL( oTBrowse:getColumn( 1 ):block )
         @ 27, 51 + 13 Say EVAL( oTBrowse:getColumn( 2 ):block )
         @ 27, 51 + 23 Say EVAL( oTBrowse:getColumn( 3 ):block )
         @ 27, 51 + 32 Say EVAL( oTBrowse:getColumn( 4 ):block )

         nKey := INKEY( 0, 254 + HB_INKEY_GTEVENT )

         IF !Except( nKey, oTBrowse )

            DO CASE

               CASE ( nKey == K_MOUSEMOVE )

               CASE ( nKey == K_LBUTTONDOWN ) .OR. ( nKey == K_LDBLCLK )

                  IF     ( ( nMrow := mRow() ) < oTBrowse:nTop )
                  ELSEIF ( ( nMcol := mCol() ) < oTBrowse:nLeft )
                  ELSEIF ( nMrow > oTBrowse:nBottom )
                  ELSEIF ( nMcol <= oTBrowse:nRight )
                     nCount := oTBrowse:mRowPos - oTBrowse:RowPos
                     WHILE ( nCount < 0 )
                        nCount ++
                        oTBrowse:Up()
                     ENDDO
                     WHILE ( nCount > 0 )
                        nCount --
                        oTBrowse:Down()
                     ENDDO
                     nCount := oTBrowse:mColPos - oTBrowse:ColPos
                     WHILE ( nCount < 0 )
                        nCount ++
                        oTBrowse:Left()
                     ENDDO
                     WHILE ( nCount > 0 )
                        nCount --
                        oTBrowse:Right()
                     ENDDO
                  ENDIF

                  IF ( nKey == K_LDBLCLK )

                     xReturn := EVAL( ( oTBrowse:getColumn( 2 ) ):block )

                     IF ( xReturn == CHR( 16 ) + "UP--DIR" + CHR( 17 ) )

                        DIRCHANGE( ".." )
                        lMode := .T.

                     ELSEIF ( xReturn == CHR( 16 ) + "SUB-DIR" + CHR( 17 ) )

                        xReturn := LastBlockValue( oTBrowse )
                        DIRCHANGE( xReturn )
                        lMode := .T.

                     ENDIF

                  ENDIF

               CASE ( nKey == K_RBUTTONDOWN ) .OR. ( nKey == K_INS )
                  ALERT("test")

               CASE ( nKey == K_RETURN )

                  xReturn := EVAL( ( oTBrowse:getColumn( 2 ) ):block )

                  IF ( xReturn == CHR( 16 ) + "UP--DIR" + CHR( 17 ) )

                     DIRCHANGE( ".." )
                     lMode := .T.

                  ELSEIF ( xReturn == CHR( 16 ) + "SUB-DIR" + CHR( 17 ) )

                     xReturn := LastBlockValue( oTBrowse )
                     DIRCHANGE( xReturn )
                     lMode := .T.

                  ENDIF

               CASE ( nKey == K_TAB )
                  // Select windows

               CASE ( nKey == K_ESC )

               CASE ( nKey == K_F1 )

               CASE ( nKey == K_F2 )

               CASE ( nKey == K_F3 )

               CASE ( nKey == K_F4 )

               CASE ( nKey == K_F5 .AND. !( CHR( 17 ) $ EVAL( ( oTBrowse:getColumn( 2 ) ):block ) ) )

               CASE ( nKey == K_F6 .AND. !( CHR( 17 ) $ EVAL( ( oTBrowse:getColumn( 2 ) ):block ) ) )

               CASE ( nKey == K_F8 .AND. !( CHR( 17 ) $ EVAL( ( oTBrowse:getColumn( 2 ) ):block ) ) )

               CASE ( nKey == K_F9 )

               CASE ( nKey == K_F10 )

                  IF ALERT( "Do you want to quit the Harbour Commander?", { "Yes", "No" }, "N/W" ) == 1
                     TheEnd := .F.
                  ENDIF

               CASE ( nKey == K_ALT_F1 )
                  cDrive := AllDrives( nKey )

               CASE ( nKey == K_ALT_F2 )
                  cDrive := AllDrives( nKey )

               CASE ( nKey == K_ALT_F3 )

               CASE ( nKey == K_ALT_F4 )

               CASE ( nKey == K_ALT_F5 )

               CASE ( nKey == K_ALT_F6 )

               CASE ( nKey == K_ALT_F7 )

               CASE ( nKey == K_ALT_F8 )

               CASE ( nKey == K_ALT_F9 )

               CASE ( nKey == K_ALT_F10 )

               CASE ( nkey == K_CTRL_F1 )

               CASE ( nkey == K_CTRL_F2 )

               CASE ( nkey == K_CTRL_F3 )

               CASE ( nkey == K_CTRL_F4 )

               CASE ( nkey == K_CTRL_F5 )

               CASE ( nkey == K_CTRL_F6 )

               CASE ( nkey == K_CTRL_F7 )

               CASE ( nkey == K_CTRL_F8 )

               CASE ( nkey == K_CTRL_F9 )

               CASE ( nkey == K_CTRL_F10 )

            ENDCASE

         ENDIF

         IF lMode
            lMode := .F.
            aDirectory := GetDirectory( @nLen )
            oTBrowse:goTop()
            oTBrowse:configure()
            oTBrowse:refreshAll()
         ENDIF
      ENDIF

   ENDDO

RETURN ( NIL )
/*

*/
FUNCTION GetDirectory( nLen )

   LOCAL nStart := 1
   LOCAL aDirectory := DIRECTORY( "*.*", "HSD" )

   nLen := LEN( aDirectory )

   ASORT( aDirectory, , , { | x | x[5] == "D" } )

   AEVAL( aDirectory, { | x, i | nStart := IIF( "D" $ x[5], i, nStart ) } )

   ASORT( aDirectory, 1, nStart, { | x, y | x[1] < y[1] } )

   nStart++

   ASORT( aDirectory, nStart, , { | x, y | x[1] < y[1] } )

   SetDirectory( aDirectory, @nLen )

RETURN ( aDirectory )
/*

*/
FUNCTION Except( nKey, oTBrowse )

   LOCAL nElement
   LOCAL aKeys := { K_DOWN      , { |b| b:down()     }, ;
                    K_UP        , { |b| b:up()       }, ;
                    K_MWBACKWARD, { |b| b:down()     }, ;
                    K_MWFORWARD , { |b| b:up()       }, ;
                    K_PGDN      , { |b| b:pageDown() }, ;
                    K_PGUP      , { |b| b:pageUp()   }, ;
                    K_CTRL_PGUP , { |b| b:goTop()    }, ;
                    K_CTRL_PGDN , { |b| b:goBottom() }, ;
                    K_HOME      , { |b| b:home()     }, ;
                    K_END       , { |b| b:end()      }, ;
                    K_CTRL_HOME , { |b| b:panHome()  }, ;
                    K_CTRL_END  , { |b| b:panEnd()   } }

    nElement := ASCAN( aKeys, nKey )

    IF ( nElement != 0 )

      EVAL( aKeys[ ++nElement ], oTBrowse )

    ENDIF

RETURN ( nElement != 0 )
/*

*/
FUNCTION LastBlockValue( oTBrowse )

   LOCAL xReturn := EVAL( ( oTBrowse:getColumn( 1 ) ):block )
   LOCAL cSubstring := ALLTRIM( SUBSTR( xReturn, 10, 3 ) )

   xReturn := ALLTRIM( SUBSTR( xReturn, 1, 8 ) ) + IIF( EMPTY( cSubstring ), "", "." + cSubstring )

RETURN ( xReturn )
/*

*/
FUNCTION SetDirectory( aDirectory, nLen )

   LOCAL nPos, cTemp
   LOCAL i := 1

   DO WHILE ( i <= LEN( aDirectory ) )

      IF ( "D" $ aDirectory[ i, 5 ] )

         IF ( aDirectory[ i, 1 ] == "." )

            ADEL( aDirectory, i )

            aDirectory := ASIZE( aDirectory, LEN( aDirectory ) - 1 )
            LOOP

         ELSEIF ( aDirectory[ i, 1 ] == ".." )

            aDirectory[ i, 1 ] := PADR( aDirectory[ i, 1 ], 12 )
            aDirectory[ i, 2 ] := CHR( 16 ) + "UP--DIR" + CHR( 17 )

         ELSE

            aDirectory[ i, 2 ] := CHR( 16 ) + "SUB-DIR" + CHR( 17 )
            nPos := AT( ".", aDirectory[ i, 1 ] )

            IF nPos != 0

               aDirectory[ i, 1 ] := PADR( SUBSTR( aDirectory[ i, 1 ], 1, nPos - 1 ), 9 ) +;
                                     PADR( SUBSTR( aDirectory[ i, 1 ], nPos + 1, 3 ), 3 )
            ELSE

               aDirectory[ i, 1 ] := PADR( aDirectory[ i, 1 ], 12 )

            ENDIF

         ENDIF

      ELSE

         nPos := AT( ".", aDirectory[ i, 1 ] )

         IF nPos != 0

            aDirectory[ i, 1 ] := PADR( SUBSTR( aDirectory[ i, 1 ], 1, nPos - 1 ), 9 ) +;
                                  PADR( SUBSTR( aDirectory[ i, 1 ], nPos + 1, 3 ), 3 )
         ELSE

            aDirectory[ i, 1 ] := PADR( aDirectory[ i, 1 ], 12 )

         ENDIF

         aDirectory[ i, 1 ] := LOWER( aDirectory[ i, 1] )
         aDirectory[ i, 2 ] := STR( aDirectory[ i, 2 ], 9 )

      ENDIF

      aDirectory[ i, 4 ] := SUBSTR( aDirectory[ i, 4 ], 1, 5 )
      cTemp := VAL( SUBSTR( aDirectory[ i, 4 ], 1, 2 ) )

      aDirectory[ i, 4 ] += IIF( cTemp >= 12 .AND. cTemp <= 23, "p", "a" )
      cTemp := IIF( cTemp > 12, cTemp % 12, cTemp )
      cTemp := STR( cTemp, 2, 0 )

      aDirectory[ i, 4 ] := cTemp + SUBSTR( aDirectory[ i, 4 ], 3, 4 )

      i++

    ENDDO

    nLen := LEN( aDirectory )

RETURN ( NIL )
/*

*/
FUNCTION AllDrives( nKey )

   LOCAL i
   LOCAL cDrives := ""
   LOCAL aArray := {}
   LOCAL nDrives

   FOR i := 1 TO 26
      IF DISKCHANGE( CHR( i + 64 ) )
         cDrives := CHR( i + 64 )
         AADD( aArray, cDrives )
      ENDIF
   NEXT

   IF ( nKey == K_ALT_F1 )

      nDrives := ALERT( "Drive letter;" + ;
                        "Choose left drive:", aArray, "N/W" )

      cDrives := aArray[ nDrives ]

   ENDIF

   IF ( nKey == K_ALT_F2 )

      nDrives := ALERT( "Drive letter;" + ;
                        "Choose right drive:", aArray, "N/W" )

      cDrives := aArray[ nDrives ]

   ENDIF

RETURN cDrives
/*

*/
FUNCTION StatusBar()

   HB_DISPOUTAT( MAXROW(), 0,  "F1",       "G+/N" )
   HB_DISPOUTAT( MAXROW(), 2,  "Help    ", "N/BG" )
   HB_DISPOUTAT( MAXROW(), 10, "F2",       "G+/N" )
   HB_DISPOUTAT( MAXROW(), 12, "Menu    ", "N/BG" )
   HB_DISPOUTAT( MAXROW(), 20, "F3",       "G+/N" )
   HB_DISPOUTAT( MAXROW(), 22, "View    ", "N/BG" )
   HB_DISPOUTAT( MAXROW(), 30, "F4",       "G+/N" )
   HB_DISPOUTAT( MAXROW(), 32, "Edit    ", "N/BG" )
   HB_DISPOUTAT( MAXROW(), 40, "F5",       "G+/N" )
   HB_DISPOUTAT( MAXROW(), 42, "Copy    ", "N/BG" )
   HB_DISPOUTAT( MAXROW(), 50, "F6",       "G+/N" )
   HB_DISPOUTAT( MAXROW(), 52, "RenMov  ", "N/BG" )
   HB_DISPOUTAT( MAXROW(), 60, "F7",       "G+/N" )
   HB_DISPOUTAT( MAXROW(), 62, "Mkdir   ", "N/BG" )
   HB_DISPOUTAT( MAXROW(), 70, "F8",       "G+/N" )
   HB_DISPOUTAT( MAXROW(), 72, "Delete  ", "N/BG" )
   HB_DISPOUTAT( MAXROW(), 80, "F9",       "G+/N" )
   HB_DISPOUTAT( MAXROW(), 82, "PullDn  ", "N/BG" )
   HB_DISPOUTAT( MAXROW(), 90, "10",       "G+/N" )
   HB_DISPOUTAT( MAXROW(), 92, "Quit    ", "N/BG" )

RETURN ( NIL )

