/*
 *   31-12-2014
 */

#include "hbtui.ch"
#include "inkey.ch"

CLASS HTMenuBar FROM HTWidget
PROTECTED:

PUBLIC:

    CONSTRUCTOR new( parent )

    METHOD addAction( ... )
    METHOD addMenu( ... )
    METHOD addSeparator()

ENDCLASS

/*
    new
*/
METHOD new( parent ) CLASS HTMenuBar
    LOCAL version := 0

    IF pCount() <= 1
        IF hb_isNil( parent ) .OR. hb_isObject( parent )
            version := 1
        ENDIF
    ENDIF

    SWITCH version
    CASE 1
        ::super:new( parent )
        EXIT
    OTHERWISE
        ::PARAM_ERROR()
    ENDSWITCH

RETURN Self

/*
    addAction
*/
METHOD addAction( ... ) CLASS HTMenuBar
    LOCAL action
    LOCAL p

    SWITCH pCount()
    CASE 1
        p := hb_pValue( 1 )
        IF hb_isChar( p )
            action := HTAction():new( p, Self )
            aAdd( ::Factions, action )
        ELSEIF hb_isObject( p )
            aAdd( ::Factions, p )
        ELSE
            ::PARAM_ERROR()
        ENDIF
        EXIT
    CASE 3
        EXIT
    OTHERWISE
        ::PARAM_ERROR()
    ENDSWITCH

RETURN Self

/*
    addMenu
*/
METHOD addMenu( ... ) CLASS HTMenuBar

RETURN Self

/*
    addSeparator
*/
METHOD addSeparator() CLASS HTMenuBar

RETURN Self
