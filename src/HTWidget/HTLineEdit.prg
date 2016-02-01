/*
 *
 */

#include "hbtui.ch"

CLASS HLineEdit FROM HWidget

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD paintEvent( event )

    METHOD setText( text ) INLINE ::Ftext := text

    PROPERTY text INIT ""

ENDCLASS

/*
    new
*/
METHOD new( ... ) CLASS HLineEdit

    LOCAL p

    IF pCount() > 0
        p := hb_pValue( 1 )
        IF hb_isObject( p )
            ::super:new( p )
        ELSE
            ::setText( p ) /* TODO: this could be a HTString object too ... */
            ::super:new( hb_pValue( 2 ) )
        ENDIF
    ELSE
        ::super:new()
    ENDIF

RETURN self

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( event ) CLASS HLineEdit
    HB_SYMBOL_UNUSED( event )
    dispOutAt( ::x, ::y, ::text, ::color )
RETURN
