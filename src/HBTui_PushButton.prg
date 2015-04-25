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
    IF PCount() > 0
        IF PCount() > 1
            ::setText( hb_pValue( 1 ) )
            ::Super( hb_pValue( 2 ) )
        ELSE
            ::Super( hb_pValue( 1 ) )
        ENDIF
    ENDIF
RETURN Self
