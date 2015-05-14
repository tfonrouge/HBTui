/*
 *
 */

#include "hbtui.ch"

/*
    HTHideEvent
*/
CLASS HTHideEvent FROM HTEvent
PROTECTED:
    DATA Ftype INIT HT_EVENT_TYPE_HIDE
PUBLIC:
    CONSTRUCTOR new()
ENDCLASS

/*
    new
*/
METHOD new() CLASS HTHideEvent
RETURN self