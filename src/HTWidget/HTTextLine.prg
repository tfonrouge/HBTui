/*
 *
 */

#include "hbtui.ch"

CLASS HTTextLine FROM HTWidget
PUBLIC:

    CONSTRUCTOR New( parent, text )
    
    METHOD paintEvent( event )

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
    paintEvent
*/
METHOD PROCEDURE paintEvent( event ) CLASS HTTextLine
    HB_SYMBOL_UNUSED( event )
    DispOutAt( ::x, ::y, ::text, ::color )
RETURN
