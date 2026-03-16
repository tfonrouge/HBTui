/** @class HTCheckBox
 * Checkbox toggle widget. Toggles on Space key or mouse click.
 * @extends HTAbstractButton
 */

#include "hbtui.ch"
#include "inkey.ch"


CLASS HTCheckBox FROM HTAbstractButton

PROTECTED:
PUBLIC:

    METHOD new( ... )
    METHOD paintEvent( paintEvent )
    METHOD keyEvent( keyEvent )
    METHOD mouseEvent( eventMouse )
    METHOD toggle()

ENDCLASS

/** Creates a new checkbox. Accepts optional text and/or parent widget. */
METHOD new( ... ) CLASS HTCheckBox

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

    ::Fcheckable := .T.
    ::setFocusPolicy( HT_FOCUS_STRONG )
    ::FisVisible := .T.
    ::Fheight := 1
    ::Fwidth := Len( ::Ftext ) + 4

RETURN self

/** Renders the checkbox as "[x] text" or "[ ] text" with focus coloring.
 * @param paintEvent HTPaintEvent (unused)
 */
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HTCheckBox

    LOCAL cMark
    LOCAL cDisplay
    LOCAL cColor

    HB_SYMBOL_UNUSED( paintEvent )

    cMark := IIF( ::Fchecked, e"\xFB", " " )
    cDisplay := "[" + cMark + "] " + ::Ftext
    cColor := IIF( ::hasFocus(), HTTheme():getColor( HT_CLR_CHECK_FOCUSED ), HTTheme():getColor( HT_CLR_CHECK_NORMAL ) )

    IF Len( cDisplay ) > MaxCol() + 1
        cDisplay := Left( cDisplay, MaxCol() + 1 )
    ENDIF

    DispOutAt( 0, 0, cDisplay, cColor )

RETURN

/** Toggles the checkbox on Space key.
 * @param keyEvent HTKeyEvent
 */
METHOD PROCEDURE keyEvent( keyEvent ) CLASS HTCheckBox

    IF keyEvent:key = K_SPACE
        ::toggle()
        keyEvent:accept()
    ENDIF

RETURN

/** Toggles the checkbox on left-button click.
 * @param eventMouse HTMouseEvent
 */
METHOD PROCEDURE mouseEvent( eventMouse ) CLASS HTCheckBox

    IF eventMouse:nKey = K_LBUTTONDOWN
        ::toggle()
    ENDIF

RETURN

/** Toggles the checked state and fires onToggled/onClicked callbacks. */
METHOD PROCEDURE toggle() CLASS HTCheckBox

    LOCAL parent

    ::Fchecked := ! ::Fchecked

    IF ::FonToggled != NIL
        Eval( ::FonToggled, ::Fchecked )
    ENDIF
    IF ::FonClicked != NIL
        Eval( ::FonClicked )
    ENDIF

    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:repaintChild( self )
    ENDIF

RETURN
