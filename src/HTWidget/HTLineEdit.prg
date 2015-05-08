/*
 *
 */

#include "hbtui.ch"

CLASS HTLineEdit FROM HTWidget
PUBLIC:

    CONSTRUCTOR new( ... )
    
    METHOD paintEvent( event )

    METHOD setText( text ) INLINE ::Ftext := text

    PROPERTY text INIT ""

ENDCLASS

/*
    new
*/
METHOD new( ... ) CLASS HTLineEdit
    LOCAL p

    IF PCount() > 0
        p := hb_pValue( 1 )
        IF hb_isObject( p )
            ::Super:new( p )
        ELSE
            ::setText( p ) /* TODO: this could be a HTString object too ... */
            ::Super:new( hb_pValue( 2 ) )
        ENDIF
    ELSE
        ::Super:new()
    ENDIF

RETURN Self

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( event ) CLASS HTLineEdit
    HB_SYMBOL_UNUSED( event )
    DispOutAt( ::x, ::y, ::text, ::color )
RETURN
