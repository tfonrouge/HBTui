/*
 *
 */

#include "hbtui.ch"

CLASS HPushButton FROM HAbstractButton
PROTECTED:
PUBLIC:

    METHOD new( ... )

    PROPERTY autoDefault
    PROPERTY default

ENDCLASS

/*
    new
*/
METHOD new( ... ) CLASS HPushButton
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
