/*
 *
 */

#include "hbtui.ch"

/*
    HTResizeEvent
*/
CLASS HTResizeEvent FROM HTEvent

PROTECTED:

    DATA Ftype INIT HT_EVENT_TYPE_RESIZE

PUBLIC:

    CONSTRUCTOR new( size, oldSize )
    PROPERTY oldSize
    PROPERTY size

ENDCLASS

/*
    new
*/
METHOD new( size, oldSize ) CLASS HTResizeEvent
    ::Fsize := size
    ::FoldSize := oldSize
RETURN self
