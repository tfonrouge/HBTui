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
    PROPERTY MouseCol
    PROPERTY MouseRow
    PROPERTY nKey
ENDCLASS

/*
    New
*/
METHOD New( nKey ) CLASS HTMouseEvent
    ::FnKey := nKey
    ::FMouseAbsRow := MRow( .T. )
    ::FMouseAbsCol := MCol( .T. )
    ::FMouseRow := MRow()
    ::FMouseCol := MCol()
RETURN Self
