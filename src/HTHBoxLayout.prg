/*
 *
 */

#include "hbtui.ch"

CLASS HTHBoxLayout FROM HTBoxLayout
PUBLIC:

    METHOD new( parent ) INLINE ::super:new( 0, parent )

    METHOD addWidget( w ) VIRTUAL

ENDCLASS
