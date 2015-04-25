/*
 *
 */

#include "hbtui.ch"

CLASS HTLayout FROM HTObject, HTLayoutItem
PUBLIC:

    CONSTRUCTOR New( parent )

    METHOD addWidget( w ) VIRTUAL

ENDCLASS

/*
    New
*/
METHOD New( parent ) CLASS HTLayout
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:setLayout( Self )
    ENDIF
RETURN Self
