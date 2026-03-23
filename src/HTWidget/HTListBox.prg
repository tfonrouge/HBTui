/** @class HTListBox
 * Scrollable selectable list with keyboard navigation, mouse support, and first-letter search.
 * @extends HTWidget
 */

#include "hbtui.ch"
#include "inkey.ch"


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
    METHOD firstLetterSearch( cLetter )

    PROPERTY onChanged READWRITE                 /* {|nIndex| ... } */
    PROPERTY onActivated READWRITE               /* {|nIndex| ... } Enter/dblclick */

ENDCLASS

/** Creates a new list box with optional parent widget. */
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

/** Renders visible items with selection highlight and scroll indicator.
 * @param paintEvent HTPaintEvent (unused)
 */
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HTListBox

    LOCAL i, nRow, cText, cColor
    LOCAL nMaxRow := MaxRow()
    LOCAL nMaxCol := MaxCol()
    LOCAL nVisibleRows := nMaxRow + 1
    LOCAL lFocused := ::hasFocus()
    LOCAL cSelColor := IIF( lFocused, HTTheme():getColor( HT_CLR_LIST_SELECTED ), HTTheme():getColor( HT_CLR_LIST_SEL_UNFOC ) )
    LOCAL cNrmColor := IIF( lFocused, HTTheme():getColor( HT_CLR_LIST_NORMAL ), HTTheme():getColor( HT_CLR_LIST_NORMAL ) )
    LOCAL nItemCount := Len( ::Fitems )
    LOCAL cScrollChar
    LOCAL nThumbPos, nThumbSize, nRange

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

    /* calculate proportional scrollbar thumb */
    nThumbPos := 0
    nThumbSize := 0
    IF nItemCount > nVisibleRows
        nRange := nItemCount - nVisibleRows
        nThumbSize := Max( 1, Int( nVisibleRows * nVisibleRows / nItemCount ) )
        nThumbPos := Int( ( ::FtopIndex - 1 ) * ( nVisibleRows - nThumbSize ) / Max( 1, nRange ) )
        nThumbPos := Max( 0, Min( nThumbPos, nVisibleRows - nThumbSize ) )
    ENDIF

    nRow := 0
    FOR i := ::FtopIndex TO Min( ::FtopIndex + nVisibleRows - 1, nItemCount )
        cText := PadR( ::Fitems[ i ], Max( 0, nMaxCol ) )

        /* proportional scrollbar on right edge */
        IF nItemCount > nVisibleRows .AND. nMaxCol >= 0
            cScrollChar := IIF( nRow >= nThumbPos .AND. nRow < nThumbPos + nThumbSize, e"\xDB", e"\xB0" )
            cText += cScrollChar
        ELSE
            cText += " "
        ENDIF

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

/** Handles navigation (Up/Down/PgUp/PgDn/Home/End), Enter activation, and first-letter search.
 * @param keyEvent HTKeyEvent
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

/** Handles mouse click to select item and mouse wheel to scroll.
 * @param eventMouse HTMouseEvent
 */
METHOD PROCEDURE mouseEvent( eventMouse ) CLASS HTListBox

    LOCAL nClickRow, nIndex
    LOCAL parent

    SWITCH eventMouse:nKey
    CASE K_LBUTTONDOWN
        /* mouseRow is child-relative (translated by parent's dispatch) */
        nClickRow := eventMouse:mouseRow
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

/** Appends an item to the list.
 * @param cText Display text
 * @param xData Optional associated data
 */
METHOD PROCEDURE addItem( cText, xData ) CLASS HTListBox
    AAdd( ::Fitems, cText )
    AAdd( ::FitemData, xData )
    IF ::FcurrentIndex = 0
        ::FcurrentIndex := 1
    ENDIF
    ::Fwidth := Max( ::Fwidth, Len( cText ) )
RETURN

/** Removes the item at the given index.
 * @param nIndex 1-based item index
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

/** Removes all items and resets selection. */
METHOD PROCEDURE clear() CLASS HTListBox
    ::Fitems := {}
    ::FitemData := {}
    ::FcurrentIndex := 0
    ::FtopIndex := 1
RETURN

/** Sets the current selection index.
 * @param n 1-based item index
 */
METHOD PROCEDURE setCurrentIndex( n ) CLASS HTListBox
    IF n >= 1 .AND. n <= Len( ::Fitems )
        ::FcurrentIndex := n
    ENDIF
RETURN

/** Jumps to the next item starting with the given letter, wrapping around.
 * @param cLetter Uppercase letter to search for
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
