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
    CONSTRUCTOR New( nKey )
    PROPERTY MouseAbsRow
    PROPERTY MouseAbsCol
    PROPERTY mouseCol
    PROPERTY mouseRow
    PROPERTY nKey
ENDCLASS

/*
    New
*/
METHOD New( nKey ) CLASS HTMouseEvent
    ::FnKey := nKey
    ::FMouseAbsCol := mCol( .T. )
    ::FMouseAbsRow := mRow( .T. )
    ::FmouseCol := mCol()
    ::FmouseRow := mRow()
RETURN Self
