/*
 *
 */

#include "hbtui.ch"

CLASS HBTui_TextLine FROM HBTui_Widget
PUBLIC:

    CONSTRUCTOR New( parent, text )
    
    METHOD PaintEvent( event )

    PROPERTY text READWRITE INIT ""

ENDCLASS

/*
    New
*/
METHOD New( parent, text ) CLASS HBTui_TextLine
    ::Super:SetParent( parent )
    IF text != NIL
        ::text := text
    ENDIF
RETURN Self

/*
    PaintEvent
*/
METHOD PROCEDURE PaintEvent( event ) CLASS HBTui_TextLine
    HB_SYMBOL_UNUSED( event )
    DevPos( ::x, ::y )
    DevOut( ::text )
RETURN
