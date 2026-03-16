/** @class HTMenu
 * Submenu container that holds actions, separators, and nested submenus.
 * Typically added to an HTMenuBar via addMenu().
 * @extends HTWidget
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

/** Creates a new menu, optionally with a title and parent.
 * @param ... Optional (parent) or (title, parent)
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

/** Adds an action to this menu. Accepts text, (text, receiver, member, shortcut), or HTAction.
 * @param ... String text, tuple, or HTAction object
 * @return HTAction instance
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

/** Adds a submenu. Accepts HTMenu object or title string.
 * @return HTMenu instance or menu action
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

/** Adds a separator action (horizontal line) to this menu.
 * @return HTAction separator instance
 */
METHOD FUNCTION addSeparator() CLASS HTMenu

    LOCAL action

    action := HTAction():new( self )
    action:setSeparator( .t. )

    ::addAction( action )

RETURN action

/** Returns the action that represents this menu in a parent menu bar.
 * @return HTAction or NIL
 */
METHOD FUNCTION menuAction() CLASS HTMenu
    LOCAL action := NIL
RETURN action

/** Paints the menu title at its position.
 * @param event HTPaintEvent instance
 */
METHOD PROCEDURE paintEvent( event ) CLASS HTMenu
    HB_SYMBOL_UNUSED( event )
    dispOutAt( ::x, ::y, ::title, "00/07" )
RETURN
