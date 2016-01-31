/*
 *
 */

#include "hbtui.ch"

CLASS HHBoxLayout FROM HBoxLayout
PUBLIC:

    METHOD new( parent ) INLINE ::super:new( 0, parent )

    METHOD addWidget( w ) VIRTUAL

ENDCLASS
