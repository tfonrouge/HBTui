/*
 *
 */

#include "hbtui.ch"

/*
    HTCloseEvent
*/
CLASS HCloseEvent FROM HEvent

PROTECTED:

    DATA Ftype INIT HT_EVENT_TYPE_CLOSE

PUBLIC:

    CONSTRUCTOR new()
    
ENDCLASS

/*
    new
*/
METHOD new() CLASS HCloseEvent
RETURN self
