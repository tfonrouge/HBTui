/*
 *
 */

#include "hbtui.ch"

CLASS HBTui_Layout FROM HBTui_Object, HBTui_LayoutItem
PUBLIC:

    CONSTRUCTOR New( parent )

    METHOD addWidget( w ) VIRTUAL

ENDCLASS

/*
    New
*/
METHOD New( parent ) CLASS HBTui_Layout
    IF parent != NIL .AND. parent:isDerivedFrom( "HBTui_Widget" )
        parent:setLayout( Self )
    ENDIF
RETURN Self
