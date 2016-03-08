/*
 *   31-12-2014
 */

#include "hbtui.ch"

CLASS HTMenu FROM HTWidget

PROTECTED:

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD addAction( ... )
    METHOD addMenu()
    METHOD addSeparator()
    METHOD menuAction()
    METHOD paintEvent( event )
    METHOD setTitle( title ) INLINE ::Ftitle := title

    PROPERTY title

ENDCLASS

/*
    new
*/
METHOD new( ... ) CLASS HTMenu

    LOCAL version := 0
    LOCAL parent
    LOCAL title

    IF pCount() <= 1
        parent := hb_pValue( 1 )
        IF parent == NIL .OR. hb_isObject( parent )
            version := 1
        ENDIF
    ENDIF

    IF pCount() <= 2
        title := hb_pValue( 1 )
        parent := hb_pValue( 2 )
        IF hb_isChar( title ) .AND. parent == NIL .OR. hb_isObject( parent )
            version := 2
        ENDIF
    ENDIF

    SWITCH version
    CASE 1
        ::super:new( parent )
        EXIT
    CASE 2
        ::setTitle( title )
        ::super:new( parent )
        EXIT
    OTHERWISE
        ::PARAM_ERROR()
    ENDSWITCH

RETURN self

/*
    addAction
*/
METHOD FUNCTION addAction( ... ) CLASS HTMenu

    LOCAL version := 0
    LOCAL text
    LOCAL action
    LOCAL receiver
    LOCAL member
    LOCAL shortcut

    IF pCount() = 1
        text := hb_pValue( 1 )
        IF hb_isChar( text )
            version := 1
        ENDIF
    ENDIF

    IF pCount() <= 4
        text     := hb_pValue( 1 )
        receiver := hb_pValue( 2 )
        member   := hb_pValue( 3 )
        shortcut := hb_pValue( 4 )
        IF hb_isChar( text ) .AND. hb_isObject( receiver ) .AND. receiver:isDerivedFrom("HTObject") .AND. hb_isChar( member ) .AND. !Empty( member ) .AND. ( shortcut == NIL .OR. hb_isObject( shortcut ) .AND. shortcut:isDerivedFrom("HKeySequence") )
            version := 3
        ENDIF
    ENDIF

    IF pCount() = 1
        action := hb_pValue( 1 )
        IF hb_isObject( action ) .AND. action:isDerivedFrom("HTAction")
            version := 5
        ENDIF
    ENDIF

    SWITCH version
    CASE 1
        action := HTAction():new( text, self )
        EXIT
    CASE 3
        action := HTAction():new( text, self )
        IF shortcut != NIL
            action:setShortcut( shortcut )
        ENDIF
        EXIT
    CASE 5
        EXIT
    OTHERWISE
        ::PARAM_ERROR()
    ENDSWITCH

    ::super:addAction( action )

RETURN action

/*
    addMenu
*/
METHOD FUNCTION addMenu() CLASS HTMenu

    LOCAL version := 0
    LOCAL menu
    LOCAL retValue
    LOCAL title

    IF pCount() = 1
        menu := hb_pValue( 1 )
        IF hb_isObject( menu ) .AND. menu:isDerivedFrom("HTMenu")
            version := 1
            menu:setParent( self )
            retValue := menu:menuAction()
        ENDIF
    ENDIF

    IF pCount() = 1
        title := hb_pValue( 1 )
        IF hb_isChar( title )
            version := 2
            menu := HTMenu():new( title, self )
            retValue := menu
        ENDIF
    ENDIF

    SWITCH version
    CASE 1
        EXIT
    CASE 2
        EXIT
    OTHERWISE
        ::PARAM_ERROR()
    ENDSWITCH

RETURN retValue

/*
    addSeparator
*/
METHOD FUNCTION addSeparator() CLASS HTMenu

    LOCAL action

    action := HTAction():new( self )
    action:setSeparator( .t. )

    ::addAction( action )

RETURN action

/*
    menuAction
*/
METHOD FUNCTION menuAction() CLASS HTMenu
    LOCAL action := NIL
RETURN action

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( event ) CLASS HTMenu
    HB_SYMBOL_UNUSED( event )
    dispOutAt( ::x, ::y, ::title, "00/07" )
RETURN
