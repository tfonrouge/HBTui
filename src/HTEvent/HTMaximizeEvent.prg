/*
 *
 */

#include "hbtui.ch"

/*
    HTMaximizeEvent
*/
CLASS HTMaximizeEvent FROM HTEvent
PROTECTED:
    DATA Ftype INIT HT_EVENT_TYPE_MAXIMIZE
PUBLIC:
    CONSTRUCTOR new()
ENDCLASS

/*
    new
*/
METHOD new() CLASS HTMaximizeEvent
RETURN Self