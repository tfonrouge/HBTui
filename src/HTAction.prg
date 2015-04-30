/*
 *
 */

#include "hbtui.ch"

CLASS HTAction FROM HTObject
PROTECTED:
PUBLIC:
    CONSTRUCTOR New( ... )
    METHOD setText( text ) INLINE ::Ftext := text
    PROPERTY text
ENDCLASS

/*
    New
*/
METHOD New( ... ) CLASS HTAction
    SWITCH PCount()
    CASE 1  /* HTObject parent */
        ::Super:New( hb_pValue( 1 ) )
        EXIT
    CASE 2 /* text, HTObject parent */
        ::setText( hb_pValue( 1 ) )
        ::Super:New( hb_pValue( 2 ) )
        EXIT
    OTHERWISE
        ::PARAM_ERROR()
    ENDSWITCH
RETURN Self
