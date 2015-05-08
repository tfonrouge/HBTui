/*
 *
 */

#include "hbtui.ch"

CLASS HTVBoxLayout FROM HTBoxLayout
PUBLIC:

    METHOD new( parent ) INLINE ::Super:new( 2, parent )

    METHOD addWidget( w ) VIRTUAL

ENDCLASS
