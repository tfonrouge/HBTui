/*
 *
 */

#include "hbtui.ch"

/*
    HTObject
*/
CLASS HTObject FROM HTBase
PROTECTED:
    METHOD addChild( child )
PUBLIC:

    CONSTRUCTOR new( parent )

    METHOD event( event )
    METHOD setParent( parent )

    PROPERTY children INIT {}
    PROPERTY parent WRITE setParent

ENDCLASS

/*
  new
*/
METHOD new( parent ) CLASS HTObject
    IF pCount() = 1
        ::setParent( parent )
    ENDIF
RETURN Self

/*
  addChild
*/
METHOD PROCEDURE addChild( child ) CLASS HTObject
    aAdd( ::Fchildren, child )
RETURN

/*
    event
*/
METHOD FUNCTION event( event ) CLASS HTObject
RETURN event:isAccepted()

/*
  setParent
*/
METHOD PROCEDURE setParent( parent ) CLASS HTObject
    IF parent != NIL
        IF parent:IsDerivedFrom("HTObject")
            ::Fparent := parent
            parent:addChild( Self )
        ELSE
            ::Error_Parent_Is_Not_Derived_From_TXObject()
        ENDIF
    ENDIF
RETURN

/*
    End HTObject Class
*/
