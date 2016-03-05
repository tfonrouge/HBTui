/*
 *
 */

#include "hbtui.ch"

CLASS HLayout FROM HObject, HLayoutItem

PUBLIC:

    CONSTRUCTOR new( parent )

    METHOD addWidget( w ) VIRTUAL

ENDCLASS

/*
    new
*/
METHOD new( parent ) CLASS HLayout
    IF parent != NIL .AND. parent:isDerivedFrom( "HWidget" )
        parent:setLayout( self )
    ENDIF
RETURN self
