/** @class HTInputEvent
 * Base class for user input events (keyboard and mouse).
 * @extends HTEvent
 */

#include "hbtui.ch"

CLASS HTInputEvent FROM HTEvent

PROTECTED:

    DATA Ftype INIT HT_EVENT_TYPE_NULL

PUBLIC:

    CONSTRUCTOR new()
    PROPERTY modifiers INIT 0x00000000
    PROPERTY timestamp

ENDCLASS

/** Creates a new input event with the current timestamp. */
METHOD new() CLASS HTInputEvent
    ::Ftimestamp := hb_dateTime()
RETURN self
