/** @class HTResizeEvent
 * Event emitted when a widget is resized, carrying old and new sizes.
 * @extends HTEvent
 */

#include "hbtui.ch"

CLASS HTResizeEvent FROM HTEvent

PROTECTED:

    DATA Ftype INIT HT_EVENT_TYPE_RESIZE

PUBLIC:

    CONSTRUCTOR new( size, oldSize )
    PROPERTY oldSize
    PROPERTY size

ENDCLASS

/** Creates a new resize event.
 * @param size New size as HTSize
 * @param oldSize Previous size as HTSize
 */
METHOD new( size, oldSize ) CLASS HTResizeEvent
    ::Fsize := size
    ::FoldSize := oldSize
RETURN self
