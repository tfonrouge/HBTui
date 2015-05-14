/*
 *
 */

#include "hbtui.ch"

CLASS HTLayout FROM HTObject, HTLayoutItem
PUBLIC:

    CONSTRUCTOR new( parent )

    METHOD addWidget( w ) VIRTUAL

ENDCLASS

/*
    new
*/
METHOD new( parent ) CLASS HTLayout
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:setLayout( self )
    ENDIF
RETURN self
