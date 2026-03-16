/** @class HTHideEvent
 * Event emitted when a widget is hidden.
 * @extends HTEvent
 */

#include "hbtui.ch"

CLASS HTHideEvent FROM HTEvent

PROTECTED:

    DATA Ftype INIT HT_EVENT_TYPE_HIDE

PUBLIC:

    CONSTRUCTOR new()

ENDCLASS

/** Creates a new hide event. */
METHOD new() CLASS HTHideEvent
RETURN self
