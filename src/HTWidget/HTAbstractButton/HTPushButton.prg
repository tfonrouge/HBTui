/** @class HTPushButton
 * Standard push button activated by Enter or Space key.
 * @extends HTAbstractButton
 */

#include "hbtui.ch"
#include "inkey.ch"


CLASS HTPushButton FROM HTAbstractButton

PROTECTED:
PUBLIC:

    METHOD new( ... )
    METHOD paintEvent( paintEvent )
    METHOD keyEvent( keyEvent )
    METHOD mouseEvent( eventMouse )

    PROPERTY autoDefault
    PROPERTY default

ENDCLASS

/** Creates a new push button. Accepts optional text and/or parent widget. */
METHOD new( ... ) CLASS HTPushButton

    LOCAL p

    IF pCount() > 0
        p := hb_pValue( 1 )
        IF hb_isObject( p )
            ::super:new( p )
        ELSE
            ::setText( p )
            ::super:new( hb_pValue( 2 ) )
        ENDIF
    ELSE
        ::super:new()
    ENDIF

    ::setFocusPolicy( HT_FOCUS_STRONG )
    ::FisVisible := .T.
    ::Fheight := 1
    ::Fwidth := Len( ::Ftext ) + 4

RETURN self

/** Renders the button as "[ text ]" with focus-dependent coloring.
 * @param paintEvent HTPaintEvent (unused)
 */
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HTPushButton

    LOCAL cDisplay
    LOCAL cColor

    HB_SYMBOL_UNUSED( paintEvent )

    cColor := IIF( ::hasFocus(), HTTheme():getColor( HT_CLR_BUTTON_FOCUSED ), HTTheme():getColor( HT_CLR_BUTTON_NORMAL ) )
    cDisplay := "[ " + ::Ftext + " ]"

    IF Len( cDisplay ) > MaxCol() + 1
        cDisplay := Left( cDisplay, MaxCol() + 1 )
    ENDIF

    DispOutAt( 0, 0, cDisplay, cColor )

RETURN

/** Fires the onClicked callback on mouse click.
 * @param eventMouse HTMouseEvent
 */
METHOD PROCEDURE mouseEvent( eventMouse ) CLASS HTPushButton

    IF eventMouse:nKey = K_LBUTTONDOWN
        IF ::FonClicked != NIL
            Eval( ::FonClicked )
        ENDIF
    ENDIF

RETURN

/** Fires the onClicked callback on Enter or Space.
 * @param keyEvent HTKeyEvent
 */
METHOD PROCEDURE keyEvent( keyEvent ) CLASS HTPushButton

    IF keyEvent:key = K_ENTER .OR. keyEvent:key = K_SPACE
        IF ::FonClicked != NIL
            Eval( ::FonClicked )
        ENDIF
        keyEvent:accept()
    ENDIF

RETURN
