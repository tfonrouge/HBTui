/** @class HTPaintEvent
 * Event emitted when a widget needs to repaint itself.
 * @extends HTEvent
 */

#include "hbtui.ch"

CLASS HTPaintEvent FROM HTEvent

PROTECTED:

    DATA Ftype INIT HT_EVENT_TYPE_PAINT

PUBLIC:

    CONSTRUCTOR new()

ENDCLASS

/** Creates a new paint event. */
METHOD new() CLASS HTPaintEvent
RETURN self
