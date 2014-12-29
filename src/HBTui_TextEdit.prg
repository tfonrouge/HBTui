/*
 *
 */

#include "hbtui.ch"

CLASS HBTui_TextEdit FROM HBTui_Widget
PUBLIC:

    CONSTRUCTOR New( parent, text )

    METHOD PaintEvent( event )

    PROPERTY text READWRITE INIT ""

ENDCLASS
