/*
 *
 */

#include "hbtui.ch"

CLASS HBTui_VBoxLayout FROM HBTui_BoxLayout
PUBLIC:

    METHOD New( parent ) INLINE ::Super:New( 2, parent )

    METHOD addWidget( w ) VIRTUAL

ENDCLASS
