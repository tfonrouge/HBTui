/*
 * HTTabWidget - Tabbed panel container widget
 */

#include "hbtui.ch"
#include "inkey.ch"

#define _TAB_COLOR_ACTIVE   "15/01"
#define _TAB_COLOR_INACTIVE "00/07"
#define _TAB_COLOR_BAR      "00/07"

CLASS HTTabWidget FROM HTWidget

PROTECTED:

    DATA FaTabs         INIT {}     /* array of { cTitle, aWidgets } */
    DATA FnActiveTab    INIT 1

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD paintEvent( paintEvent )
    METHOD keyEvent( keyEvent )
    METHOD mouseEvent( eventMouse )

    METHOD addTab( cTitle )
    METHOD setActiveTab( nIndex )
    METHOD activeTab()          INLINE ::FnActiveTab
    METHOD tabCount()           INLINE Len( ::FaTabs )
    METHOD addWidgetToTab( nTabIndex, oWidget )

    PROPERTY onTabChanged                       /* {|nIndex| ... } */

ENDCLASS

/*
    new
*/
METHOD new( ... ) CLASS HTTabWidget

    LOCAL p

    IF pCount() > 0
        p := hb_pValue( 1 )
        IF hb_isObject( p )
            ::super:new( p )
        ELSE
            ::super:new()
        ENDIF
    ELSE
        ::super:new()
    ENDIF

    ::setFocusPolicy( HT_FOCUS_STRONG )
    ::FisVisible := .T.
    ::Fheight := 10
    ::Fwidth := 40

RETURN self

/*
    addTab
    Adds a new tab with the given title. Returns the 1-based tab index.
*/
METHOD FUNCTION addTab( cTitle ) CLASS HTTabWidget

    AAdd( ::FaTabs, { cTitle, {} } )

RETURN Len( ::FaTabs )

/*
    setActiveTab
    Switches to the tab at nIndex and repaints.
*/
METHOD PROCEDURE setActiveTab( nIndex ) CLASS HTTabWidget

    LOCAL parent

    IF nIndex < 1 .OR. nIndex > Len( ::FaTabs )
        RETURN
    ENDIF

    IF nIndex == ::FnActiveTab
        RETURN
    ENDIF

    ::FnActiveTab := nIndex

    IF ::FonTabChanged != NIL
        Eval( ::FonTabChanged, nIndex )
    ENDIF

    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:repaintChild( self )
    ENDIF

RETURN

/*
    addWidgetToTab
    Associates oWidget with the tab at nTabIndex.
    The widget should already be a child of this widget or its parent.
*/
METHOD PROCEDURE addWidgetToTab( nTabIndex, oWidget ) CLASS HTTabWidget

    IF nTabIndex < 1 .OR. nTabIndex > Len( ::FaTabs )
        RETURN
    ENDIF

    AAdd( ::FaTabs[ nTabIndex ][ 2 ], oWidget )

RETURN

/*
    paintEvent
    Draws the tab bar at row 0 and paints the active tab's widgets.
*/
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HTTabWidget

    LOCAL i, nCol, cLabel, cColor
    LOCAL nMaxRow := MaxRow()
    LOCAL nMaxCol := MaxCol()
    LOCAL aTabWidgets, oChild
    LOCAL nTopMargin, nLeftMargin, nBottomMargin, nRightMargin

    HB_SYMBOL_UNUSED( paintEvent )

    /* draw tab bar background at row 0 */
    DispOutAt( 0, 0, Space( nMaxCol + 1 ), _TAB_COLOR_BAR )

    /* draw each tab label */
    nCol := 0
    FOR i := 1 TO Len( ::FaTabs )

        IF i > 1
            /* separator */
            IF nCol <= nMaxCol
                DispOutAt( 0, nCol, hb_UTF8ToStr( Chr( 9474 ) ), _TAB_COLOR_BAR )
                nCol++
            ENDIF
        ENDIF

        cLabel := " " + ::FaTabs[ i ][ 1 ] + " "
        cColor := IIF( i == ::FnActiveTab, _TAB_COLOR_ACTIVE, _TAB_COLOR_INACTIVE )

        IF nCol + Len( cLabel ) - 1 <= nMaxCol
            DispOutAt( 0, nCol, cLabel, cColor )
        ELSEIF nCol <= nMaxCol
            DispOutAt( 0, nCol, Left( cLabel, nMaxCol - nCol + 1 ), cColor )
        ENDIF

        nCol += Len( cLabel )

    NEXT

    /* clear content area (rows 1..nMaxRow) */
    FOR i := 1 TO nMaxRow
        DispOutAt( i, 0, Space( nMaxCol + 1 ), ::color )
    NEXT

    /* paint widgets belonging to the active tab */
    IF ::FnActiveTab >= 1 .AND. ::FnActiveTab <= Len( ::FaTabs )
        aTabWidgets := ::FaTabs[ ::FnActiveTab ][ 2 ]

        FOR EACH oChild IN aTabWidgets
            IF oChild:isDerivedFrom( "HTWidget" ) .AND. oChild:isVisible .AND. ;
               oChild:width > 0 .AND. oChild:height > 0

                /*
                 * Set wFormat margins to position the child within our content area.
                 * Content area starts at row 1 (below tab bar).
                 * Child x,y are relative to the content area.
                 */
                nTopMargin    := 1 + oChild:y
                nLeftMargin   := oChild:x
                nBottomMargin := ( nMaxRow + 1 ) - 1 - oChild:y - oChild:height
                nRightMargin  := ( nMaxCol + 1 ) - oChild:x - oChild:width

                nTopMargin    := Max( nTopMargin, 0 )
                nLeftMargin   := Max( nLeftMargin, 0 )
                nBottomMargin := Max( nBottomMargin, 0 )
                nRightMargin  := Max( nRightMargin, 0 )

                IF nTopMargin + nBottomMargin > nMaxRow .OR. nLeftMargin + nRightMargin > nMaxCol
                    LOOP
                ENDIF

                wFormat( nTopMargin, nLeftMargin, nBottomMargin, nRightMargin )

                oChild:paintEvent( HTPaintEvent():new() )

                wFormat()

            ENDIF
        NEXT
    ENDIF

RETURN

/*
    keyEvent
    Handles Ctrl+Tab/Ctrl+Shift+Tab for tab switching; delegates others.
*/
METHOD PROCEDURE keyEvent( keyEvent ) CLASS HTTabWidget

    LOCAL nKey := keyEvent:key
    LOCAL nNewTab

    /* Ctrl+Right or Ctrl+Tab: next tab */
    IF nKey == K_CTRL_RIGHT .OR. nKey == K_CTRL_TAB
        IF Len( ::FaTabs ) > 0
            nNewTab := IIF( ::FnActiveTab >= Len( ::FaTabs ), 1, ::FnActiveTab + 1 )
            ::setActiveTab( nNewTab )
        ENDIF
        keyEvent:accept()
        RETURN
    ENDIF

    /* Ctrl+Left or Ctrl+Shift+Tab: previous tab */
    IF nKey == K_CTRL_LEFT .OR. nKey == K_CTRL_SH_TAB
        IF Len( ::FaTabs ) > 0
            nNewTab := IIF( ::FnActiveTab <= 1, Len( ::FaTabs ), ::FnActiveTab - 1 )
            ::setActiveTab( nNewTab )
        ENDIF
        keyEvent:accept()
        RETURN
    ENDIF

    /* delegate to parent class (handles Tab focus cycling, dispatches to focused child) */
    ::super:keyEvent( keyEvent )

RETURN

/*
    mouseEvent
    Click on tab bar switches tab; click on content delegates to children.
*/
METHOD PROCEDURE mouseEvent( eventMouse ) CLASS HTTabWidget

    LOCAL nClickRow, nClickCol
    LOCAL i, nCol, cLabel
    LOCAL nTabStart, nTabEnd
    LOCAL parent
    LOCAL nContentRow, nContentCol
    LOCAL oHitChild, aTabWidgets, oChild

    SWITCH eventMouse:nKey
    CASE K_LBUTTONDOWN

        nClickRow := eventMouse:mouseRow - 1 - ::Fy
        nClickCol := eventMouse:mouseCol - 1 - ::Fx

        /* click on tab bar (row 0) */
        IF nClickRow == 0

            nCol := 0
            FOR i := 1 TO Len( ::FaTabs )

                IF i > 1
                    nCol++   /* separator */
                ENDIF

                cLabel := " " + ::FaTabs[ i ][ 1 ] + " "
                nTabStart := nCol
                nTabEnd   := nCol + Len( cLabel ) - 1

                IF nClickCol >= nTabStart .AND. nClickCol <= nTabEnd
                    ::setActiveTab( i )
                    eventMouse:accept()
                    RETURN
                ENDIF

                nCol += Len( cLabel )

            NEXT

        ENDIF

        /* click on content area (row 1+): find and focus child */
        IF nClickRow >= 1 .AND. ::FnActiveTab >= 1 .AND. ::FnActiveTab <= Len( ::FaTabs )

            nContentRow := nClickRow - 1
            nContentCol := nClickCol
            aTabWidgets := ::FaTabs[ ::FnActiveTab ][ 2 ]

            oHitChild := NIL
            FOR EACH oChild IN aTabWidgets
                IF oChild:isDerivedFrom( "HTWidget" ) .AND. oChild:isVisible .AND. ;
                   oChild:width > 0 .AND. oChild:height > 0 .AND. ;
                   nContentRow >= oChild:y .AND. nContentRow < oChild:y + oChild:height .AND. ;
                   nContentCol >= oChild:x .AND. nContentCol < oChild:x + oChild:width
                    oHitChild := oChild
                    EXIT
                ENDIF
            NEXT

            IF oHitChild != NIL
                IF oHitChild:focusPolicy == HT_FOCUS_CLICK .OR. ;
                   oHitChild:focusPolicy == HT_FOCUS_STRONG
                    IF ! oHitChild == ::focusWidget()
                        IF ::focusWidget() != NIL
                            ::focusWidget():focusOutEvent( HTFocusEvent():new( HT_EVENT_TYPE_FOCUSOUT ) )
                        ENDIF
                        ::FfocusWidget := oHitChild
                        ::FfocusWidget:focusInEvent( HTFocusEvent():new( HT_EVENT_TYPE_FOCUSIN ) )
                    ENDIF
                ENDIF
                oHitChild:mouseEvent( eventMouse )
            ENDIF

        ENDIF

        EXIT

    OTHERWISE

        /* delegate scroll / other mouse events to focused child */
        IF ::focusWidget() != NIL
            ::focusWidget():mouseEvent( eventMouse )
        ENDIF

    ENDSWITCH

    HB_SYMBOL_UNUSED( parent )

RETURN

/*
    EndClass
*/
