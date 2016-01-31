/*
 *
 */

#include "hbtui.ch"

/*
    HTMaximizeEvent
*/
CLASS HMaximizeEvent FROM HEvent
PROTECTED:
    DATA Ftype INIT HT_EVENT_TYPE_MAXIMIZE
PUBLIC:
    CONSTRUCTOR new()
ENDCLASS

/*
    new
*/
METHOD new() CLASS HMaximizeEvent
RETURN self
