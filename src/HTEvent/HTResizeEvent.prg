/*
 *
 */

#include "hbtui.ch"

/*
    HTResizeEvent
*/
CLASS HResizeEvent FROM HEvent
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
METHOD new( size, oldSize ) CLASS HResizeEvent
    ::Fsize := size
    ::FoldSize := oldSize
RETURN self
