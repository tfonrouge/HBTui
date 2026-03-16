/*
 *
 */

#include "hbtui.ch"
#include "inkey.ch"

#define _BTN_COLOR_NORMAL   "00/07"
#define _BTN_COLOR_FOCUSED  "15/01"

CLASS HTPushButton FROM HTAbstractButton

PROTECTED:
PUBLIC:

    METHOD new( ... )
    METHOD paintEvent( paintEvent )
    METHOD keyEvent( keyEvent )

    PROPERTY autoDefault
    PROPERTY default

ENDCLASS

/*
    new
*/
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

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HTPushButton

    LOCAL cDisplay
    LOCAL cColor

    HB_SYMBOL_UNUSED( paintEvent )

    cColor := IIF( ::hasFocus(), _BTN_COLOR_FOCUSED, _BTN_COLOR_NORMAL )
    cDisplay := "[ " + ::Ftext + " ]"

    IF Len( cDisplay ) > MaxCol() + 1
        cDisplay := Left( cDisplay, MaxCol() + 1 )
    ENDIF

    DispOutAt( 0, 0, cDisplay, cColor )

RETURN

/*
    keyEvent
*/
METHOD PROCEDURE keyEvent( keyEvent ) CLASS HTPushButton

    IF keyEvent:key = K_ENTER .OR. keyEvent:key = K_SPACE
        keyEvent:accept()
    ENDIF

RETURN
