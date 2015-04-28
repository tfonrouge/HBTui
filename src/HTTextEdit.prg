/*
 *
 */

#include "hbtui.ch"

CLASS HTTextEdit FROM HTWidget
PUBLIC:

    CONSTRUCTOR New( parent, text )

    METHOD paintEvent( event )

    PROPERTY text READWRITE INIT ""

ENDCLASS
