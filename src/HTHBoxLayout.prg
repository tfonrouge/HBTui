/*
 *
 */

#include "hbtui.ch"

CLASS HTBoxLayout FROM HTBoxLayout

PUBLIC:

    METHOD new( parent ) INLINE ::super:new( 0, parent )

    METHOD addWidget( w ) VIRTUAL

ENDCLASS
