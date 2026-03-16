/** @class HTHBoxLayout
 * Convenience layout that arranges widgets horizontally (left to right).
 * @extends HTBoxLayout
 */

#include "hbtui.ch"

CLASS HTHBoxLayout FROM HTBoxLayout

PUBLIC:

    METHOD new( parent ) INLINE ::super:new( 0, parent )

ENDCLASS
