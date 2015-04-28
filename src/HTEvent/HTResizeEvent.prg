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
    CONSTRUCTOR New( size, oldSize )
    PROPERTY oldSize
    PROPERTY size
ENDCLASS

/*
    New
*/
METHOD New( size, oldSize ) CLASS HTResizeEvent
    ::Fsize := size
    ::FoldSize := oldSize
RETURN Self