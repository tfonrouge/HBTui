/*
 *
 */

#include "hbtui.ch"

CLASS HTPushButton FROM HTAbstractButton
PROTECTED:
PUBLIC:

    METHOD new( ... )

    PROPERTY autoDefault
    PROPERTY default

ENDCLASS

/*
    new
*/
METHOD new( ... ) CLASS HTPushButton
    LOCAL p

    IF PCount() > 0
        p := hb_pValue( 1 )
        IF hb_isObject( p )
            ::Super:new( p )
        ELSE
            ::setText( p )
            ::Super:new( hb_pValue( 2 ) )
        ENDIF
    ELSE
        ::Super:new()
    ENDIF

RETURN Self
