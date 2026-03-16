/*
 * HTToolBar - Horizontal toolbar with buttons
 */

#include "hbtui.ch"
#include "inkey.ch"

#define _TBR_COLOR_NORMAL   "N/W"
#define _TBR_COLOR_FOCUSED  "N/BG"
#define _TBR_COLOR_ACTIVE   "W+/B"

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

/*
    new
*/
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

/*
    addButton
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

/*
    recalcWidth
*/
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

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( event ) CLASS HTToolBar

    LOCAL i, cDisplay, cBtnText, cColor, cBtnColor
    LOCAL nMaxCol := MaxCol()
    LOCAL lFocused := ::hasFocus()

    HB_SYMBOL_UNUSED( event )

    cColor := IIF( lFocused, _TBR_COLOR_FOCUSED, _TBR_COLOR_NORMAL )
    cDisplay := ""

    FOR i := 1 TO Len( ::FaButtons )
        cBtnText := "[ " + ::FaButtons[ i ][ 1 ] + " ]"
        IF i < Len( ::FaButtons )
            cBtnText += " "
        ENDIF

        IF lFocused .AND. i = ::FnActiveButton
            cBtnColor := _TBR_COLOR_ACTIVE
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

/*
    keyEvent
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

/*
    mouseEvent
*/
METHOD PROCEDURE mouseEvent( eventMouse ) CLASS HTToolBar

    LOCAL nClickCol, nCol, i, nBtnStart, nBtnEnd
    LOCAL parent

    IF eventMouse:nKey = K_LBUTTONDOWN
        nClickCol := eventMouse:mouseCol - 1 - ::Fx
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
