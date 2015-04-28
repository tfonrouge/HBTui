/*
 *
 */

#define HB_CLS_NOTOBJECT

#include "hbtui.ch"

CREATE CLASS HTPoint
PROTECTED:
PUBLIC:
    CONSTRUCTOR New( x, y )
    METHOD isNull INLINE ::Fx = 0 .AND. ::Fy = 0
    METHOD setX( x ) INLINE ::Fx := x
    METHOD setY( y ) INLINE ::Fy := y
    PROPERTY x INIT 0
    PROPERTY y INIT 0
ENDCLASS

/*
    New
*/
METHOD New( x, y ) CLASS HTPoint
    ::Fx := x
    ::Fy := y
RETURN Self
