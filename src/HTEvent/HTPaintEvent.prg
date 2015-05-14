/*
 *
 */

#include "hbtui.ch"

/*
    HTPaintEvent
*/
CLASS HTPaintEvent FROM HTEvent
PROTECTED:
    DATA Ftype INIT HT_EVENT_TYPE_PAINT
PUBLIC:
    CONSTRUCTOR new()
ENDCLASS

/*
    new
*/
METHOD new() CLASS HTPaintEvent
RETURN self