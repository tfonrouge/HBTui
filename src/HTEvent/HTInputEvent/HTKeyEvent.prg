/** @class HTKeyEvent
 * Keyboard input event carrying key code and character text.
 * @extends HTInputEvent
 */

#include "hbtui.ch"

CLASS HTKeyEvent FROM HTInputEvent

PROTECTED:

    DATA Ftype INIT HT_EVENT_TYPE_KEYBOARD

PUBLIC:

    CONSTRUCTOR new( nKey )
    PROPERTY key INIT 0
    PROPERTY text

ENDCLASS

/** Creates a new key event.
 * @param nKey Inkey key code
 */
METHOD new( nKey ) CLASS HTKeyEvent
    ::Fkey := nKey
    ::Ftext := hb_keyChar( nKey )
RETURN ::super:new()
