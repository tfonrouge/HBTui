/** @class HTMouseEvent
 * Mouse input event carrying cursor coordinates and button key code.
 * @extends HTInputEvent
 */

#include "hbtui.ch"

CLASS HTMouseEvent FROM HTInputEvent
PROTECTED:
    DATA Ftype INIT HT_EVENT_TYPE_MOUSE
PUBLIC:
    CONSTRUCTOR new( nKey )
    PROPERTY mouseAbsRow
    PROPERTY mouseAbsCol
    PROPERTY mouseCol
    PROPERTY mouseRow
    PROPERTY nKey
ENDCLASS

/** Creates a new mouse event, capturing current cursor coordinates.
 * @param nKey Inkey mouse key code
 */
METHOD new( nKey ) CLASS HTMouseEvent
    ::FnKey := nKey
    ::FmouseAbsCol := mCol( .t. )
    ::FmouseAbsRow := mRow( .t. )
    ::FmouseCol := mCol()
    ::FmouseRow := mRow()
RETURN self
