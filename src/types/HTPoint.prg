/*
 *
 */

#define HB_CLS_NOTOBJECT

#include "hbtui.ch"

CLASS HPoint

PROTECTED:
PUBLIC:

    CONSTRUCTOR New( y, x )
    METHOD IsNull    INLINE ::Fy = 0 .AND. ::Fx = 0
    METHOD setY( y ) INLINE ::Fy := y
    METHOD setX( x ) INLINE ::Fx := x

    PROPERTY y INIT 0
    PROPERTY x INIT 0

ENDCLASS

/*
   New
*/
METHOD New( y, x ) CLASS HPoint

    ::Fy := y
    ::Fx := x

RETURN ( Self )
