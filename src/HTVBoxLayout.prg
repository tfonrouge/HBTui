/*
 *
 */

#include "hbtui.ch"

CLASS HTVBoxLayout FROM HTBoxLayout
PUBLIC:

    METHOD New( parent ) INLINE ::Super:New( 2, parent )

    METHOD addWidget( w ) VIRTUAL

ENDCLASS
