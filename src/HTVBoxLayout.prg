/** @class HTVBoxLayout
 * Convenience layout that arranges widgets vertically (top to bottom).
 * @extends HTBoxLayout
 */

#include "hbtui.ch"

CLASS HTVBoxLayout FROM HTBoxLayout

PUBLIC:

    METHOD new( parent ) INLINE ::super:new( 2, parent )

    METHOD addWidget( w ) VIRTUAL

ENDCLASS
