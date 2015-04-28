/*
 *
 */

#include "hbtui.ch"

CLASS HTLineEdit FROM HTWidget
PUBLIC:

    CONSTRUCTOR New( ... )
    
    METHOD paintEvent( event )

    METHOD setText( text ) INLINE ::Ftext := text

    PROPERTY text INIT ""

ENDCLASS

/*
    New
*/
METHOD New( ... ) CLASS HTLineEdit
    LOCAL p

    IF PCount() > 0
        p := hb_pValue( 1 )
        IF hb_isObject( p )
            ::Super:New( p )
        ELSE
            ::setText( p ) /* TODO: this could be a HTString object too ... */
            ::Super:New( hb_pValue( 2 ) )
        ENDIF
    ELSE
        ::Super:New()
    ENDIF

RETURN Self

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( event ) CLASS HTLineEdit
    HB_SYMBOL_UNUSED( event )
    DispOutAt( ::x, ::y, ::text, ::color )
RETURN
