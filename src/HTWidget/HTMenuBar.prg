/*
 *   31-12-2014
 */

#include "hbtui.ch"
#include "inkey.ch"

CLASS HTMenuBar FROM HTWidget
PROTECTED:

PUBLIC:

    CONSTRUCTOR New( parent )

    METHOD addAction( ... )
    METHOD AddMenu( ... )
    METHOD PositionMenu()

ENDCLASS

/*
    New
*/
METHOD New( parent ) CLASS HTMenuBar
RETURN ::Super:New( parent )

/*
    addAction
*/
METHOD addAction( ... ) CLASS HTMenuBar
    LOCAL action
    LOCAL p

    SWITCH PCount()
    CASE 1
        p := hb_pValue( 1 )
        IF hb_isChar( p )
            action := HTAction():New( p, Self )
            AAdd( ::Factions, action )
        ELSEIF hb_isObject( p )
            AAdd( ::Factions, p )
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
    AddMenu
*/
METHOD AddMenu( ... ) CLASS HTMenuBar

RETURN Self

/*
    PositionMenu()
*/
METHOD PositionMenu() CLASS HTMenuBar

     // ( nTop, nLeft, nBottom, nRight )

RETURN Self
