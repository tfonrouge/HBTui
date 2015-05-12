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

    PROPERTY children
    PROPERTY parent WRITE setParent

ENDCLASS

/*
  new
*/
METHOD new( parent ) CLASS HTObject
    ::Fchildren := {}
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
            ::PARAM_ERROR()
        ENDIF
    ENDIF
RETURN

/*
    End HTObject Class
*/
