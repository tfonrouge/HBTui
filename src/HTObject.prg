/*
 *
 */

#include "hbtui.ch"

THREAD STATIC __s_childList := {=>}

/*
    HTObject
*/
CLASS HTObject FROM HTBase
PRIVATE:
    DATA Fparent
    METHOD addChild( child )
PROTECTED:
PUBLIC:

    CONSTRUCTOR new( parent )

    METHOD event( event )
    METHOD parent()
    METHOD setParent( parent )

    PROPERTY children

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
    IF aScan( ::Fchildren, {|e| e == child } ) = 0
        aAdd( ::Fchildren, child )
    ENDIF
RETURN

/*
    event
*/
METHOD FUNCTION event( event ) CLASS HTObject
RETURN event:isAccepted()

/*
    parent
*/
METHOD FUNCTION parent() CLASS HTObject
    IF ::Fparent != NIL
        RETURN ht_objectFromId( ::Fparent )
    ENDIF
RETURN NIL

/*
  setParent
*/
METHOD PROCEDURE setParent( parent ) CLASS HTObject
    IF parent != NIL
        IF parent:IsDerivedFrom("HTObject")
            ::Fparent := ht_objectId( parent )
            parent:addChild( Self )
        ELSE
            ::PARAM_ERROR()
        ENDIF
    ENDIF
RETURN

/*
    End HTObject Class
*/
