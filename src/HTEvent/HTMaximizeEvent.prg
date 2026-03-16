/** @class HTMaximizeEvent
 * Event emitted when a window is maximized.
 * @extends HTEvent
 */

#include "hbtui.ch"

CLASS HTMaximizeEvent FROM HTEvent

PROTECTED:

    DATA Ftype INIT HT_EVENT_TYPE_MAXIMIZE

PUBLIC:

    CONSTRUCTOR new()

ENDCLASS

/** Creates a new maximize event. */
METHOD new() CLASS HTMaximizeEvent
RETURN self
