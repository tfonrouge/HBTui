/** @class HTObject
 * Base class providing parent/child tree management and event dispatch.
 * @extends HTBase
 */

#include "hbtui.ch"

THREAD STATIC __s_childList := {=>}

CLASS HTObject FROM HTBase

PRIVATE:

    DATA Fparent

PROTECTED:

    DATA FmenuBar
    METHOD addChild( child )
    METHOD removeChild( child )
    METHOD setMenuBar( menuBar )

PUBLIC:

    CONSTRUCTOR new( parent )

    METHOD event( event )
    METHOD parent()
    METHOD setParent( parent )

    PROPERTY children

ENDCLASS

/** Creates a new instance.
 * @param parent Optional parent HTObject
 */
METHOD new( parent ) CLASS HTObject

    ::Fchildren := {}
    IF pCount() = 1
        ::setParent( parent )
    ENDIF

RETURN self

/** Adds a child object to this object's children list.
 * @param child The child HTObject to add
 */
METHOD PROCEDURE addChild( child ) CLASS HTObject
    IF aScan( ::Fchildren, {|e| e == child } ) = 0
        aAdd( ::Fchildren, child )
    ENDIF
RETURN

/** Removes a child object from this object's children list.
 * @param child The child HTObject to remove
 */
METHOD PROCEDURE removeChild( child ) CLASS HTObject
    LOCAL nPos
    nPos := aScan( ::Fchildren, {|e| e == child } )
    IF nPos > 0
        hb_aDel( ::Fchildren, nPos, .T. )
    ENDIF
RETURN

/** Sets the menu bar for this object.
 * @param menuBar The HTMenuBar instance to attach
 */
METHOD PROCEDURE setMenuBar( menuBar ) CLASS HTObject
    ::FmenuBar := ht_objectId( menuBar )
RETURN

/** Handles an incoming event.
 * @param event The HTEvent to process
 * @return .T. if the event was accepted
 */
METHOD FUNCTION event( event ) CLASS HTObject
RETURN event:isAccepted()

/** Returns the parent object, or NIL if none.
 * @return The parent HTObject or NIL
 */
METHOD FUNCTION parent() CLASS HTObject
    IF ::Fparent != NIL
        RETURN ht_objectFromId( ::Fparent )
    ENDIF
RETURN NIL

/** Sets the parent object and registers this object as its child.
 * @param parent The new parent HTObject
 */
METHOD PROCEDURE setParent( parent ) CLASS HTObject
    IF parent != NIL
        IF parent:isDerivedFrom("HTObject")
            ::Fparent := ht_objectId( parent )
            parent:addChild( self )
            IF ::isDerivedFrom("HTMenuBar")
                parent:setMenuBar( self )
            ENDIF
        ELSE
            ::PARAM_ERROR()
        ENDIF
    ENDIF
RETURN

