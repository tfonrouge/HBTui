/** @class HTToolBar
 * Horizontal toolbar with clickable buttons and optional shortcut keys.
 * @extends HTWidget
 */

#include "hbtui.ch"
#include "inkey.ch"


CLASS HTToolBar FROM HTWidget

PROTECTED:

    DATA FaButtons      INIT {}     /* array of { cText, bAction, nKey } */
    DATA FnActiveButton INIT 0

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD paintEvent( event )
    METHOD keyEvent( keyEvent )
    METHOD mouseEvent( eventMouse )

    METHOD addButton( cText, bAction, nShortcutKey )
    METHOD buttonCount() INLINE Len( ::FaButtons )

HIDDEN:

    METHOD recalcWidth()

ENDCLASS

/** Creates a new toolbar with optional parent widget. */
METHOD new( ... ) CLASS HTToolBar

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

    ::setFocusPolicy( HT_FOCUS_TAB )
    ::FisVisible := .T.
    ::Fheight := 1
    ::Fwidth := 1

RETURN self

/** Adds a button to the toolbar.
 * @param cText Button label text
 * @param bAction Code block invoked on activation
 * @param nShortcutKey Optional Inkey code for keyboard shortcut
 * @return 1-based button index
 */
METHOD addButton( cText, bAction, nShortcutKey ) CLASS HTToolBar

    LOCAL nIndex

    AAdd( ::FaButtons, { cText, bAction, nShortcutKey } )
    nIndex := Len( ::FaButtons )

    IF ::FnActiveButton = 0
        ::FnActiveButton := 1
    ENDIF

    /* recalculate width: each button is "[ text ] " */
    ::recalcWidth()

RETURN nIndex

/** Recalculates total widget width from button labels and separators. */
METHOD PROCEDURE recalcWidth() CLASS HTToolBar

    LOCAL i, nTotal := 0

    FOR i := 1 TO Len( ::FaButtons )
        nTotal += Len( ::FaButtons[ i ][ 1 ] ) + 4
        IF i < Len( ::FaButtons )
            nTotal += 1   /* separator space */
        ENDIF
    NEXT

    ::Fwidth := Max( 1, nTotal )

RETURN

/** Renders buttons with active-button highlighting when focused.
 * @param event HTPaintEvent (unused)
 */
METHOD PROCEDURE paintEvent( event ) CLASS HTToolBar

    LOCAL i, cDisplay, cBtnText, cColor, cBtnColor
    LOCAL nMaxCol := MaxCol()
    LOCAL lFocused := ::hasFocus()

    HB_SYMBOL_UNUSED( event )

    cColor := IIF( lFocused, HTTheme():getColor( HT_CLR_TOOLBAR_FOCUSED ), HTTheme():getColor( HT_CLR_TOOLBAR_NORMAL ) )
    cDisplay := ""

    FOR i := 1 TO Len( ::FaButtons )
        cBtnText := "[ " + ::FaButtons[ i ][ 1 ] + " ]"
        IF i < Len( ::FaButtons )
            cBtnText += " "
        ENDIF

        IF lFocused .AND. i = ::FnActiveButton
            cBtnColor := HTTheme():getColor( HT_CLR_TOOLBAR_ACTIVE )
        ELSE
            cBtnColor := cColor
        ENDIF

        DispOutAt( 0, Len( cDisplay ), cBtnText, cBtnColor )
        cDisplay += cBtnText
    NEXT

    /* pad remaining space */
    IF Len( cDisplay ) <= nMaxCol
        DispOutAt( 0, Len( cDisplay ), Space( nMaxCol + 1 - Len( cDisplay ) ), cColor )
    ENDIF

RETURN

/** Handles Left/Right navigation, Enter/Space activation, and shortcut keys.
 * @param keyEvent HTKeyEvent
 */
METHOD PROCEDURE keyEvent( keyEvent ) CLASS HTToolBar

    LOCAL parent
    LOCAL nOldActive := ::FnActiveButton
    LOCAL i

    SWITCH keyEvent:key
    CASE K_LEFT
        IF ::FnActiveButton > 1
            ::FnActiveButton--
        ENDIF
        EXIT
    CASE K_RIGHT
        IF ::FnActiveButton < Len( ::FaButtons )
            ::FnActiveButton++
        ENDIF
        EXIT
    CASE K_ENTER
    CASE K_SPACE
        IF ::FnActiveButton > 0 .AND. ::FnActiveButton <= Len( ::FaButtons )
            IF ::FaButtons[ ::FnActiveButton ][ 2 ] != NIL
                Eval( ::FaButtons[ ::FnActiveButton ][ 2 ] )
            ENDIF
        ENDIF
        keyEvent:accept()
        RETURN
    OTHERWISE
        /* check shortcut keys */
        FOR i := 1 TO Len( ::FaButtons )
            IF ::FaButtons[ i ][ 3 ] != NIL .AND. ::FaButtons[ i ][ 3 ] = keyEvent:key
                ::FnActiveButton := i
                IF ::FaButtons[ i ][ 2 ] != NIL
                    Eval( ::FaButtons[ i ][ 2 ] )
                ENDIF
                keyEvent:accept()
                RETURN
            ENDIF
        NEXT
        RETURN
    ENDSWITCH

    keyEvent:accept()

    IF ::FnActiveButton != nOldActive
        parent := ::parent()
        IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
            parent:repaintChild( self )
        ENDIF
    ENDIF

RETURN

/** Handles mouse click to activate the clicked button.
 * @param eventMouse HTMouseEvent
 */
METHOD PROCEDURE mouseEvent( eventMouse ) CLASS HTToolBar

    LOCAL nClickCol, nCol, i, nBtnStart, nBtnEnd
    LOCAL parent

    IF eventMouse:nKey = K_LBUTTONDOWN
        nClickCol := eventMouse:mouseCol
        IF nClickCol >= 0
            nCol := 0
            FOR i := 1 TO Len( ::FaButtons )
                nBtnStart := nCol
                nBtnEnd := nCol + Len( ::FaButtons[ i ][ 1 ] ) + 3
                IF nClickCol >= nBtnStart .AND. nClickCol <= nBtnEnd
                    ::FnActiveButton := i
                    IF ::FaButtons[ i ][ 2 ] != NIL
                        Eval( ::FaButtons[ i ][ 2 ] )
                    ENDIF
                    parent := ::parent()
                    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
                        parent:repaintChild( self )
                    ENDIF
                    RETURN
                ENDIF
                nCol := nBtnEnd + 2   /* "] " separator */
            NEXT
        ENDIF
    ENDIF

RETURN
