/*
 *
 */

#include "hbtui.ch"

/*
    HTMouseEvent
*/
CLASS HTMouseEvent FROM HTInputEvent
PROTECTED:
PUBLIC:
    CONSTRUCTOR new()
    PROPERTY button INIT 0
    PROPERTY buttons INIT 0
ENDCLASS

/*
    new
*/
METHOD new() CLASS HTMouseEvent
RETURN ::super:new()