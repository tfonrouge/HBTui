/*
 *
 */

#include "hbtui.ch"

THREAD STATIC __s_childList := {=>}

/*
    HObject
*/
CLASS HObject FROM HBase
PRIVATE:
    DATA Fparent
    METHOD addChild( child )
PROTECTED:
    DATA FmenuBar
    METHOD setMenuBar( menuBar )
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
METHOD new( parent ) CLASS HObject
    ::Fchildren := {}
    IF pCount() = 1
        ::setParent( parent )
    ENDIF
RETURN self

/*
    addChild
*/
METHOD PROCEDURE addChild( child ) CLASS HObject
    IF aScan( ::Fchildren, {|e| e == child } ) = 0
        aAdd( ::Fchildren, child )
    ENDIF
RETURN

/*
    setMenuBar
*/
METHOD PROCEDURE setMenuBar( menuBar ) CLASS HObject
    ::FmenuBar := ht_objectId( menuBar )
RETURN

/*
    event
*/
METHOD FUNCTION event( event ) CLASS HObject
RETURN event:isAccepted()

/*
    parent
*/
METHOD FUNCTION parent() CLASS HObject
    IF ::Fparent != NIL
        RETURN ht_objectFromId( ::Fparent )
    ENDIF
RETURN NIL

/*
  setParent
*/
METHOD PROCEDURE setParent( parent ) CLASS HObject
    IF parent != NIL
        IF parent:isDerivedFrom("HObject")
            ::Fparent := ht_objectId( parent )
            parent:addChild( self )
            IF ::isDerivedFrom("HMenuBar")
                parent:setMenuBar( self )
            ENDIF
        ELSE
            ::PARAM_ERROR()
        ENDIF
    ENDIF
RETURN

/*
    End HObject Class
*/
