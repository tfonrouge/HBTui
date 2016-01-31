/*
 *
 */

#include "hbtui.ch"

/*
  HTMoveEvent
*/
CLASS HMoveEvent FROM HEvent
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
METHOD new( pos, oldPos ) CLASS HMoveEvent
    ::Fpos := pos
    ::FoldPos := oldPos
RETURN self
