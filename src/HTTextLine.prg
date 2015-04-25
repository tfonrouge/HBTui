/*
 *
 */

#include "hbtui.ch"

CLASS HTTextLine FROM HTWidget
PUBLIC:

    CONSTRUCTOR New( parent, text )
    
    METHOD PaintEvent( event )

    PROPERTY text READWRITE INIT ""

ENDCLASS

/*
    New
*/
METHOD New( parent, text ) CLASS HTTextLine
    ::Super:SetParent( parent )
    IF text != NIL
        ::text := text
    ENDIF
RETURN Self

/*
    PaintEvent
*/
METHOD PROCEDURE PaintEvent( event ) CLASS HTTextLine
    HB_SYMBOL_UNUSED( event )
    DevPos( ::x, ::y )
    DevOut( ::text )
RETURN
