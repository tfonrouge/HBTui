/*
 *
 */

#include "hbtui.ch"

/*
    HTInputEvent
*/
CLASS HInputEvent FROM HEvent

PROTECTED:

    DATA Ftype INIT HT_EVENT_TYPE_CLOSE

PUBLIC:

    CONSTRUCTOR new()
    PROPERTY modifiers INIT 0x00000000
    PROPERTY timestamp

ENDCLASS

/*
    new
*/
METHOD new() CLASS HInputEvent
    ::Ftimestamp := hb_dateTime()
RETURN self
