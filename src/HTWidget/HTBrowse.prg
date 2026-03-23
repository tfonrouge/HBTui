/** @class HTBrowse
 * TBrowse wrapper widget. Embeds Harbour's TBrowse inside a CT viewport
 * so all TBrowse rendering is automatically mapped to the widget's area.
 * @extends HTWidget
 *
 * @property onActivated Callback {|nRow, nCol| ...} fired on Enter or double-click
 *
 * @example
 *   oBrw := HTBrowse():new( oParent )
 *   oBrw:setGoTopBlock( {|| dbGoTop() } )
 *   oBrw:setGoBottomBlock( {|| dbGoBottom() } )
 *   oBrw:setSkipBlock( {|n| dbSkipper(n) } )
 *   oBrw:addColumn( "Name", {|| FIELD->NAME }, 20 )
 *   oBrw:addColumn( "City", {|| FIELD->CITY }, 15 )
 *   oBrw:onActivated := {|r,c| EditRecord() }
 *
 * @see HTScrollBar, HTTheme
 */

#include "hbtui.ch"
#include "inkey.ch"


CLASS HTBrowse FROM HTWidget

PROTECTED:

    DATA FoBrowse                           /* TBrowse instance */
    DATA FlConfigured    INIT .F.
    DATA FoEditWidget    INIT NIL           /* HTLineEdit used for inline editing */
    DATA FxOldValue      INIT NIL           /* original value before edit */
    DATA FlEditing       INIT .F.           /* currently editing a cell */

    METHOD configureBrowse()

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD paintEvent( paintEvent )
    METHOD keyEvent( keyEvent )
    METHOD mouseEvent( eventMouse )

    /* data source blocks */
    METHOD setSkipBlock( b )
    METHOD setGoTopBlock( b )
    METHOD setGoBottomBlock( b )

    /* column management */
    METHOD addColumn( ... )
    METHOD columnCount() INLINE IIF( ::FoBrowse != NIL, ::FoBrowse:colCount, 0 )

    /* configuration */
    METHOD setHeadSep( c )    INLINE ::FoBrowse:headSep := c
    METHOD setColSep( c )     INLINE ::FoBrowse:colSep := c
    METHOD setFootSep( c )    INLINE ::FoBrowse:footSep := c
    METHOD setColorSpec( c )  INLINE ::FoBrowse:colorSpec := c
    METHOD setFrozen( n )     INLINE ::FoBrowse:freeze := n

    /* state */
    METHOD rowPos()    INLINE ::FoBrowse:rowPos
    METHOD colPos()    INLINE ::FoBrowse:colPos
    METHOD isStable()  INLINE ::FoBrowse:stable
    METHOD hitTop()    INLINE ::FoBrowse:hitTop
    METHOD hitBottom() INLINE ::FoBrowse:hitBottom

    /* refresh */
    METHOD refreshAll()
    METHOD refreshCurrent()

    /* inline editing */
    METHOD beginEdit( nKey )
    METHOD endEdit( lAccept )

    /* direct access to TBrowse object */
    METHOD browse() INLINE ::FoBrowse

    PROPERTY onActivated READWRITE               /* {|nRow, nCol| ... } Enter/dblclick */
    PROPERTY editable INIT .F.                   /* .T. to enable inline cell editing */
    PROPERTY onBeginEdit READWRITE               /* {|nRow, nCol, xValue| lAllow} */
    PROPERTY onEndEdit READWRITE                 /* {|nRow, nCol, xOldValue, xNewValue| lAccept} */

ENDCLASS

/** Creates a new browse widget with an internal TBrowse instance. */
METHOD new( ... ) CLASS HTBrowse

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

    ::FoBrowse := TBrowseNew()

    ::setFocusPolicy( HT_FOCUS_STRONG )
    ::FisVisible := .T.
    ::Fheight := 10
    ::Fwidth := 40

RETURN self

/** Configures the TBrowse coordinates to fill the current viewport. Called on first paint. */
METHOD PROCEDURE configureBrowse() CLASS HTBrowse

    ::FoBrowse:nTop    := 0
    ::FoBrowse:nLeft   := 0
    ::FoBrowse:nBottom := MaxRow()
    ::FoBrowse:nRight  := MaxCol()

    ::FoBrowse:configure()
    ::FlConfigured := .T.

RETURN

/** Configures and stabilizes the TBrowse, rendering all visible rows.
 * @param paintEvent HTPaintEvent (unused)
 */
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HTBrowse

    HB_SYMBOL_UNUSED( paintEvent )

    IF ::FoBrowse:colCount = 0
        RETURN
    ENDIF

    /* set colorSpec based on focus state */
    ::FoBrowse:colorSpec := IIF( ::hasFocus(), HTTheme():getColor( HT_CLR_BROWSE_FOCUSED ), HTTheme():getColor( HT_CLR_BROWSE_NORMAL ) )

    /* configure TBrowse to fill viewport (only on first paint) */
    IF ! ::FlConfigured
        ::configureBrowse()
    ENDIF

    /* let TBrowse render - it uses DispOutAt which the CT viewport remaps */
    ::FoBrowse:refreshAll()
    ::FoBrowse:forceStable()

RETURN

/** Dispatches navigation keys to the underlying TBrowse.
 * @param keyEvent HTKeyEvent
 */
METHOD PROCEDURE keyEvent( keyEvent ) CLASS HTBrowse

    LOCAL parent

    IF ::FoBrowse:colCount = 0
        RETURN
    ENDIF

    SWITCH keyEvent:key
    CASE K_UP
        ::FoBrowse:up()
        EXIT
    CASE K_DOWN
        ::FoBrowse:down()
        EXIT
    CASE K_PGUP
        ::FoBrowse:pageUp()
        EXIT
    CASE K_PGDN
        ::FoBrowse:pageDown()
        EXIT
    CASE K_HOME
        ::FoBrowse:home()
        EXIT
    CASE K_END
        ::FoBrowse:end()
        EXIT
    CASE K_LEFT
        ::FoBrowse:left()
        EXIT
    CASE K_RIGHT
        ::FoBrowse:right()
        EXIT
    CASE K_ENTER
        IF ::FonActivated != NIL
            Eval( ::FonActivated, ::FoBrowse:rowPos, ::FoBrowse:colPos )
        ENDIF
        keyEvent:accept()
        RETURN
    CASE K_CTRL_HOME
        ::FoBrowse:goTop()
        EXIT
    CASE K_CTRL_END
        ::FoBrowse:goBottom()
        EXIT
    CASE K_CTRL_PGUP
        ::FoBrowse:panHome()
        EXIT
    CASE K_CTRL_PGDN
        ::FoBrowse:panEnd()
        EXIT
    CASE K_CTRL_LEFT
        ::FoBrowse:panLeft()
        EXIT
    CASE K_CTRL_RIGHT
        ::FoBrowse:panRight()
        EXIT
    CASE K_F2
        /* F2 starts inline editing */
        IF ::Feditable
            ::beginEdit( 0 )
        ENDIF
        keyEvent:accept()
        RETURN
    OTHERWISE
        /* start editing on printable character */
        IF ::Feditable .AND. Len( hb_keyChar( keyEvent:key ) ) = 1 .AND. Asc( hb_keyChar( keyEvent:key ) ) >= 32
            ::beginEdit( keyEvent:key )
            keyEvent:accept()
            RETURN
        ENDIF
        RETURN
    ENDSWITCH

    keyEvent:accept()

    /* repaint via parent to re-establish the viewport */
    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:repaintChild( self )
    ENDIF

RETURN

/** Handles mouse click to navigate to a data row and mouse wheel scrolling.
 * @param eventMouse HTMouseEvent
 */
METHOD PROCEDURE mouseEvent( eventMouse ) CLASS HTBrowse

    LOCAL nMouseRow
    LOCAL nClickRow, nSkip
    LOCAL parent
    LOCAL nHeadHeight

    IF ::FoBrowse:colCount = 0
        RETURN
    ENDIF

    SWITCH eventMouse:nKey
    CASE K_LBUTTONDOWN

        /*
         * Mouse coords are relative to the CT window (margins=0).
         * The browse viewport starts at (1 + ::y, 1 + ::x) in window coords.
         * Convert to browse-local coordinates.
         */
        /* mouseRow is child-relative (translated by parent's dispatch) */
        nMouseRow := eventMouse:mouseRow

        IF nMouseRow < 0
            RETURN
        ENDIF

        /* header height: 1 for heading text + 1 for separator if present */
        nHeadHeight := 1
        IF ::FoBrowse:headSep != NIL .AND. ! Empty( ::FoBrowse:headSep )
            nHeadHeight := 2
        ENDIF

        /* data row index (1-based) */
        nClickRow := nMouseRow - nHeadHeight + 1

        IF nClickRow < 1
            RETURN
        ENDIF

        /* skip from current rowPos to clicked row */
        nSkip := nClickRow - ::FoBrowse:rowPos

        IF nSkip > 0
            DO WHILE nSkip > 0
                ::FoBrowse:down()
                nSkip--
            ENDDO
        ELSEIF nSkip < 0
            DO WHILE nSkip < 0
                ::FoBrowse:up()
                nSkip++
            ENDDO
        ENDIF

        parent := ::parent()
        IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
            parent:repaintChild( self )
        ENDIF

        EXIT

    CASE K_MWFORWARD
        ::FoBrowse:up()
        parent := ::parent()
        IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
            parent:repaintChild( self )
        ENDIF
        EXIT

    CASE K_MWBACKWARD
        ::FoBrowse:down()
        parent := ::parent()
        IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
            parent:repaintChild( self )
        ENDIF
        EXIT

    ENDSWITCH

RETURN

/** Sets the TBrowse skip block for record navigation.
 * @param b Code block {|n| skipRows(n)}
 */
METHOD PROCEDURE setSkipBlock( b ) CLASS HTBrowse
    ::FoBrowse:skipBlock := b
RETURN

/** Sets the TBrowse go-top block.
 * @param b Code block {|| goTop()}
 */
METHOD PROCEDURE setGoTopBlock( b ) CLASS HTBrowse
    ::FoBrowse:goTopBlock := b
RETURN

/** Sets the TBrowse go-bottom block.
 * @param b Code block {|| goBottom()}
 */
METHOD PROCEDURE setGoBottomBlock( b ) CLASS HTBrowse
    ::FoBrowse:goBottomBlock := b
RETURN

/** Adds a column. Accepts a TBColumn object or (cHeading, bBlock [, nWidth [, cPicture]]).
 * @param ... TBColumn object, or heading + block + optional width + picture
 */
METHOD PROCEDURE addColumn( ... ) CLASS HTBrowse

    LOCAL oCol
    LOCAL cHeading, bBlock, nWidth

    IF pCount() = 1 .AND. hb_isObject( hb_pValue( 1 ) )
        /* TBColumn object */
        ::FoBrowse:addColumn( hb_pValue( 1 ) )
    ELSEIF pCount() >= 2
        /* convenience: heading + block [+ width [+ picture]] */
        cHeading := hb_pValue( 1 )
        bBlock   := hb_pValue( 2 )
        nWidth   := hb_pValue( 3 )

        oCol := TBColumnNew( cHeading, bBlock )

        IF nWidth != NIL
            oCol:width := nWidth
        ENDIF

        IF pCount() >= 4
            oCol:picture := hb_pValue( 4 )
        ENDIF

        ::FoBrowse:addColumn( oCol )
    ENDIF

    ::FlConfigured := .F.

RETURN

/** Marks all rows for refresh and triggers a repaint via parent. */
METHOD PROCEDURE refreshAll() CLASS HTBrowse

    LOCAL parent

    ::FoBrowse:refreshAll()

    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:repaintChild( self )
    ENDIF

RETURN

/** Starts inline editing of the current cell.
 * Creates a temporary HTLineEdit overlaying the cell.
 * @param nKey Initial key to feed (0 = edit existing value, >0 = start typing)
 */
METHOD PROCEDURE beginEdit( nKey ) CLASS HTBrowse

    LOCAL oCol, xValue, cValue
    LOCAL nColPos, nCellLeft, nCellWidth, nDataRow
    LOCAL parent
    LOCAL nHeadHeight
    LOCAL i, oC

    IF ::FlEditing .OR. ::FoBrowse:colCount = 0
        RETURN
    ENDIF

    nColPos := ::FoBrowse:colPos
    oCol := ::FoBrowse:getColumn( nColPos )

    IF oCol == NIL
        RETURN
    ENDIF

    /* get current cell value */
    xValue := Eval( oCol:block )
    ::FxOldValue := xValue
    cValue := IIF( hb_isString( xValue ), xValue, hb_CStr( xValue ) )

    /* fire onBeginEdit callback */
    IF ::FonBeginEdit != NIL
        IF ! Eval( ::FonBeginEdit, ::FoBrowse:rowPos, nColPos, xValue )
            RETURN
        ENDIF
    ENDIF

    /* calculate cell position within the viewport */
    nHeadHeight := 1
    IF ::FoBrowse:headSep != NIL .AND. ! Empty( ::FoBrowse:headSep )
        nHeadHeight := 2
    ENDIF
    nDataRow := nHeadHeight + ::FoBrowse:rowPos - 1

    /* calculate column left position and width */
    nCellLeft := 0
    FOR i := 1 TO nColPos - 1
        oC := ::FoBrowse:getColumn( i )
        nCellLeft += IIF( oC:width != NIL, oC:width, 10 )
        IF ::FoBrowse:colSep != NIL
            nCellLeft += Len( ::FoBrowse:colSep )
        ENDIF
    NEXT
    nCellWidth := IIF( oCol:width != NIL, oCol:width, 10 )

    /* create edit widget */
    ::FoEditWidget := HTLineEdit():new()
    ::FoEditWidget:Fx := nCellLeft
    ::FoEditWidget:Fy := nDataRow
    ::FoEditWidget:Fwidth := nCellWidth
    ::FoEditWidget:Fheight := 1
    ::FoEditWidget:FisVisible := .T.
    ::FoEditWidget:setText( AllTrim( cValue ) )

    ::FlEditing := .T.

    /* if a key was pressed to start editing, feed it */
    IF nKey > 0
        ::FoEditWidget:setText( "" )
        ::FoEditWidget:keyEvent( HTKeyEvent():new( nKey ) )
    ENDIF

    /* paint the edit widget */
    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:repaintChild( self )
    ENDIF

RETURN

/** Ends inline editing and optionally saves the new value.
 * @param lAccept .T. to save, .F. to discard
 */
METHOD PROCEDURE endEdit( lAccept ) CLASS HTBrowse

    LOCAL xNewValue, oCol, parent

    DEFAULT lAccept := .T.

    IF ! ::FlEditing .OR. ::FoEditWidget == NIL
        RETURN
    ENDIF

    IF lAccept
        xNewValue := ::FoEditWidget:text

        /* fire onEndEdit callback */
        IF ::FonEndEdit != NIL
            IF ! Eval( ::FonEndEdit, ::FoBrowse:rowPos, ::FoBrowse:colPos, ::FxOldValue, xNewValue )
                lAccept := .F.
            ENDIF
        ENDIF

        IF lAccept
            /* write the value back via the column block (if it supports writing) */
            oCol := ::FoBrowse:getColumn( ::FoBrowse:colPos )
            IF oCol != NIL
                Eval( oCol:block, xNewValue )
            ENDIF
        ENDIF
    ENDIF

    ::FoEditWidget := NIL
    ::FxOldValue := NIL
    ::FlEditing := .F.

    /* refresh browse */
    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:repaintChild( self )
    ENDIF

RETURN

/** Marks the current row for refresh and triggers a repaint via parent. */
METHOD PROCEDURE refreshCurrent() CLASS HTBrowse

    LOCAL parent

    ::FoBrowse:refreshCurrent()

    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:repaintChild( self )
    ENDIF

RETURN
