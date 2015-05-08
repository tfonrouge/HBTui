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
    CONSTRUCTOR new( pos, oldPos )
    PROPERTY oldPos
    PROPERTY pos
ENDCLASS

/*
    new
*/
METHOD new( pos, oldPos ) CLASS HTMoveEvent
    ::Fpos := pos
    ::FoldPos := oldPos
RETURN Self
