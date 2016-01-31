/*
 *
 */

#include "hbtui.ch"

CLASS HVBoxLayout FROM HBoxLayout
PUBLIC:

    METHOD new( parent ) INLINE ::super:new( 2, parent )

    METHOD addWidget( w ) VIRTUAL

ENDCLASS
