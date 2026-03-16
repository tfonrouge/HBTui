/*
 *
 */

#include "hbtui.ch"
#include "inkey.ch"

#define _CHK_COLOR_NORMAL   "00/07"
#define _CHK_COLOR_FOCUSED  "15/01"

CLASS HTCheckBox FROM HTAbstractButton

PROTECTED:
PUBLIC:

    METHOD new( ... )
    METHOD paintEvent( paintEvent )
    METHOD keyEvent( keyEvent )
    METHOD mouseEvent( eventMouse )
    METHOD toggle()

ENDCLASS

/*
    new
*/
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

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HTCheckBox

    LOCAL cMark
    LOCAL cDisplay
    LOCAL cColor

    HB_SYMBOL_UNUSED( paintEvent )

    cMark := IIF( ::Fchecked, e"\xFB", " " )
    cDisplay := "[" + cMark + "] " + ::Ftext
    cColor := IIF( ::hasFocus(), _CHK_COLOR_FOCUSED, _CHK_COLOR_NORMAL )

    IF Len( cDisplay ) > MaxCol() + 1
        cDisplay := Left( cDisplay, MaxCol() + 1 )
    ENDIF

    DispOutAt( 0, 0, cDisplay, cColor )

RETURN

/*
    keyEvent
*/
METHOD PROCEDURE keyEvent( keyEvent ) CLASS HTCheckBox

    IF keyEvent:key = K_SPACE
        ::toggle()
        keyEvent:accept()
    ENDIF

RETURN

/*
    mouseEvent
*/
METHOD PROCEDURE mouseEvent( eventMouse ) CLASS HTCheckBox

    IF eventMouse:nKey = K_LBUTTONDOWN
        ::toggle()
    ENDIF

RETURN

/*
    toggle
*/
METHOD PROCEDURE toggle() CLASS HTCheckBox

    LOCAL parent

    ::Fchecked := ! ::Fchecked

    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:repaint()
    ENDIF

RETURN
