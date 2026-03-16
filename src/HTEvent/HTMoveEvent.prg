/** @class HTMoveEvent
 * Event emitted when a widget is moved, carrying old and new positions.
 * @extends HTEvent
 */

#include "hbtui.ch"

CLASS HTMoveEvent FROM HTEvent

PROTECTED:

    DATA Ftype INIT HT_EVENT_TYPE_MOVE

PUBLIC:

    CONSTRUCTOR new( pos, oldPos )
    PROPERTY oldPos
    PROPERTY pos

ENDCLASS

/** Creates a new move event.
 * @param pos New position as HTPoint
 * @param oldPos Previous position as HTPoint
 */
METHOD new( pos, oldPos ) CLASS HTMoveEvent
    ::Fpos := pos
    ::FoldPos := oldPos
RETURN self
