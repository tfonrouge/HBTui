/*
 *
 */

#include "hbtui.ch"

/*
    HTCloseEvent
*/
CLASS HTCloseEvent FROM HTEvent

PROTECTED:

    DATA Ftype INIT HT_EVENT_TYPE_CLOSE

PUBLIC:

    CONSTRUCTOR new()
    
ENDCLASS

/*
    new
*/
METHOD new() CLASS HTCloseEvent
RETURN self
