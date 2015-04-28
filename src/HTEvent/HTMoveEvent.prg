/*
 *
 */

#include "hbtui.ch"

/*
  HTMoveEvent
*/
CLASS HTMoveEvent FROM HTEvent
PROTECTED:
    DATA Ftype INIT HT_EVENT_TYPE_MOVE
PUBLIC:
    CONSTRUCTOR New( pos, oldPos )
    PROPERTY oldPos
    PROPERTY pos
ENDCLASS

/*
    New
*/
METHOD New( pos, oldPos ) CLASS HTMoveEvent
    ::Fpos := pos
    ::FoldPos := oldPos
RETURN Self
