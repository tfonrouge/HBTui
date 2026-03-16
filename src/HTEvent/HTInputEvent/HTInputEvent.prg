/*
 *
 */

#include "hbtui.ch"

/*
    HTInputEvent
*/
CLASS HTInputEvent FROM HTEvent

PROTECTED:

    DATA Ftype INIT HT_EVENT_TYPE_NULL

PUBLIC:

    CONSTRUCTOR new()
    PROPERTY modifiers INIT 0x00000000
    PROPERTY timestamp

ENDCLASS

/*
    new
*/
METHOD new() CLASS HTInputEvent
    ::Ftimestamp := hb_dateTime()
RETURN self
