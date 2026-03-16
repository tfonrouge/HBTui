/** @class HTRadioButton
 * Radio button with auto-exclusive behavior: selecting one unchecks siblings in the same parent.
 * @extends HTAbstractButton
 */

#include "hbtui.ch"
#include "inkey.ch"


CLASS HTRadioButton FROM HTAbstractButton

PROTECTED:
PUBLIC:

    METHOD new( ... )
    METHOD paintEvent( paintEvent )
    METHOD keyEvent( keyEvent )
    METHOD mouseEvent( eventMouse )
    METHOD select()

ENDCLASS

/** Creates a new radio button. Accepts optional text and/or parent widget. */
METHOD new( ... ) CLASS HTRadioButton

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
    ::FautoExclusive := .T.
    ::setFocusPolicy( HT_FOCUS_STRONG )
    ::FisVisible := .T.
    ::Fheight := 1
    ::Fwidth := Len( ::Ftext ) + 4

RETURN self

/** Renders the radio button as "(*) text" or "( ) text" with focus coloring.
 * @param paintEvent HTPaintEvent (unused)
 */
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HTRadioButton

    LOCAL cMark
    LOCAL cDisplay
    LOCAL cColor

    HB_SYMBOL_UNUSED( paintEvent )

    cMark := IIF( ::Fchecked, "*", " " )
    cDisplay := "(" + cMark + ") " + ::Ftext
    cColor := IIF( ::hasFocus(), HTTheme():getColor( HT_CLR_CHECK_FOCUSED ), HTTheme():getColor( HT_CLR_CHECK_NORMAL ) )

    IF Len( cDisplay ) > MaxCol() + 1
        cDisplay := Left( cDisplay, MaxCol() + 1 )
    ENDIF

    DispOutAt( 0, 0, cDisplay, cColor )

RETURN

/** Selects this radio button on Space key.
 * @param keyEvent HTKeyEvent
 */
METHOD PROCEDURE keyEvent( keyEvent ) CLASS HTRadioButton

    IF keyEvent:key = K_SPACE
        ::select()
        keyEvent:accept()
    ENDIF

RETURN

/** Selects this radio button on left-button click.
 * @param eventMouse HTMouseEvent
 */
METHOD PROCEDURE mouseEvent( eventMouse ) CLASS HTRadioButton

    IF eventMouse:nKey = K_LBUTTONDOWN
        ::select()
    ENDIF

RETURN

/** Selects this radio button, unchecking sibling radio buttons in the same parent. */
METHOD PROCEDURE select() CLASS HTRadioButton

    LOCAL parent
    LOCAL sibling

    IF ::Fchecked
        RETURN
    ENDIF

    parent := ::parent()

    /* uncheck sibling radio buttons in the same parent */
    IF ::FautoExclusive .AND. parent != NIL
        FOR EACH sibling IN parent:children
            IF sibling:isDerivedFrom( "HTRadioButton" ) .AND. ! sibling == self
                sibling:setChecked( .F. )
            ENDIF
        NEXT
    ENDIF

    ::Fchecked := .T.

    IF ::FonToggled != NIL
        Eval( ::FonToggled, ::Fchecked )
    ENDIF
    IF ::FonClicked != NIL
        Eval( ::FonClicked )
    ENDIF

    /* repaint self and siblings (unchecked siblings changed state) */
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        FOR EACH sibling IN parent:children
            IF sibling:isDerivedFrom( "HTRadioButton" )
                parent:repaintChild( sibling )
            ENDIF
        NEXT
    ENDIF

RETURN
