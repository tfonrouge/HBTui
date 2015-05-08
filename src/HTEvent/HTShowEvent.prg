/*
 *
 */

#include "hbtui.ch"

/*
    HTShowEvent
*/
CLASS HTShowEvent FROM HTEvent
PROTECTED:
    DATA Ftype INIT HT_EVENT_TYPE_SHOW
PUBLIC:
    CONSTRUCTOR new()
ENDCLASS

/*
    new
*/
METHOD new() CLASS HTShowEvent
RETURN Self