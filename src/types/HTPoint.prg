/*
 *
 */

#define HB_CLS_NOTOBJECT

#include "hbtui.ch"

CLASS HTPoint
PROTECTED:
PUBLIC:
    CONSTRUCTOR new( x, y )
    METHOD isNull INLINE ::Fx = 0 .AND. ::Fy = 0
    METHOD setX( x ) INLINE ::Fx := x
    METHOD setY( y ) INLINE ::Fy := y
    PROPERTY x INIT 0
    PROPERTY y INIT 0
ENDCLASS

/*
    new
*/
METHOD new( x, y ) CLASS HTPoint
    ::Fx := x
    ::Fy := y
RETURN self
