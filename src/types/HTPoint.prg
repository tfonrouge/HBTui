/** @class HTPoint
 * Immutable 2D point value type with x and y coordinates.
 */

#define HB_CLS_NOTOBJECT

#include "hbtui.ch"

CLASS HTPoint

PROTECTED:

PUBLIC:

    CONSTRUCTOR new( x, y )

    METHOD IsNull    INLINE ::Fx = 0 .AND. ::Fy = 0
    METHOD setX( x ) INLINE ::Fx := x
    METHOD setY( y ) INLINE ::Fy := y

    PROPERTY x INIT 0
    PROPERTY y INIT 0

ENDCLASS

/** Creates a new point.
 * @param x X coordinate (column)
 * @param y Y coordinate (row)
 */
METHOD new( x, y ) CLASS HTPoint

    ::Fx := x
    ::Fy := y

RETURN self
