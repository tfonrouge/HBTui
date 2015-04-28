/*
 *
 */

#define HB_CLS_NOTOBJECT

#include "hbtui.ch"

CREATE CLASS HTSize
PROTECTED:
PUBLIC:
    CONSTRUCTOR New( width, height )
    METHOD isNull() INLINE ::Fwidth = 0 .AND. ::Fheight = 0
    METHOD setHeight( height ) INLINE ::Fheight := height
    METHOD setWidth( width ) INLINE ::Fwidth := width
    PROPERTY height
    PROPERTY width
ENDCLASS

/*
    New
*/
METHOD New( width, height ) CLASS HTSize
    ::Fwidth := width
    ::Fheight := height
RETURN Self
