/*
 *
 */

#include "hbtui.ch"

CLASS HTEvent FROM HTBase
PUBLIC:
    CONSTRUCTOR New( nKey )

    PROPERTY IsAccepted INIT .T.
    PROPERTY nKey
    PROPERTY EventType INIT HBTUI_UI_EVENT_TYPE_NULL
    PROPERTY hbtObject READWRITE

ENDCLASS

/*
  New
*/
METHOD New( nKey ) CLASS HTEvent
    ::FnKey := nKey
RETURN Self

/*
  HTEventClose
*/
CLASS HTEventClose FROM HTEvent
PUBLIC:
    PROPERTY EventType INIT HBTUI_UI_EVENT_TYPE_CLOSE
ENDCLASS

/*
  HTEventFocus
*/
CLASS HTEventFocus FROM HTEvent
PROTECTED:
PUBLIC:
    PROPERTY EventType VALUE HBTUI_UI_EVENT_TYPE_FOCUS
ENDCLASS

/*
  HTEventKey
*/
CLASS HTEventKey FROM HTEvent
PROTECTED:
PUBLIC:
    PROPERTY EventType VALUE HBTUI_UI_EVENT_TYPE_KEYBOARD
ENDCLASS

/*
  HTEventMouse
*/
CLASS HTEventMouse FROM HTEvent
PROTECTED:
PUBLIC:
    CONSTRUCTOR New( nKey )
    PROPERTY EventType VALUE HBTUI_UI_EVENT_TYPE_MOUSE
    PROPERTY MouseAbsRow
    PROPERTY MouseAbsCol
    PROPERTY MouseCol
    PROPERTY MouseRow
ENDCLASS

/*
    New
*/
METHOD New( nKey ) CLASS HTEventMouse
    ::Super:New( nKey )
    ::FMouseAbsRow := MRow( .T. )
    ::FMouseAbsCol := MCol( .T. )
    ::FMouseRow := MRow()
    ::FMouseCol := MCol()
RETURN Self

/*
  HTEventMove
*/
CLASS HTEventMove FROM HTEvent
PROTECTED:
PUBLIC:
    CONSTRUCTOR New( nKey )
    PROPERTY EventType VALUE HBTUI_UI_EVENT_TYPE_MOVE
    PROPERTY MouseAbsRow
    PROPERTY MouseAbsCol
    PROPERTY MouseCol
    PROPERTY MouseRow
ENDCLASS

/*
    New
*/
METHOD New( nKey ) CLASS HTEventMove
    ::Super:New( nKey )
    ::FMouseAbsRow := MRow( .T. )
    ::FMouseAbsCol := MCol( .T. )
    ::FMouseRow := MRow()
    ::FMouseCol := MCol()
RETURN Self

/*
  HTEventPaint
*/
CLASS HTEventPaint FROM HTEvent
PROTECTED:
PUBLIC:
    PROPERTY EventType VALUE HBTUI_UI_EVENT_TYPE_PAINT
ENDCLASS
