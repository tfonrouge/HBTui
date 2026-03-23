/** @class HTContextMenu
 * Right-click popup context menu with keyboard and mouse navigation.
 * Attach to any widget via oWidget:contextMenu or show manually with popup().
 * Runs a modal loop until an item is selected or the menu is dismissed.
 * @extends HTObject
 *
 * @example
 *   oMenu := HTContextMenu():new()
 *   oMenu:addAction( "Edit" ):onTriggered := {|| EditRecord() }
 *   oMenu:addSeparator()
 *   oMenu:addAction( "Delete" ):onTriggered := {|| DeleteRecord() }
 *
 *   /* attach to widget (auto-shows on right-click) */
 *   oBrowse:contextMenu := oMenu
 *
 *   /* or show manually at screen coordinates */
 *   oMenu:popup( nRow, nCol )
 *
 * @see HTWidget:contextMenu, HTAction, HTMenuBar
 */

#include "hbtui.ch"
#include "inkey.ch"

CLASS HTContextMenu FROM HTObject

PROTECTED:

    DATA Factions    INIT {}
    DATA FwinId      INIT NIL
    DATA FactiveItem INIT 0

    METHOD paintPopup()
    METHOD actionableItems()

PUBLIC:

    CONSTRUCTOR new()

    METHOD addAction( cText )
    METHOD addSeparator()
    METHOD popup( nRow, nCol )
    METHOD actions() INLINE ::Factions

ENDCLASS

/** Creates a new empty context menu. */
METHOD new() CLASS HTContextMenu
    ::super:new()
RETURN self

/** Adds a menu item with the given text.
 * @param cText Display text for the action
 * @return HTAction instance (set onTriggered to handle selection)
 */
METHOD FUNCTION addAction( cText ) CLASS HTContextMenu

    LOCAL action

    action := HTAction():new( cText, self )
    AAdd( ::Factions, action )

RETURN action

/** Adds a separator line to the context menu.
 * @return HTAction separator instance
 */
METHOD FUNCTION addSeparator() CLASS HTContextMenu

    LOCAL action

    action := HTAction():new( self )
    action:setSeparator( .T. )
    AAdd( ::Factions, action )

RETURN action

/** Shows the context menu at absolute screen coordinates and runs a modal loop.
 * @param nRow Screen row for popup position
 * @param nCol Screen column for popup position
 * @return The triggered HTAction, or NIL if dismissed
 */
METHOD FUNCTION popup( nRow, nCol ) CLASS HTContextMenu

    LOCAL nKey, nActions, nMaxWidth, nVisibleRows
    LOCAL nWinTop, nWinLeft, nWinBottom, nWinRight
    LOCAL itm, nMouseRow, nClickItem, nIdx
    LOCAL lRunning, oResult, event
    LOCAL nOldWindow

    nActions := Len( ::Factions )
    IF nActions = 0
        RETURN NIL
    ENDIF

    /* calculate popup dimensions */
    nMaxWidth := 4
    FOR EACH itm IN ::Factions
        IF ! itm:isSeparator
            nMaxWidth := Max( nMaxWidth, Len( itm:text ) + 4 )
        ENDIF
    NEXT

    nVisibleRows := nActions

    /* position: try below-right of cursor, adjust if off-screen */
    nWinTop    := nRow
    nWinLeft   := nCol
    nWinBottom := nWinTop + nVisibleRows + 1
    nWinRight  := nWinLeft + nMaxWidth + 1

    /* adjust if off-screen */
    IF nWinBottom > MaxRow()
        nWinTop    := Max( 0, nRow - nVisibleRows - 1 )
        nWinBottom := nWinTop + nVisibleRows + 1
    ENDIF
    IF nWinRight > MaxCol()
        nWinLeft   := Max( 0, MaxCol() - nMaxWidth - 1 )
        nWinRight  := nWinLeft + nMaxWidth + 1
    ENDIF

    /* remember current window to restore later */
    nOldWindow := wSelect()

    /* create popup CT window */
    ::FwinId := wOpen( nWinTop, nWinLeft, nWinBottom, nWinRight, .T. )
    wSetShadow( 8 )
    wBox( NIL, HTTheme():getColor( HT_CLR_CTXMENU_NORMAL ) )
    wFormat()

    /* auto-select first non-separator item */
    ::FactiveItem := 0
    FOR EACH itm IN ::Factions
        IF ! itm:isSeparator
            ::FactiveItem := itm:__enumIndex()
            EXIT
        ENDIF
    NEXT

    ::paintPopup()

    /* modal event loop */
    lRunning := .T.
    oResult := NIL

    DO WHILE lRunning

        event := HTEventLoop():poll( 0.05 )

        IF event == NIL
            LOOP
        ENDIF

        IF event:className() == "HTKEYEVENT"
            nKey := event:key

            SWITCH nKey
            CASE K_UP
                nIdx := ::FactiveItem - 1
                DO WHILE nIdx >= 1
                    IF ! ::Factions[ nIdx ]:isSeparator
                        ::FactiveItem := nIdx
                        EXIT
                    ENDIF
                    nIdx--
                ENDDO
                IF nIdx < 1
                    /* wrap to last non-separator */
                    FOR nIdx := nActions TO 1 STEP -1
                        IF ! ::Factions[ nIdx ]:isSeparator
                            ::FactiveItem := nIdx
                            EXIT
                        ENDIF
                    NEXT
                ENDIF
                ::paintPopup()
                EXIT

            CASE K_DOWN
                nIdx := ::FactiveItem + 1
                DO WHILE nIdx <= nActions
                    IF ! ::Factions[ nIdx ]:isSeparator
                        ::FactiveItem := nIdx
                        EXIT
                    ENDIF
                    nIdx++
                ENDDO
                IF nIdx > nActions
                    /* wrap to first non-separator */
                    FOR nIdx := 1 TO nActions
                        IF ! ::Factions[ nIdx ]:isSeparator
                            ::FactiveItem := nIdx
                            EXIT
                        ENDIF
                    NEXT
                ENDIF
                ::paintPopup()
                EXIT

            CASE K_ENTER
                IF ::FactiveItem >= 1 .AND. ::FactiveItem <= nActions
                    oResult := ::Factions[ ::FactiveItem ]
                ENDIF
                lRunning := .F.
                EXIT

            CASE K_ESC
                lRunning := .F.
                EXIT

            ENDSWITCH

        ELSEIF event:className() == "HTMOUSEEVENT"

            IF event:nKey == K_LBUTTONDOWN .OR. event:nKey == K_RBUTTONDOWN
                /* check if click is inside the popup */
                nMouseRow := event:mouseAbsRow - nWinTop - 1
                IF nMouseRow >= 0 .AND. nMouseRow < nActions .AND. ;
                   event:mouseAbsCol >= nWinLeft .AND. event:mouseAbsCol <= nWinRight
                    nClickItem := nMouseRow + 1
                    IF nClickItem >= 1 .AND. nClickItem <= nActions .AND. ! ::Factions[ nClickItem ]:isSeparator
                        oResult := ::Factions[ nClickItem ]
                    ENDIF
                ENDIF
                /* click outside or on item: close */
                lRunning := .F.

            ELSEIF event:nKey == K_MOUSEMOVE
                /* hover highlight */
                nMouseRow := event:mouseAbsRow - nWinTop - 1
                IF nMouseRow >= 0 .AND. nMouseRow < nActions .AND. ;
                   event:mouseAbsCol >= nWinLeft .AND. event:mouseAbsCol <= nWinRight
                    nClickItem := nMouseRow + 1
                    IF nClickItem >= 1 .AND. nClickItem <= nActions .AND. ! ::Factions[ nClickItem ]:isSeparator
                        IF nClickItem != ::FactiveItem
                            ::FactiveItem := nClickItem
                            ::paintPopup()
                        ENDIF
                    ENDIF
                ENDIF
            ENDIF

        ENDIF

    ENDDO

    /* close popup window */
    IF ::FwinId != NIL
        wClose( ::FwinId )
        ::FwinId := NIL
    ENDIF

    /* restore previous window selection */
    IF nOldWindow > 0
        wSelect( nOldWindow, .F. )
    ENDIF

    /* trigger the selected action */
    IF oResult != NIL
        oResult:trigger()
    ENDIF

RETURN oResult

/** Renders the menu items inside the popup window with active-item highlight. */
METHOD PROCEDURE paintPopup() CLASS HTContextMenu

    LOCAL itm
    LOCAL nRow := 0
    LOCAL nMaxCol
    LOCAL cColor

    IF ::FwinId = NIL
        RETURN
    ENDIF

    wSelect( ::FwinId, .T. )
    wFormat()
    wFormat( 1, 1, 1, 1 )

    nMaxCol := MaxCol()

    FOR EACH itm IN ::Factions
        IF itm:isSeparator
            DispOutAt( nRow, 0, Replicate( e"\xC4", nMaxCol + 1 ), HTTheme():getColor( HT_CLR_CTXMENU_SEP ) )
        ELSE
            cColor := IIF( itm:__enumIndex() = ::FactiveItem, ;
                HTTheme():getColor( HT_CLR_CTXMENU_SELECTED ), ;
                HTTheme():getColor( HT_CLR_CTXMENU_NORMAL ) )
            DispOutAt( nRow, 0, PadR( " " + itm:text, nMaxCol + 1 ), cColor )
        ENDIF
        nRow++
    NEXT

    wFormat()

RETURN

/** Returns array of 1-based indices for non-separator actions.
 * @return Array of numeric indices
 */
METHOD FUNCTION actionableItems() CLASS HTContextMenu

    LOCAL aResult := {}
    LOCAL itm

    FOR EACH itm IN ::Factions
        IF ! itm:isSeparator
            AAdd( aResult, itm:__enumIndex() )
        ENDIF
    NEXT

RETURN aResult
