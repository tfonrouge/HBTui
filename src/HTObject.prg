/*
 *
 */

#include "hbtui.ch"

/*
    HTObject
*/
CLASS HTObject FROM HTBase
PROTECTED:
    METHOD AddChild( child )
PUBLIC:

    CONSTRUCTOR New( parent )

    METHOD event( event )
    METHOD SetParent( parent )

    PROPERTY children INIT {}
    PROPERTY parent WRITE SetParent

ENDCLASS

/*
  New
*/
METHOD New( parent ) CLASS HTObject
    ::SetParent( parent )
RETURN Self

/*
  AddChild
*/
METHOD PROCEDURE AddChild( child ) CLASS HTObject
    AAdd( ::Fchildren, child )
RETURN

/*
    event
*/
METHOD FUNCTION event( event ) CLASS HTObject
RETURN event:isAccepted()

/*
  SetParent
*/
METHOD PROCEDURE SetParent( parent ) CLASS HTObject
    IF parent != NIL
        IF parent:IsDerivedFrom("HTObject")
            ::Fparent := parent
            parent:AddChild( Self )
        ELSE
            ::Error_Parent_Is_Not_Derived_From_TXObject()
        ENDIF
    ENDIF
RETURN

/*
    End HTObject Class
*/
