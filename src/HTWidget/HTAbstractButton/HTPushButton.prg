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

RETURN self
