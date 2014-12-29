/*
 *
 */

#include "hbtui.ch"

CLASS HBTui_HBoxLayout FROM HBTui_BoxLayout
PUBLIC:

    METHOD New( parent ) INLINE ::Super:New( 0, parent )

    METHOD addWidget( w ) VIRTUAL

ENDCLASS
