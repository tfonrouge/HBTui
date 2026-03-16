/*
 * HTListBox - Scrollable selectable list widget
 */

#include "hbtui.ch"
#include "inkey.ch"

#define _LST_COLOR_NORMAL    "N/W"
#define _LST_COLOR_FOCUSED   "N/W"
#define _LST_COLOR_SELECTED  "W+/B"
#define _LST_COLOR_SELUNFOC  "N/BG"

CLASS HTListBox FROM HTWidget

PROTECTED:

    DATA Fitems          INIT {}
    DATA FitemData       INIT {}
    DATA FcurrentIndex   INIT 0
    DATA FtopIndex       INIT 1

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD paintEvent( paintEvent )
    METHOD keyEvent( keyEvent )
    METHOD mouseEvent( eventMouse )

    METHOD addItem( cText, xData )
    METHOD removeItem( nIndex )
    METHOD clear()
    METHOD count()          INLINE Len( ::Fitems )
    METHOD currentIndex()   INLINE ::FcurrentIndex
    METHOD currentText()    INLINE IIF( ::FcurrentIndex > 0 .AND. ::FcurrentIndex <= Len( ::Fitems ), ::Fitems[ ::FcurrentIndex ], "" )
    METHOD currentData()    INLINE IIF( ::FcurrentIndex > 0 .AND. ::FcurrentIndex <= Len( ::FitemData ), ::FitemData[ ::FcurrentIndex ], NIL )
    METHOD setCurrentIndex( n )
    METHOD itemText( n )    INLINE IIF( n > 0 .AND. n <= Len( ::Fitems ), ::Fitems[ n ], "" )

    PROPERTY onChanged                          /* {|nIndex| ... } */
    PROPERTY onActivated                        /* {|nIndex| ... } Enter/dblclick */

ENDCLASS

/*
    new
*/
METHOD new( ... ) CLASS HTListBox

    LOCAL p

    IF pCount() > 0
        p := hb_pValue( 1 )
        IF hb_isObject( p )
            ::super:new( p )
        ELSE
            ::super:new()
        ENDIF
    ELSE
        ::super:new()
    ENDIF

    ::setFocusPolicy( HT_FOCUS_STRONG )
    ::FisVisible := .T.
    ::Fheight := 5
    ::Fwidth := 20

RETURN self

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HTListBox

    LOCAL i, nRow, cText, cColor
    LOCAL nMaxRow := MaxRow()
    LOCAL nMaxCol := MaxCol()
    LOCAL nVisibleRows := nMaxRow + 1
    LOCAL lFocused := ::hasFocus()
    LOCAL cSelColor := IIF( lFocused, _LST_COLOR_SELECTED, _LST_COLOR_SELUNFOC )
    LOCAL cNrmColor := IIF( lFocused, _LST_COLOR_FOCUSED, _LST_COLOR_NORMAL )

    HB_SYMBOL_UNUSED( paintEvent )

    /* ensure topIndex keeps current item visible */
    IF ::FcurrentIndex > 0
        IF ::FcurrentIndex < ::FtopIndex
            ::FtopIndex := ::FcurrentIndex
        ENDIF
        IF ::FcurrentIndex >= ::FtopIndex + nVisibleRows
            ::FtopIndex := ::FcurrentIndex - nVisibleRows + 1
        ENDIF
    ENDIF

    nRow := 0
    FOR i := ::FtopIndex TO Min( ::FtopIndex + nVisibleRows - 1, Len( ::Fitems ) )
        cText := PadR( ::Fitems[ i ], nMaxCol + 1 )
        cColor := IIF( i = ::FcurrentIndex, cSelColor, cNrmColor )
        DispOutAt( nRow, 0, cText, cColor )
        nRow++
    NEXT

    /* clear remaining rows */
    DO WHILE nRow <= nMaxRow
        DispOutAt( nRow, 0, Space( nMaxCol + 1 ), cNrmColor )
        nRow++
    ENDDO

RETURN

/*
    keyEvent
*/
METHOD PROCEDURE keyEvent( keyEvent ) CLASS HTListBox

    LOCAL parent
    LOCAL nOldIndex := ::FcurrentIndex
    LOCAL cKey

    SWITCH keyEvent:key
    CASE K_UP
        IF ::FcurrentIndex > 1
            ::FcurrentIndex--
        ENDIF
        EXIT
    CASE K_DOWN
        IF ::FcurrentIndex < Len( ::Fitems )
            ::FcurrentIndex++
        ENDIF
        EXIT
    CASE K_PGUP
        ::FcurrentIndex := Max( 1, ::FcurrentIndex - ( MaxRow() + 1 ) )
        EXIT
    CASE K_PGDN
        ::FcurrentIndex := Min( Len( ::Fitems ), ::FcurrentIndex + ( MaxRow() + 1 ) )
        EXIT
    CASE K_HOME
        ::FcurrentIndex := 1
        EXIT
    CASE K_END
        ::FcurrentIndex := Len( ::Fitems )
        EXIT
    CASE K_ENTER
        IF ::FonActivated != NIL .AND. ::FcurrentIndex > 0
            Eval( ::FonActivated, ::FcurrentIndex )
        ENDIF
        keyEvent:accept()
        RETURN
    OTHERWISE
        /* first-letter search */
        cKey := Upper( hb_keyChar( keyEvent:key ) )
        IF Len( cKey ) = 1 .AND. cKey >= "A" .AND. cKey <= "Z"
            ::firstLetterSearch( cKey )
        ELSE
            RETURN
        ENDIF
    ENDSWITCH

    keyEvent:accept()

    IF ::FcurrentIndex != nOldIndex
        IF ::FonChanged != NIL
            Eval( ::FonChanged, ::FcurrentIndex )
        ENDIF
        parent := ::parent()
        IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
            parent:repaintChild( self )
        ENDIF
    ENDIF

RETURN

/*
    mouseEvent
*/
METHOD PROCEDURE mouseEvent( eventMouse ) CLASS HTListBox

    LOCAL nClickRow, nIndex
    LOCAL parent

    SWITCH eventMouse:nKey
    CASE K_LBUTTONDOWN
        nClickRow := eventMouse:mouseRow - 1 - ::Fy
        IF nClickRow >= 0
            nIndex := ::FtopIndex + nClickRow
            IF nIndex >= 1 .AND. nIndex <= Len( ::Fitems )
                ::FcurrentIndex := nIndex
                parent := ::parent()
                IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
                    parent:repaintChild( self )
                ENDIF
            ENDIF
        ENDIF
        EXIT
    CASE K_MWFORWARD
        IF ::FcurrentIndex > 1
            ::FcurrentIndex--
            parent := ::parent()
            IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
                parent:repaintChild( self )
            ENDIF
        ENDIF
        EXIT
    CASE K_MWBACKWARD
        IF ::FcurrentIndex < Len( ::Fitems )
            ::FcurrentIndex++
            parent := ::parent()
            IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
                parent:repaintChild( self )
            ENDIF
        ENDIF
        EXIT
    ENDSWITCH

RETURN

/*
    addItem
*/
METHOD PROCEDURE addItem( cText, xData ) CLASS HTListBox
    AAdd( ::Fitems, cText )
    AAdd( ::FitemData, xData )
    IF ::FcurrentIndex = 0
        ::FcurrentIndex := 1
    ENDIF
    ::Fwidth := Max( ::Fwidth, Len( cText ) )
RETURN

/*
    removeItem
*/
METHOD PROCEDURE removeItem( nIndex ) CLASS HTListBox
    IF nIndex >= 1 .AND. nIndex <= Len( ::Fitems )
        ADel( ::Fitems, nIndex )
        ASize( ::Fitems, Len( ::Fitems ) - 1 )
        ADel( ::FitemData, nIndex )
        ASize( ::FitemData, Len( ::FitemData ) - 1 )
        IF ::FcurrentIndex > Len( ::Fitems )
            ::FcurrentIndex := Len( ::Fitems )
        ENDIF
    ENDIF
RETURN

/*
    clear
*/
METHOD PROCEDURE clear() CLASS HTListBox
    ::Fitems := {}
    ::FitemData := {}
    ::FcurrentIndex := 0
    ::FtopIndex := 1
RETURN

/*
    setCurrentIndex
*/
METHOD PROCEDURE setCurrentIndex( n ) CLASS HTListBox
    IF n >= 1 .AND. n <= Len( ::Fitems )
        ::FcurrentIndex := n
    ENDIF
RETURN

/*
    firstLetterSearch (HIDDEN - used internally by keyEvent)
*/
METHOD PROCEDURE firstLetterSearch( cLetter ) CLASS HTListBox
    LOCAL i, nStart

    nStart := IIF( ::FcurrentIndex < Len( ::Fitems ), ::FcurrentIndex + 1, 1 )

    /* search from current+1 to end */
    FOR i := nStart TO Len( ::Fitems )
        IF Upper( Left( ::Fitems[ i ], 1 ) ) == cLetter
            ::FcurrentIndex := i
            RETURN
        ENDIF
    NEXT

    /* wrap: search from 1 to current */
    FOR i := 1 TO ::FcurrentIndex
        IF Upper( Left( ::Fitems[ i ], 1 ) ) == cLetter
            ::FcurrentIndex := i
            RETURN
        ENDIF
    NEXT

RETURN
