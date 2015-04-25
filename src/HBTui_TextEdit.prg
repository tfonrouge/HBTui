/*
 *
 */

#include "hbtui.ch"

CLASS HTTextEdit FROM HTWidget
PUBLIC:

    CONSTRUCTOR New( parent, text )

    METHOD PaintEvent( event )

    PROPERTY text READWRITE INIT ""

ENDCLASS
