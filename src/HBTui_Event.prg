/*
 *
 */

#include "hbtui.ch"

CLASS HBTui_Event FROM HBTui_Base
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
METHOD New( nKey ) CLASS HBTui_Event
    ::FnKey := nKey
RETURN Self

/*
  HBTui_EventClose
*/
CLASS HBTui_EventClose FROM HBTui_Event
PUBLIC:
    PROPERTY EventType INIT HBTUI_UI_EVENT_TYPE_CLOSE
ENDCLASS

/*
  HBTui_EventFocus
*/
CLASS HBTui_EventFocus FROM HBTui_Event
PROTECTED:
PUBLIC:
    PROPERTY EventType VALUE HBTUI_UI_EVENT_TYPE_FOCUS
ENDCLASS

/*
  HBTui_EventKey
*/
CLASS HBTui_EventKey FROM HBTui_Event
PROTECTED:
PUBLIC:
    PROPERTY EventType VALUE HBTUI_UI_EVENT_TYPE_KEYBOARD
ENDCLASS

/*
  HBTui_EventMouse
*/
CLASS HBTui_EventMouse FROM HBTui_Event
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
METHOD New( nKey ) CLASS HBTui_EventMouse
    ::Super:New( nKey )
    ::FMouseAbsRow := MRow( .T. )
    ::FMouseAbsCol := MCol( .T. )
    ::FMouseRow := MRow()
    ::FMouseCol := MCol()
RETURN Self

/*
  HBTui_EventMove
*/
CLASS HBTui_EventMove FROM HBTui_Event
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
METHOD New( nKey ) CLASS HBTui_EventMove
    ::Super:New( nKey )
    ::FMouseAbsRow := MRow( .T. )
    ::FMouseAbsCol := MCol( .T. )
    ::FMouseRow := MRow()
    ::FMouseCol := MCol()
RETURN Self

/*
  HBTui_EventPaint
*/
CLASS HBTui_EventPaint FROM HBTui_Event
PROTECTED:
PUBLIC:
    PROPERTY EventType VALUE HBTUI_UI_EVENT_TYPE_PAINT
ENDCLASS
