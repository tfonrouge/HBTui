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
    CONSTRUCTOR New()
    PROPERTY MouseAbsRow
    PROPERTY MouseAbsCol
    PROPERTY MouseCol
    PROPERTY MouseRow
ENDCLASS

/*
    New
*/
METHOD New() CLASS HTMouseEvent
    ::FMouseAbsRow := MRow( .T. )
    ::FMouseAbsCol := MCol( .T. )
    ::FMouseRow := MRow()
    ::FMouseCol := MCol()
RETURN Self
