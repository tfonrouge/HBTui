/** @class HTMenuBar
 * Horizontal menu bar with keyboard activation (F10, Alt+letter accelerators).
 * Supports dropdown menus with arrow-key navigation and Enter to trigger actions.
 * @extends HTWidget
 */

#include "hbtui.ch"
#include "inkey.ch"


CLASS HTMenuBar FROM HTWidget

PROTECTED:

    DATA FactiveMenu     INIT 0
    DATA FactiveItem     INIT 0
    DATA FmenuOpen       INIT .F.
    DATA FdropWinId      INIT NIL

    METHOD openMenu( nIndex )
    METHOD closeMenu()
    METHOD paintDropdown( oMenu )
    METHOD getMenus()

PUBLIC:

    CONSTRUCTOR new( parent )

    METHOD addAction( ... )
    METHOD addMenu( ... )
    METHOD addSeparator()

    METHOD paintEvent( event )
    METHOD handleKey( nKey )

ENDCLASS

/** Creates a menu bar attached to the given parent widget.
 * @param parent Parent widget (typically HTMainWindow or HTDesktop)
 */
METHOD new( parent ) CLASS HTMenuBar

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

/** Adds an action to the menu bar. Accepts text, (text, receiver, member), or HTAction.
 * @param ... String text, or (text, receiver, member), or HTAction object
 * @return HTAction instance
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
        text     := hb_pValue( 1 )
        receiver := hb_pValue( 2 )
        member   := hb_pValue( 3 )
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

/** Adds a submenu to the menu bar. Accepts HTMenu object or title string.
 * @param ... HTMenu instance or string title
 * @return HTMenu instance
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

/** Adds a visual separator to the menu bar (no-op placeholder).
 * @return Self
 */
METHOD FUNCTION addSeparator() CLASS HTMenuBar

RETURN self

/** Returns array of HTMenu children.
 * @return Array of HTMenu
 */
METHOD FUNCTION getMenus() CLASS HTMenuBar

    LOCAL aMenus := {}
    LOCAL itm

    FOR EACH itm IN ::children
        IF itm:isDerivedFrom("HTMenu")
            AAdd( aMenus, itm )
        ENDIF
    NEXT

RETURN aMenus

/** Paints the menu bar row with menu titles, highlighting the active menu.
 * @param event HTPaintEvent instance
 */
METHOD PROCEDURE paintEvent( event ) CLASS HTMenuBar

    LOCAL itm
    LOCAL y := 0
    LOCAL nIdx := 0
    LOCAL cColor

    HB_SYMBOL_UNUSED( event )

    wSelect( ::parent():windowId, .F. )
    wFormat()
    wFormat( 1, 0, 1, 0 )
    DispOutAt( 0, 0, Space( ::parent():width ), HTTheme():getColor( HT_CLR_MENU_BAR ) )
    FOR EACH itm IN ::children
        IF itm:isDerivedFrom("HTMenu")
            nIdx++
            cColor := IIF( nIdx = ::FactiveMenu, HTTheme():getColor( HT_CLR_MENU_BAR_SEL ), HTTheme():getColor( HT_CLR_MENU_BAR ) )
            itm:move( 0, ++y )
            DispOutAt( 0, y, " " + itm:title + " ", cColor )
            y += Len( itm:title ) + 2
        ENDIF
    NEXT
    wFormat()
    wFormat( 1, 1, 1, 1 )

RETURN

/** Processes keyboard input for the menu bar (F10 toggle, Alt+letter,
 * arrow navigation, Enter to trigger, ESC to close).
 * @param nKey Inkey code
 * @return .T. if the key was consumed
 */
METHOD FUNCTION handleKey( nKey ) CLASS HTMenuBar

    LOCAL aMenus := ::getMenus()
    LOCAL nMenuCount := Len( aMenus )
    LOCAL i
    LOCAL parent
    LOCAL aActions, nActionCount

    IF nMenuCount = 0
        RETURN .F.
    ENDIF

    /* F10 toggles menu activation */
    IF nKey = K_F10
        IF ::FactiveMenu = 0
            ::FactiveMenu := 1
        ELSE
            ::FactiveMenu := 0
            ::closeMenu()
        ENDIF
        parent := ::parent()
        IF parent != NIL
            parent:repaint()
        ENDIF
        RETURN .T.
    ENDIF

    /* Alt+letter accelerators (check first letter of each menu title) */
    IF ::FactiveMenu = 0
        /* check for Alt+letter: Alt key codes are typically K_ALT_A to K_ALT_Z */
        FOR i := 1 TO nMenuCount
            IF nKey = hb_keyCode( "Alt+" + Upper( Left( aMenus[ i ]:title, 1 ) ) )
                ::FactiveMenu := i
                ::openMenu( i )
                parent := ::parent()
                IF parent != NIL
                    parent:repaint()
                ENDIF
                RETURN .T.
            ENDIF
        NEXT
    ENDIF

    /* if menu bar is not active, don't consume keys */
    IF ::FactiveMenu = 0
        RETURN .F.
    ENDIF

    /* menu bar is active: handle navigation */
    IF ::FmenuOpen .AND. ::FactiveMenu >= 1 .AND. ::FactiveMenu <= nMenuCount
        aActions := aMenus[ ::FactiveMenu ]:actions()
        nActionCount := Len( aActions )
    ELSE
        aActions := {}
        nActionCount := 0
    ENDIF

    SWITCH nKey
    CASE K_LEFT
        ::FactiveMenu := IIF( ::FactiveMenu <= 1, nMenuCount, ::FactiveMenu - 1 )
        IF ::FmenuOpen
            ::FactiveItem := 0
            ::openMenu( ::FactiveMenu )
        ENDIF
        EXIT
    CASE K_RIGHT
        ::FactiveMenu := IIF( ::FactiveMenu >= nMenuCount, 1, ::FactiveMenu + 1 )
        IF ::FmenuOpen
            ::FactiveItem := 0
            ::openMenu( ::FactiveMenu )
        ENDIF
        EXIT
    CASE K_DOWN
        IF ::FmenuOpen
            /* navigate down in dropdown, skip separators */
            ::FactiveItem++
            DO WHILE ::FactiveItem <= nActionCount .AND. aActions[ ::FactiveItem ]:isSeparator
                ::FactiveItem++
            ENDDO
            IF ::FactiveItem > nActionCount
                ::FactiveItem := 1
                DO WHILE ::FactiveItem <= nActionCount .AND. aActions[ ::FactiveItem ]:isSeparator
                    ::FactiveItem++
                ENDDO
            ENDIF
            ::paintDropdown( aMenus[ ::FactiveMenu ] )
            /* reselect parent window */
            parent := ::parent()
            IF parent != NIL
                wSelect( parent:windowId, .F. )
            ENDIF
        ELSE
            ::openMenu( ::FactiveMenu )
        ENDIF
        EXIT
    CASE K_UP
        IF ::FmenuOpen .AND. nActionCount > 0
            ::FactiveItem--
            DO WHILE ::FactiveItem >= 1 .AND. aActions[ ::FactiveItem ]:isSeparator
                ::FactiveItem--
            ENDDO
            IF ::FactiveItem < 1
                ::FactiveItem := nActionCount
                DO WHILE ::FactiveItem >= 1 .AND. aActions[ ::FactiveItem ]:isSeparator
                    ::FactiveItem--
                ENDDO
            ENDIF
            ::paintDropdown( aMenus[ ::FactiveMenu ] )
            parent := ::parent()
            IF parent != NIL
                wSelect( parent:windowId, .F. )
            ENDIF
        ENDIF
        EXIT
    CASE K_ENTER
        IF ::FmenuOpen .AND. ::FactiveItem >= 1 .AND. ::FactiveItem <= nActionCount
            /* trigger the selected action */
            aActions[ ::FactiveItem ]:trigger()
            ::closeMenu()
            ::FactiveMenu := 0
            ::FactiveItem := 0
        ELSEIF ! ::FmenuOpen
            ::openMenu( ::FactiveMenu )
        ELSE
            ::closeMenu()
            ::FactiveMenu := 0
        ENDIF
        EXIT
    CASE K_ESC
        ::closeMenu()
        ::FactiveMenu := 0
        ::FactiveItem := 0
        EXIT
    OTHERWISE
        RETURN .F.
    ENDSWITCH

    parent := ::parent()
    IF parent != NIL
        parent:repaint()
    ENDIF

RETURN .T.

/** Opens the dropdown for the menu at the given index.
 * @param nIndex 1-based menu index
 */
METHOD PROCEDURE openMenu( nIndex ) CLASS HTMenuBar

    LOCAL aMenus := ::getMenus()
    LOCAL oMenu
    LOCAL nActions, nMaxWidth
    LOCAL nDropTop, nDropLeft, nDropBottom, nDropRight
    LOCAL itm, nMenuLeft

    IF nIndex < 1 .OR. nIndex > Len( aMenus )
        RETURN
    ENDIF

    /* close any existing dropdown */
    ::closeMenu()

    oMenu := aMenus[ nIndex ]
    ::FmenuOpen := .T.

    /* calculate dropdown position */
    nActions := 0
    nMaxWidth := 10
    FOR EACH itm IN oMenu:actions()
        nActions++
        nMaxWidth := Max( nMaxWidth, Len( itm:text ) + 4 )
    NEXT

    IF nActions = 0
        RETURN
    ENDIF

    /* find menu's horizontal position */
    nMenuLeft := 0
    FOR itm := 1 TO nIndex - 1
        nMenuLeft += Len( aMenus[ itm ]:title ) + 3
    NEXT
    nMenuLeft++

    nDropTop    := wRow() + 2
    nDropLeft   := wCol() + nMenuLeft
    nDropBottom := nDropTop + nActions + 1
    nDropRight  := nDropLeft + nMaxWidth

    ::FdropWinId := wOpen( nDropTop, nDropLeft, nDropBottom, nDropRight, .T. )
    wSetShadow( 8 )
    wBox( NIL, HTTheme():getColor( HT_CLR_MENU_ITEM ) )
    wFormat()

    ::paintDropdown( oMenu )

RETURN

/** Closes the currently open dropdown menu and restores the parent window. */
METHOD PROCEDURE closeMenu() CLASS HTMenuBar

    LOCAL parent

    IF ::FdropWinId != NIL
        wClose( ::FdropWinId )
        ::FdropWinId := NIL
    ENDIF

    ::FmenuOpen := .F.

    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        wSelect( parent:windowId, .F. )
    ENDIF

RETURN

/** Renders the dropdown menu items with highlight on the active item.
 * @param oMenu HTMenu whose actions to display
 */
METHOD PROCEDURE paintDropdown( oMenu ) CLASS HTMenuBar

    LOCAL itm
    LOCAL nRow := 0
    LOCAL nMaxCol
    LOCAL nIdx := 0
    LOCAL cColor

    IF ::FdropWinId = NIL
        RETURN
    ENDIF

    wSelect( ::FdropWinId, .T. )
    wFormat()
    wFormat( 1, 1, 1, 1 )

    nMaxCol := MaxCol()

    FOR EACH itm IN oMenu:actions()
        nIdx++
        IF itm:isSeparator
            DispOutAt( nRow, 0, Replicate( e"\xC4", nMaxCol + 1 ), HTTheme():getColor( HT_CLR_MENU_SEP ) )
        ELSE
            cColor := IIF( nIdx = ::FactiveItem, HTTheme():getColor( HT_CLR_MENU_ITEM_SEL ), HTTheme():getColor( HT_CLR_MENU_ITEM ) )
            DispOutAt( nRow, 0, PadR( " " + itm:text, nMaxCol + 1 ), cColor )
        ENDIF
        nRow++
    NEXT

    wFormat()

RETURN
