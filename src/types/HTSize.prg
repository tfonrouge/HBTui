/*
 *
 */

#define HB_CLS_NOTOBJECT

#include "hbtui.ch"

CLASS HSize

PROTECTED:
PUBLIC:

    CONSTRUCTOR new( width, height )

    METHOD isNull() INLINE ::Fwidth = 0 .AND. ::Fheight = 0
    METHOD setHeight( height ) INLINE ::Fheight := height
    METHOD setWidth( width ) INLINE ::Fwidth := width

    PROPERTY height
    PROPERTY width

ENDCLASS

/*
    new
*/
METHOD new( width, height ) CLASS HSize

    ::Fwidth := width
    ::Fheight := height

RETURN self
