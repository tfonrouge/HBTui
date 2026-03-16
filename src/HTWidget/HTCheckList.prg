/** @class HTCheckList
 * Scrollable list where each item has a checkbox toggled with Space.
 * @extends HTWidget
 */

#include "hbtui.ch"
#include "inkey.ch"


CLASS HTCheckList FROM HTWidget

PROTECTED:

    DATA Fitems          INIT {}
    DATA FitemChecked    INIT {}
    DATA FcurrentIndex   INIT 0
    DATA FtopIndex       INIT 1

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD paintEvent( paintEvent )
    METHOD keyEvent( keyEvent )
    METHOD mouseEvent( eventMouse )

    METHOD addItem( cText, lChecked )
    METHOD isChecked( nIndex )
    METHOD setChecked( nIndex, lChecked )
    METHOD checkedItems()
    METHOD checkedCount()
    METHOD count()          INLINE Len( ::Fitems )
    METHOD currentIndex()   INLINE ::FcurrentIndex
    METHOD currentText()    INLINE IIF( ::FcurrentIndex > 0 .AND. ::FcurrentIndex <= Len( ::Fitems ), ::Fitems[ ::FcurrentIndex ], "" )

    PROPERTY onChanged READWRITE                 /* {|nIndex, lChecked| ... } */

HIDDEN:

    METHOD firstLetterSearch( cLetter )

ENDCLASS

/** Creates a new checklist with optional parent widget. */
METHOD new( ... ) CLASS HTCheckList

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

/** Renders visible items with checkbox marks and scroll indicator.
 * @param paintEvent HTPaintEvent (unused)
 */
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HTCheckList

    LOCAL i, nRow, cText, cColor, cCheckMark, cLine
    LOCAL nMaxRow := MaxRow()
    LOCAL nMaxCol := MaxCol()
    LOCAL nVisibleRows := nMaxRow + 1
    LOCAL lFocused := ::hasFocus()
    LOCAL cSelColor := IIF( lFocused, HTTheme():getColor( HT_CLR_CHECKLIST_SELECTED ), HTTheme():getColor( HT_CLR_CHECKLIST_SELUNFOC ) )
    LOCAL cNrmColor := IIF( lFocused, HTTheme():getColor( HT_CLR_CHECKLIST_NORMAL ), HTTheme():getColor( HT_CLR_CHECKLIST_NORMAL ) )
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
        cCheckMark := IIF( ::FitemChecked[ i ], Chr( 251 ), " " )
        cLine := "[" + cCheckMark + "] " + ::Fitems[ i ]
        cText := PadR( cLine, Max( 0, nMaxCol ) )

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

/** Handles navigation, Space to toggle checkbox, and first-letter search.
 * @param keyEvent HTKeyEvent
 */
METHOD PROCEDURE keyEvent( keyEvent ) CLASS HTCheckList

    LOCAL parent
    LOCAL nOldIndex := ::FcurrentIndex
    LOCAL cKey
    LOCAL lToggled := .F.

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
    CASE K_SPACE
        IF ::FcurrentIndex > 0 .AND. ::FcurrentIndex <= Len( ::FitemChecked )
            ::FitemChecked[ ::FcurrentIndex ] := ! ::FitemChecked[ ::FcurrentIndex ]
            lToggled := .T.
        ENDIF
        EXIT
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

    IF lToggled .AND. ::FonChanged != NIL
        Eval( ::FonChanged, ::FcurrentIndex, ::FitemChecked[ ::FcurrentIndex ] )
    ENDIF

    IF ::FcurrentIndex != nOldIndex .OR. lToggled
        parent := ::parent()
        IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
            parent:repaintChild( self )
        ENDIF
    ENDIF

RETURN

/** Handles mouse click to select item and mouse wheel to scroll.
 * @param eventMouse HTMouseEvent
 */
METHOD PROCEDURE mouseEvent( eventMouse ) CLASS HTCheckList

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

/** Appends an item to the checklist.
 * @param cText Display text
 * @param lChecked Initial checked state (default .F.)
 */
METHOD PROCEDURE addItem( cText, lChecked ) CLASS HTCheckList

    IF lChecked = NIL
        lChecked := .F.
    ENDIF
    AAdd( ::Fitems, cText )
    AAdd( ::FitemChecked, lChecked )
    IF ::FcurrentIndex = 0
        ::FcurrentIndex := 1
    ENDIF

RETURN

/** Returns the checked state of an item.
 * @param nIndex 1-based item index
 * @return .T. if checked, .F. otherwise
 */
METHOD isChecked( nIndex ) CLASS HTCheckList

    IF nIndex >= 1 .AND. nIndex <= Len( ::FitemChecked )
        RETURN ::FitemChecked[ nIndex ]
    ENDIF

RETURN .F.

/** Sets the checked state of an item.
 * @param nIndex 1-based item index
 * @param lChecked New checked state
 */
METHOD PROCEDURE setChecked( nIndex, lChecked ) CLASS HTCheckList

    IF nIndex >= 1 .AND. nIndex <= Len( ::FitemChecked )
        ::FitemChecked[ nIndex ] := lChecked
    ENDIF

RETURN

/** Returns an array of 1-based indices for all checked items.
 * @return Array of checked item indices
 */
METHOD checkedItems() CLASS HTCheckList

    LOCAL aResult := {}
    LOCAL i

    FOR i := 1 TO Len( ::FitemChecked )
        IF ::FitemChecked[ i ]
            AAdd( aResult, i )
        ENDIF
    NEXT

RETURN aResult

/** Returns the number of checked items.
 * @return Count of checked items
 */
METHOD checkedCount() CLASS HTCheckList

    LOCAL nCount := 0
    LOCAL i

    FOR i := 1 TO Len( ::FitemChecked )
        IF ::FitemChecked[ i ]
            nCount++
        ENDIF
    NEXT

RETURN nCount

/** Jumps to the next item starting with the given letter, wrapping around.
 * @param cLetter Uppercase letter to search for
 */
METHOD PROCEDURE firstLetterSearch( cLetter ) CLASS HTCheckList

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
