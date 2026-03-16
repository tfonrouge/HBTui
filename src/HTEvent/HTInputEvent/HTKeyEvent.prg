/*
 *
 */

#include "hbtui.ch"

/*
    HTKeyEvent
*/
CLASS HTKeyEvent FROM HTInputEvent

PROTECTED:

    DATA Ftype INIT HT_EVENT_TYPE_KEYBOARD

PUBLIC:

    CONSTRUCTOR new( nKey )
    PROPERTY key INIT 0
    PROPERTY text

ENDCLASS

/*
    new
*/
METHOD new( nKey ) CLASS HTKeyEvent
    ::Fkey := nKey
    ::Ftext := hb_keyChar( nKey )
RETURN ::super:new()
