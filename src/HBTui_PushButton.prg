/*
 *
 */

#include "hbtui.ch"

CLASS HBTui_PushButton FROM HBTui_AbstractButton
PROTECTED:
PUBLIC:

    METHOD New( ... )

    PROPERTY autoDefault
    PROPERTY default

ENDCLASS

/*
    New
*/
METHOD New( ... ) CLASS HBTui_PushButton
    IF PCount() > 0
        IF PCount() > 1
            ::setText( hb_pValue( 1 ) )
            ::Super( hb_pValue( 2 ) )
        ELSE
            ::Super( hb_pValue( 1 ) )
        ENDIF
    ENDIF
RETURN Self
