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

    METHOD paintEvent( event )

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

RETURN self

/*
    addAction
*/
METHOD FUNCTION addAction( ... ) CLASS HTMenuBar
    LOCAL version := 0
    LOCAL action
    LOCAL text
    LOCAL receiver
    LOCAL member
    LOCAL retValue

    IF pCount() = 1
        text := hb_pValue( 1 )
        IF hb_isChar( text )
            version := 1
        ENDIF
    ENDIF

    IF pCount() = 3
        text := hb_pValue( 1 )
        receiver := hb_pValue( 2 )
        member := hb_pValue( 3 )
        IF hb_isChar( text ) .AND. hb_isObject( receiver ) .AND. hb_isChar( member )
            version := 2
        ENDIF
    ENDIF

    IF pCount() = 1
        action := hb_pValue( 1 )
        IF hb_isObject( action )
            version := 3
        ENDIF
    ENDIF

    SWITCH version
    CASE 1
        action := HTAction():new( text, self )
        retValue := action
        EXIT
    CASE 2
        action := HTAction():new( text, receiver )
        retValue := action
        EXIT
    CASE 3
        EXIT
    OTHERWISE
        ::PARAM_ERROR()
    ENDSWITCH

    ::super:addAction( action )

RETURN retValue

/*
    addMenu
*/
METHOD FUNCTION addMenu( ... ) CLASS HTMenuBar
    LOCAL version := 0
    LOCAL menu
    LOCAL title
    LOCAL retValue

    IF pCount() = 1
        menu := hb_pValue( 1 )
        IF hb_isObject( menu ) .AND. menu:isDerivedFrom("HTMenu")
            version := 1
        ENDIF
    ENDIF

    IF pCount() = 1
        title := hb_pValue( 1 )
        IF hb_isChar( title )
            version := 2
        ENDIF
    ENDIF

    SWITCH version
    CASE 1
        menu:setParent( self )
        retValue := menu:menuAction()
        EXIT
    CASE 2
        menu := HTMenu():new( title, self )
        retValue := menu
        EXIT
    OTHERWISE
        ::PARAM_ERROR()
    ENDSWITCH

RETURN retValue

/*
    addSeparator
*/
METHOD FUNCTION addSeparator() CLASS HTMenuBar

RETURN self

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( event ) CLASS HTMenuBar
    LOCAL itm
    LOCAL row := 0

    IF menuBar != NIL
        wSelect( ::windowId, .f. )
        wFormat()
        wFormat( 1, 0, 1, 0 )
        dispOutAt( 0, 0, space( ::Fwidth ), "00/07" )
        FOR EACH itm IN menuBar:children
            IF itm:isDerivedFrom("HTMenu")
                itm:move( 0, ++row )
                row += len( itm:title )
            ENDIF
        NEXT
        wFormat()
        wFormat( 1, 1, 1, 1 )
    ENDIF

RETURN
