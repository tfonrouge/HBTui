/*
 *
 */

#include "hbtui.ch"

/*
    HTKeyEvent
*/
CLASS HTKeyEvent FROM HTInputEvent

PROTECTED:
PUBLIC:

    CONSTRUCTOR new()
    PROPERTY key INIT 0
    PROPERTY text

ENDCLASS

/*
    new
*/
METHOD new() CLASS HTKeyEvent
RETURN ::super:new()
