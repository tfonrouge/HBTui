/** @class HTComboBox
 * Dropdown combo box. Shows current selection in a single row;
 * opens a CT popup window for item selection via Alt+Down, Space, or click.
 * @extends HTWidget
 */

#include "hbtui.ch"
#include "inkey.ch"

#define _CMB_DROP_MAXROWS   8

CLASS HTComboBox FROM HTWidget

PROTECTED:

    DATA Fitems          INIT {}
    DATA FitemData       INIT {}
    DATA FcurrentIndex   INIT 0
    DATA FdroppedDown    INIT .F.
    DATA FdropWinId      INIT NIL
    DATA FdropTopIndex   INIT 1
    DATA FtypeBuffer     INIT ""
    DATA FtypeTime       INIT 0

    METHOD showPopup()
    METHOD hidePopup()
    METHOD paintDropdown()
    METHOD dropdownLoop()
    METHOD typeSearch( cChar )

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD destroy()
    METHOD paintEvent( paintEvent )
    METHOD keyEvent( keyEvent )
    METHOD mouseEvent( eventMouse )

    METHOD addItem( cText, xData )
    METHOD count()          INLINE Len( ::Fitems )
    METHOD currentIndex()   INLINE ::FcurrentIndex
    METHOD currentText()    INLINE IIF( ::FcurrentIndex > 0 .AND. ::FcurrentIndex <= Len( ::Fitems ), ::Fitems[ ::FcurrentIndex ], "" )
    METHOD currentData()    INLINE IIF( ::FcurrentIndex > 0 .AND. ::FcurrentIndex <= Len( ::FitemData ), ::FitemData[ ::FcurrentIndex ], NIL )
    METHOD setCurrentIndex( n )

    PROPERTY onChanged READWRITE                 /* {|nIndex| ... } */

ENDCLASS

/** Creates a new combo box with optional parent widget. */
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

/** Closes the dropdown popup if open, then destroys the widget. */
METHOD PROCEDURE destroy() CLASS HTComboBox
    ::hidePopup()
    ::super:destroy()
RETURN

/** Renders the current selection text with a dropdown arrow indicator.
 * @param paintEvent HTPaintEvent (unused)
 */
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HTComboBox

    LOCAL cDisplay, cArrow, cColor
    LOCAL nMaxCol := MaxCol()

    HB_SYMBOL_UNUSED( paintEvent )

    cColor := IIF( ::hasFocus(), HTTheme():getColor( HT_CLR_COMBO_FOCUSED ), HTTheme():getColor( HT_CLR_COMBO_NORMAL ) )
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

/** Handles navigation in both closed (Up/Down) and open (full navigation + Enter/Esc) states.
 * @param keyEvent HTKeyEvent
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
            /* type-to-filter in dropdown */
            IF ::typeSearch( hb_keyChar( keyEvent:key ) )
                EXIT
            ENDIF
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
            /* type-to-filter when closed */
            IF ::typeSearch( hb_keyChar( keyEvent:key ) )
                EXIT
            ENDIF
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

/** Toggles the dropdown popup on left-button click.
 * @param eventMouse HTMouseEvent
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

/** Opens the dropdown popup as a CT window below (or above) the combo box. */
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

    /* run modal dropdown loop — handles mouse/keyboard selection */
    ::dropdownLoop()

    /* reselect parent window so keyboard events keep flowing
     * through the main window -> focused child (this combobox) */
    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        wSelect( parent:windowId, .F. )
        parent:repaintChild( self )
    ENDIF

RETURN

/** Closes the dropdown popup CT window and reselects the parent window. */
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

/** Paints the dropdown list items with selection highlight inside the popup CT window. */
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
        cColor := IIF( i = ::FcurrentIndex, HTTheme():getColor( HT_CLR_COMBO_DROP_S ), HTTheme():getColor( HT_CLR_COMBO_DROP_N ) )
        DispOutAt( nRow, 0, cText, cColor )
        nRow++
    NEXT

    DO WHILE nRow <= nMaxRow
        DispOutAt( nRow, 0, Space( nMaxCol + 1 ), HTTheme():getColor( HT_CLR_COMBO_DROP_N ) )
        nRow++
    ENDDO

RETURN

/** Modal event loop for the open dropdown.
 * Handles mouse clicks (select item or close), keyboard navigation,
 * and type-to-filter. Exits when dropdown is closed.
 */
METHOD PROCEDURE dropdownLoop() CLASS HTComboBox

    LOCAL event, nRow, nOldIndex, nClickWin

    nOldIndex := ::FcurrentIndex

    DO WHILE ::FdroppedDown
        event := HTEventLoop():poll( 0.05 )

        IF event = NIL
            LOOP
        ENDIF

        IF event:isDerivedFrom( "HTMouseEvent" )
            IF event:nKey = K_LBUTTONDOWN
                nClickWin := ht_windowAtMousePos()
                IF nClickWin = ::FdropWinId
                    /* click inside dropdown: select item at mouse row */
                    wSelect( ::FdropWinId, .F. )
                    nRow := mRow()
                    IF nRow >= 0 .AND. nRow <= MaxRow()
                        ::FcurrentIndex := ::FdropTopIndex + nRow
                        IF ::FcurrentIndex > Len( ::Fitems )
                            ::FcurrentIndex := Len( ::Fitems )
                        ENDIF
                    ENDIF
                    ::hidePopup()
                ELSE
                    /* click outside dropdown: close without changing */
                    ::hidePopup()
                ENDIF
            ENDIF
        ELSEIF event:isDerivedFrom( "HTKeyEvent" )
            SWITCH event:key
            CASE K_ESC
                ::FcurrentIndex := nOldIndex
                ::hidePopup()
                EXIT
            CASE K_ENTER
                ::hidePopup()
                EXIT
            CASE K_DOWN
                IF ::FcurrentIndex < Len( ::Fitems )
                    ::FcurrentIndex++
                    ::paintDropdown()
                ENDIF
                EXIT
            CASE K_UP
                IF ::FcurrentIndex > 1
                    ::FcurrentIndex--
                    ::paintDropdown()
                ENDIF
                EXIT
            OTHERWISE
                IF ::typeSearch( hb_keyChar( event:key ) )
                    ::paintDropdown()
                ENDIF
            ENDSWITCH
        ENDIF
    ENDDO

    IF ::FcurrentIndex != nOldIndex .AND. ::FonChanged != NIL
        Eval( ::FonChanged, ::FcurrentIndex )
    ENDIF

RETURN

/** Appends an item to the combo box.
 * @param cText Display text
 * @param xData Optional associated data
 */
METHOD PROCEDURE addItem( cText, xData ) CLASS HTComboBox
    AAdd( ::Fitems, cText )
    AAdd( ::FitemData, xData )
    IF ::FcurrentIndex = 0
        ::FcurrentIndex := 1
    ENDIF
RETURN

/** Sets the current selection index.
 * @param n 1-based item index
 */
METHOD PROCEDURE setCurrentIndex( n ) CLASS HTComboBox
    IF n >= 1 .AND. n <= Len( ::Fitems )
        ::FcurrentIndex := n
    ENDIF
RETURN

/** Accumulates typed characters and jumps to the first matching item.
 * Resets the type buffer after 1 second of inactivity.
 * @param cChar Character typed
 * @return .T. if the character was consumed
 */
METHOD FUNCTION typeSearch( cChar ) CLASS HTComboBox

    LOCAL i, nNow

    IF ! hb_isString( cChar ) .OR. Len( cChar ) != 1 .OR. Asc( cChar ) < 32
        RETURN .F.
    ENDIF

    nNow := Seconds()

    /* reset buffer after 1 second gap */
    IF nNow - ::FtypeTime > 1
        ::FtypeBuffer := ""
    ENDIF

    ::FtypeBuffer += Upper( cChar )
    ::FtypeTime := nNow

    /* search for first item starting with the accumulated buffer */
    FOR i := 1 TO Len( ::Fitems )
        IF Upper( Left( ::Fitems[ i ], Len( ::FtypeBuffer ) ) ) == ::FtypeBuffer
            ::FcurrentIndex := i
            RETURN .T.
        ENDIF
    NEXT

RETURN .T.
