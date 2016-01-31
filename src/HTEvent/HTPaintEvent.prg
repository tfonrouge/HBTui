/*
 *
 */

#include "hbtui.ch"

/*
    HTPaintEvent
*/
CLASS HPaintEvent FROM HEvent
PROTECTED:
    DATA Ftype INIT HT_EVENT_TYPE_PAINT
PUBLIC:
    CONSTRUCTOR new()
ENDCLASS

/*
    new
*/
METHOD new() CLASS HPaintEvent
RETURN self
