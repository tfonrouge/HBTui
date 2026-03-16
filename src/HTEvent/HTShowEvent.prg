/** @class HTShowEvent
 * Event emitted when a widget becomes visible.
 * @extends HTEvent
 */

#include "hbtui.ch"

CLASS HTShowEvent FROM HTEvent
PROTECTED:
    DATA Ftype INIT HT_EVENT_TYPE_SHOW
PUBLIC:
    CONSTRUCTOR new()
ENDCLASS

/** Creates a new show event. */
METHOD new() CLASS HTShowEvent
RETURN self
