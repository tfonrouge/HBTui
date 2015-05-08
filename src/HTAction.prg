/*
 *
 */

#include "hbtui.ch"

CLASS HTAction FROM HTObject
PROTECTED:
PUBLIC:
    CONSTRUCTOR new( ... )
    METHOD setText( text ) INLINE ::Ftext := text
    PROPERTY text
ENDCLASS

/*
    new
*/
METHOD new( ... ) CLASS HTAction
    SWITCH PCount()
    CASE 1  /* HTObject parent */
        ::Super:new( hb_pValue( 1 ) )
        EXIT
    CASE 2 /* text, HTObject parent */
        ::setText( hb_pValue( 1 ) )
        ::Super:new( hb_pValue( 2 ) )
        EXIT
    OTHERWISE
        ::PARAM_ERROR()
    ENDSWITCH
RETURN Self
