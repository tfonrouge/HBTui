/** @class HTCloseEvent
 * Event emitted when a window is requested to close.
 * @extends HTEvent
 */

#include "hbtui.ch"

CLASS HTCloseEvent FROM HTEvent

PROTECTED:

    DATA Ftype INIT HT_EVENT_TYPE_CLOSE

PUBLIC:

    CONSTRUCTOR new()
    
ENDCLASS

/** Creates a new close event. */
METHOD new() CLASS HTCloseEvent
RETURN self
