/*
 *
 */

#include "hbtui.ch"

/*
    HTShowEvent
*/
CLASS HShowEvent FROM HEvent
PROTECTED:
    DATA Ftype INIT HT_EVENT_TYPE_SHOW
PUBLIC:
    CONSTRUCTOR new()
ENDCLASS

/*
    new
*/
METHOD new() CLASS HShowEvent
RETURN self
