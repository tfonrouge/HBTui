/*
 *   31-12-2014
 */

#include "hbtui.ch"

CLASS HTMenu FROM HTWidget
PROTECTED:

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD addAction()
    METHOD addMenu()
    METHOD setTitle( title ) INLINE ::Ftitle := title

    PROPERTY title

ENDCLASS

/*
    new
*/
METHOD new( ... ) CLASS HTMenu
    LOCAL version := 0
    LOCAL parent
    LOCAL title

    IF pCount() <= 1
        parent := hb_pValue( 1 )
        IF hb_isNil( parent ) .OR. hb_isObject( parent )
            version := 1
        ENDIF
    ELSEIF pCount() <= 2
        title := hb_pValue( 1 )
        parent := hb_pValue( 2 )
        IF hb_isChar( title ) .AND. hb_isNil( parent ) .OR. hb_isObject( parent )
            version := 2
        ENDIF
    ENDIF

    SWITCH version
    CASE 1
        ::super:new( parent )
        EXIT
    CASE 2
        ::setTitle( title )
        ::super:new( parent )
        EXIT
    OTHERWISE
        ::PARAM_ERROR()
    ENDSWITCH

RETURN Self

/*
    addAction
*/
METHOD PROCEDURE addAction() CLASS HTMenu

RETURN

/*
    addMenu
*/
METHOD PROCEDURE addMenu() CLASS HTMenu

RETURN
