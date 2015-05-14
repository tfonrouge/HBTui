/*
 *
 */

#include "hbtui.ch"

/*
    HTMouseEvent
*/
CLASS HTMouseEvent FROM HTEvent
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
METHOD new( nKey ) CLASS HTMouseEvent
    ::FnKey := nKey
    ::FmouseAbsCol := mCol( .t. )
    ::FmouseAbsRow := mRow( .t. )
    ::FmouseCol := mCol()
    ::FmouseRow := mRow()
RETURN self
