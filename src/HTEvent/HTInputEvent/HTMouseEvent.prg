/*
 *
 */

#include "hbtui.ch"

/*
    HTMouseEvent
*/
CLASS HMouseEvent FROM HInputEvent
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

/*
    new
*/
METHOD new( nKey ) CLASS HMouseEvent
    ::FnKey := nKey
    ::FmouseAbsCol := mCol( .t. )
    ::FmouseAbsRow := mRow( .t. )
    ::FmouseCol := mCol()
    ::FmouseRow := mRow()
RETURN self
