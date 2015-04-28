/*
 *
 */

#include "hbtui.ch"

CLASS HTPushButton FROM HTAbstractButton
PROTECTED:
PUBLIC:

    METHOD New( ... )

    PROPERTY autoDefault
    PROPERTY default

ENDCLASS

/*
    New
*/
METHOD New( ... ) CLASS HTPushButton
    LOCAL p

    IF PCount() > 0
        p := hb_pValue( 1 )
        IF hb_isObject( p )
            ::Super:New( p )
        ELSE
            ::setText( p )
            ::Super:New( hb_pValue( 2 ) )
        ENDIF
    ELSE
        ::Super:New()
    ENDIF

RETURN Self
