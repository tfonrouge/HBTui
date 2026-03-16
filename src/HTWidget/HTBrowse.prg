/*
 * HTBrowse - TBrowse wrapper widget
 *
 * Wraps Harbour's TBrowse class as an HTWidget child.
 * Relies on the CT window viewport (wFormat) set by paintChild()
 * so that TBrowse's DispOutAt/SetPos calls are automatically
 * remapped to the widget's area within the parent window.
 */

#include "hbtui.ch"
#include "inkey.ch"

#define _BRW_COLOR_NORMAL   "N/W,N/BG,B/W,B/W,B/GR"
#define _BRW_COLOR_FOCUSED  "N/W,W+/B,B/W,B/W,B/GR"

CLASS HTBrowse FROM HTWidget

PROTECTED:

    DATA FoBrowse                           /* TBrowse instance */
    DATA FlConfigured    INIT .F.

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

    /* direct access to TBrowse object */
    METHOD browse() INLINE ::FoBrowse

    PROPERTY onActivated                        /* {|nRow, nCol| ... } Enter/dblclick */

ENDCLASS

/*
    new
*/
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

/*
    configureBrowse
    Sets TBrowse coordinates to fill the viewport. Called before stabilize.
*/
METHOD PROCEDURE configureBrowse() CLASS HTBrowse

    ::FoBrowse:nTop    := 0
    ::FoBrowse:nLeft   := 0
    ::FoBrowse:nBottom := MaxRow()
    ::FoBrowse:nRight  := MaxCol()

    ::FoBrowse:configure()
    ::FlConfigured := .T.

RETURN

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HTBrowse

    HB_SYMBOL_UNUSED( paintEvent )

    IF ::FoBrowse:colCount = 0
        RETURN
    ENDIF

    /* set colorSpec based on focus state */
    ::FoBrowse:colorSpec := IIF( ::hasFocus(), _BRW_COLOR_FOCUSED, _BRW_COLOR_NORMAL )

    /* configure TBrowse to fill viewport (only on first paint) */
    IF ! ::FlConfigured
        ::configureBrowse()
    ENDIF

    /* let TBrowse render - it uses DispOutAt which the CT viewport remaps */
    ::FoBrowse:refreshAll()
    ::FoBrowse:forceStable()

RETURN

/*
    keyEvent
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
    OTHERWISE
        RETURN
    ENDSWITCH

    keyEvent:accept()

    /* repaint via parent to re-establish the viewport */
    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:repaintChild( self )
    ENDIF

RETURN

/*
    mouseEvent
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
        nMouseRow := eventMouse:mouseRow - 1 - ::Fy

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

/*
    setSkipBlock
*/
METHOD PROCEDURE setSkipBlock( b ) CLASS HTBrowse
    ::FoBrowse:skipBlock := b
RETURN

/*
    setGoTopBlock
*/
METHOD PROCEDURE setGoTopBlock( b ) CLASS HTBrowse
    ::FoBrowse:goTopBlock := b
RETURN

/*
    setGoBottomBlock
*/
METHOD PROCEDURE setGoBottomBlock( b ) CLASS HTBrowse
    ::FoBrowse:goBottomBlock := b
RETURN

/*
    addColumn
    Accepts either a TBColumn object or (cHeading, bBlock [, nWidth [, cPicture]])
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

/*
    refreshAll
*/
METHOD PROCEDURE refreshAll() CLASS HTBrowse

    LOCAL parent

    ::FoBrowse:refreshAll()

    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:repaintChild( self )
    ENDIF

RETURN

/*
    refreshCurrent
*/
METHOD PROCEDURE refreshCurrent() CLASS HTBrowse

    LOCAL parent

    ::FoBrowse:refreshCurrent()

    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:repaintChild( self )
    ENDIF

RETURN
