/*
 *   31-12-2014
 */

#include "hbtui.ch"
#include "inkey.ch"

CLASS HMenuBar FROM HWidget
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
METHOD new( parent ) CLASS HMenuBar
    LOCAL version := 0

    IF pCount() <= 1
        IF parent == NIL .OR. hb_isObject( parent )
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
METHOD FUNCTION addAction( ... ) CLASS HMenuBar
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
        action := HAction():new( text, self )
        retValue := action
        EXIT
    CASE 2
        action := HAction():new( text, receiver )
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
METHOD FUNCTION addMenu( ... ) CLASS HMenuBar
    LOCAL version := 0
    LOCAL menu
    LOCAL title
    LOCAL retValue

    IF pCount() = 1
        menu := hb_pValue( 1 )
        IF hb_isObject( menu ) .AND. menu:isDerivedFrom("HMenu")
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
        menu := HMenu():new( title, self )
        retValue := menu
        EXIT
    OTHERWISE
        ::PARAM_ERROR()
    ENDSWITCH

RETURN retValue

/*
    addSeparator
*/
METHOD FUNCTION addSeparator() CLASS HMenuBar

RETURN self

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( event ) CLASS HMenuBar
    LOCAL itm
    LOCAL y := 0

    HB_SYMBOL_UNUSED( event )

    wSelect( ::windowId, .f. )
    wFormat()
    wFormat( 1, 0, 1, 0 )
    dispOutAt( 0, 0, space( ::parent():width ), "00/07" )
    FOR EACH itm IN ::children
        IF itm:isDerivedFrom("HMenu")
            itm:move( 0, ++y )
            y += len( itm:title )
        ENDIF
    NEXT
    wFormat()
    wFormat( 1, 1, 1, 1 )

RETURN
