/*
 * HTComboBox - Combo box with dropdown list
 *
 * Displays current selection in a compact row.
 * Alt+Down, Space, or click opens a dropdown popup (CT window).
 * Up/Down without opening changes selection directly.
 */

#include "hbtui.ch"
#include "inkey.ch"

#define _CMB_COLOR_NORMAL   "N/W"
#define _CMB_COLOR_FOCUSED  "N/BG"
#define _CMB_COLOR_DROP_N   "N/W"
#define _CMB_COLOR_DROP_S   "W+/B"
#define _CMB_DROP_MAXROWS   8

CLASS HTComboBox FROM HTWidget

PROTECTED:

    DATA Fitems          INIT {}
    DATA FitemData       INIT {}
    DATA FcurrentIndex   INIT 0
    DATA FdroppedDown    INIT .F.
    DATA FdropWinId      INIT NIL
    DATA FdropTopIndex   INIT 1

    METHOD showPopup()
    METHOD hidePopup()
    METHOD paintDropdown()

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD paintEvent( paintEvent )
    METHOD keyEvent( keyEvent )
    METHOD mouseEvent( eventMouse )

    METHOD addItem( cText, xData )
    METHOD count()          INLINE Len( ::Fitems )
    METHOD currentIndex()   INLINE ::FcurrentIndex
    METHOD currentText()    INLINE IIF( ::FcurrentIndex > 0 .AND. ::FcurrentIndex <= Len( ::Fitems ), ::Fitems[ ::FcurrentIndex ], "" )
    METHOD currentData()    INLINE IIF( ::FcurrentIndex > 0 .AND. ::FcurrentIndex <= Len( ::FitemData ), ::FitemData[ ::FcurrentIndex ], NIL )
    METHOD setCurrentIndex( n )

    PROPERTY onChanged                          /* {|nIndex| ... } */

ENDCLASS

/*
    new
*/
METHOD new( ... ) CLASS HTComboBox

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
    ::Fheight := 1
    ::Fwidth := 20

RETURN self

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HTComboBox

    LOCAL cDisplay, cArrow, cColor
    LOCAL nMaxCol := MaxCol()

    HB_SYMBOL_UNUSED( paintEvent )

    cColor := IIF( ::hasFocus(), _CMB_COLOR_FOCUSED, _CMB_COLOR_NORMAL )
    cArrow := IIF( ::FdroppedDown, e"\x1e", e"\x1f" )

    cDisplay := ""
    IF ::FcurrentIndex > 0 .AND. ::FcurrentIndex <= Len( ::Fitems )
        cDisplay := ::Fitems[ ::FcurrentIndex ]
    ENDIF

    cDisplay := PadR( cDisplay, Max( 0, nMaxCol ) ) + cArrow

    IF Len( cDisplay ) > nMaxCol + 1
        cDisplay := Left( cDisplay, nMaxCol + 1 )
    ENDIF

    DispOutAt( 0, 0, cDisplay, cColor )

RETURN

/*
    keyEvent
*/
METHOD PROCEDURE keyEvent( keyEvent ) CLASS HTComboBox

    LOCAL parent
    LOCAL nOldIndex := ::FcurrentIndex

    IF ::FdroppedDown

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
            ::FcurrentIndex := Max( 1, ::FcurrentIndex - _CMB_DROP_MAXROWS )
            EXIT
        CASE K_PGDN
            ::FcurrentIndex := Min( Len( ::Fitems ), ::FcurrentIndex + _CMB_DROP_MAXROWS )
            EXIT
        CASE K_HOME
            ::FcurrentIndex := 1
            EXIT
        CASE K_END
            ::FcurrentIndex := Len( ::Fitems )
            EXIT
        CASE K_ENTER
            ::hidePopup()
            EXIT
        CASE K_ESC
            ::FcurrentIndex := nOldIndex
            ::hidePopup()
            EXIT
        OTHERWISE
            RETURN
        ENDSWITCH

        keyEvent:accept()

        IF ::FcurrentIndex != nOldIndex .AND. ::FonChanged != NIL
            Eval( ::FonChanged, ::FcurrentIndex )
        ENDIF

        IF ::FdroppedDown
            ::paintDropdown()
            /* reselect parent window after painting dropdown */
            parent := ::parent()
            IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
                wSelect( parent:windowId, .F. )
                parent:repaintChild( self )
            ENDIF
        ELSE
            parent := ::parent()
            IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
                parent:repaintChild( self )
            ENDIF
        ENDIF

    ELSE

        SWITCH keyEvent:key
        CASE K_ALT_DOWN
            ::showPopup()
            EXIT
        CASE K_SPACE
            ::showPopup()
            EXIT
        CASE K_DOWN
            IF ::FcurrentIndex < Len( ::Fitems )
                ::FcurrentIndex++
            ENDIF
            EXIT
        CASE K_UP
            IF ::FcurrentIndex > 1
                ::FcurrentIndex--
            ENDIF
            EXIT
        OTHERWISE
            RETURN
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

    ENDIF

RETURN

/*
    mouseEvent
*/
METHOD PROCEDURE mouseEvent( eventMouse ) CLASS HTComboBox

    IF eventMouse:nKey = K_LBUTTONDOWN
        IF ::FdroppedDown
            ::hidePopup()
        ELSE
            ::showPopup()
        ENDIF
    ENDIF

RETURN

/*
    showPopup
*/
METHOD PROCEDURE showPopup() CLASS HTComboBox

    LOCAL nDropRows, nDropTop, nDropLeft, nDropBottom, nDropRight
    LOCAL parent

    IF Len( ::Fitems ) = 0 .OR. ::FdroppedDown
        RETURN
    ENDIF

    ::FdroppedDown := .T.

    nDropRows := Min( Len( ::Fitems ), _CMB_DROP_MAXROWS )

    /* dropdown appears below the combo box in absolute screen coordinates */
    nDropTop    := wRow() + 1 + ::Fy + 1
    nDropLeft   := wCol() + 1 + ::Fx
    nDropBottom := nDropTop + nDropRows - 1
    nDropRight  := nDropLeft + ::Fwidth - 1

    /* if not enough room below, open above */
    IF nDropBottom > MaxRow()
        nDropTop    := wRow() + 1 + ::Fy - nDropRows
        nDropBottom := nDropTop + nDropRows - 1
    ENDIF

    /* ensure topIndex keeps current visible */
    IF ::FcurrentIndex > 0
        ::FdropTopIndex := Max( 1, Min( ::FcurrentIndex, Len( ::Fitems ) - nDropRows + 1 ) )
    ELSE
        ::FdropTopIndex := 1
    ENDIF

    ::FdropWinId := wOpen( nDropTop, nDropLeft, nDropBottom, nDropRight, .T. )
    wSetShadow( 8 )

    ::paintDropdown()

    /* reselect parent window so keyboard events keep flowing
     * through the main window -> focused child (this combobox) */
    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        wSelect( parent:windowId, .F. )
    ENDIF

RETURN

/*
    hidePopup
*/
METHOD PROCEDURE hidePopup() CLASS HTComboBox

    LOCAL parent

    IF ::FdropWinId != NIL
        wClose( ::FdropWinId )
        ::FdropWinId := NIL
    ENDIF

    ::FdroppedDown := .F.

    /* reselect parent window */
    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        wSelect( parent:windowId, .F. )
    ENDIF

RETURN

/*
    paintDropdown
*/
METHOD PROCEDURE paintDropdown() CLASS HTComboBox

    LOCAL i, nRow, cText, cColor
    LOCAL nMaxRow, nMaxCol, nVisibleRows

    IF ::FdropWinId = NIL
        RETURN
    ENDIF

    wSelect( ::FdropWinId, .T. )

    nMaxRow := MaxRow()
    nMaxCol := MaxCol()
    nVisibleRows := nMaxRow + 1

    IF ::FcurrentIndex > 0
        IF ::FcurrentIndex < ::FdropTopIndex
            ::FdropTopIndex := ::FcurrentIndex
        ENDIF
        IF ::FcurrentIndex >= ::FdropTopIndex + nVisibleRows
            ::FdropTopIndex := ::FcurrentIndex - nVisibleRows + 1
        ENDIF
    ENDIF

    nRow := 0
    FOR i := ::FdropTopIndex TO Min( ::FdropTopIndex + nVisibleRows - 1, Len( ::Fitems ) )
        cText := PadR( ::Fitems[ i ], nMaxCol + 1 )
        cColor := IIF( i = ::FcurrentIndex, _CMB_COLOR_DROP_S, _CMB_COLOR_DROP_N )
        DispOutAt( nRow, 0, cText, cColor )
        nRow++
    NEXT

    DO WHILE nRow <= nMaxRow
        DispOutAt( nRow, 0, Space( nMaxCol + 1 ), _CMB_COLOR_DROP_N )
        nRow++
    ENDDO

RETURN

/*
    addItem
*/
METHOD PROCEDURE addItem( cText, xData ) CLASS HTComboBox
    AAdd( ::Fitems, cText )
    AAdd( ::FitemData, xData )
    IF ::FcurrentIndex = 0
        ::FcurrentIndex := 1
    ENDIF
RETURN

/*
    setCurrentIndex
*/
METHOD PROCEDURE setCurrentIndex( n ) CLASS HTComboBox
    IF n >= 1 .AND. n <= Len( ::Fitems )
        ::FcurrentIndex := n
    ENDIF
RETURN
