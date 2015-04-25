/*
 *
 */

#include "hbtui.ch"

CLASS HTHBoxLayout FROM HTBoxLayout
PUBLIC:

    METHOD New( parent ) INLINE ::Super:New( 0, parent )

    METHOD addWidget( w ) VIRTUAL

ENDCLASS
