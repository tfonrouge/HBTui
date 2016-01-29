/*
 *
 */

#define HB_CLS_NOTOBJECT

#include "hbtui.ch"

CLASS HTPoint

PROTECTED:
PUBLIC:

    CONSTRUCTOR New( y, x )
    METHOD isNull INLINE ::Fy = 0 .AND. ::Fx = 0
    METHOD y()       INLINE ::y
    METHOD x()       INLINE ::x
    METHOD setY( y ) INLINE ::Fy := y
    METHOD setX( x ) INLINE ::Fx := x

    PROPERTY y INIT 0
    PROPERTY x INIT 0

ENDCLASS

/*
   New
*/
METHOD New( y, x ) CLASS HTPoint

    ::Fy := y
    ::Fx := x

RETURN ( Self )
