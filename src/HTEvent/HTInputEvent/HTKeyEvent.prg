/*
 *
 */

#include "hbtui.ch"

/*
    HTKeyEvent
*/
CLASS HKeyEvent FROM HInputEvent

PROTECTED:
PUBLIC:

    CONSTRUCTOR new()
    PROPERTY key INIT 0
    PROPERTY text

ENDCLASS

/*
    new
*/
METHOD new() CLASS HKeyEvent
RETURN ::super:new()
