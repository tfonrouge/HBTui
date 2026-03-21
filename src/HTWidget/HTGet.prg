/** @class HTGet
 * Combined label + input widget backed by Harbour's TGet class.
 * Provides full Clipper-compatible PICTURE editing, type-aware input handling,
 * validation with focus rejection, and undo support.
 * @extends HTWidget
 *
 * ## TGet Integration
 *
 * HTGet wraps Harbour's core Get class internally. All editing is delegated
 * to TGet methods (insert, overStrike, delete, left, right, home, end,
 * backSpace, wordLeft, wordRight). The formatted edit buffer (oGet:buffer)
 * is read for display; oGet:assign() + oGet:killFocus() handle value
 * write-back and cleanup on focus loss.
 *
 * **Full PICTURE support (via TGet):**
 * - All template chars: 9, #, A, N, X, L, Y, !, $, *
 * - All @ functions: @!, @A, @B, @C, @D, @E, @K, @R, @S, @T, @X, @Z, @(, @)
 * - Type-aware editing: numeric decimal alignment, date CToD validation,
 *   logical T/F toggle, timestamp fields
 * - Insert/Overwrite toggle (K_INS)
 * - Undo to original value (K_CTRL_U)
 *
 * **Validation with focus rejection:**
 * - VALID block returning .F. keeps focus on the field (user cannot leave)
 * - WHEN block returning .F. prevents field activation
 *
 * **HTWidget additions (not in TGet):**
 * - Integrated label with auto-calculated widths
 * - Password mode (hide property — displays asterisks)
 * - Theme-aware colors via HTTheme()
 * - Viewport painting via wFormat() coordinate isolation
 * - onChange callback on each keystroke modification
 * - Help line text for status bar
 *
 * @property label     Label text displayed before the input area
 * @property picture   PICTURE format string (full Clipper/Harbour syntax)
 * @property xVar      Code block {|x| IIF(x==NIL, val, val:=x)} for read/write variable access
 * @property valid     Post-validation block {|xValue| lOk}; .F. rejects focus change
 * @property when      Pre-condition block {|| lEnabled}; .F. prevents field activation
 * @property helpLine  Context help text shown in status bar when focused
 * @property onChange   Callback {|xValue| ...} fired on each value change
 * @property readOnly  .T. disables editing
 * @property hide      .T. replaces display with asterisks (password mode)
 *
 * @example
 *   /* String GET with uppercase mask */
 *   LOCAL cName := Space(30)
 *   oGet := HTGet():new( oParent )
 *   oGet:setup( {|x| IIF(x==NIL, cName, cName:=x) }, "Name:", "@!", ;
 *               {|v| !Empty(v) }, NIL, "Enter name", NIL, .F., .F., 40 )
 *
 *   /* Numeric GET with decimal */
 *   LOCAL nPrice := 0
 *   oGet2 := HTGet():new( oParent )
 *   oGet2:setup( {|x| IIF(x==NIL, nPrice, nPrice:=x) }, "Price:", "999,999.99" )
 *
 *   /* Date GET */
 *   LOCAL dDate := Date()
 *   oGet3 := HTGet():new( oParent )
 *   oGet3:setup( {|x| IIF(x==NIL, dDate, dDate:=x) }, "Date:", "@D" )
 *
 * @see HTLineEdit, HTTheme, Get (Harbour core TGet class)
 */

#include "hbtui.ch"
#include "inkey.ch"
#include "setcurs.ch"


CLASS HTGet FROM HTWidget

PROTECTED:

    DATA FoGet                                          /* Harbour TGet instance */
    DATA FlGetActive     INIT .F.                       /* whether TGet currently has focus */
    DATA FdispOffset     INIT 1
    DATA FreadOnly       INIT .F.                       /* explicit: avoids READONLY keyword clash */

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD paintEvent( event )
    METHOD keyEvent( keyEvent )
    METHOD mouseEvent( eventMouse )
    METHOD focusInEvent( eventFocus )
    METHOD focusOutEvent( eventFocus )

    METHOD setup( xVar, cLabel, cPicture, bValid, bWhen, cHelpLine, bOnChange, lReadOnly, lHide, nWidth )
    METHOD getValue()
    METHOD setValue( x )
    METHOD setLabel( cLabel )
    METHOD setPicture( cPicture )
    METHOD setXVar( xVar )
    METHOD setReadOnly( lReadOnly )
    METHOD setLabelWidth( nWidth )
    METHOD getDisplayValue()

    METHOD readOnly()   INLINE ::FreadOnly
    METHOD _readOnly( b ) INLINE ::FreadOnly := b

    PROPERTY label WRITE setLabel INIT ""
    PROPERTY picture WRITE setPicture INIT ""
    PROPERTY xVar WRITE setXVar                     /* {|x| IIF( x == NIL, cValue, cValue := x ) } */
    PROPERTY valid READWRITE                         /* {|xValue| lOk } — .F. rejects focus loss */
    PROPERTY when READWRITE                          /* {|| lEnabled } — .F. prevents focus entry */
    PROPERTY helpLine READWRITE INIT ""
    PROPERTY onChange READWRITE                       /* {|xValue| ... } */
    PROPERTY hide READWRITE INIT .F.                 /* password mode */
    PROPERTY labelWidth WRITE setLabelWidth INIT 0
    PROPERTY inputWidth INIT 0

ENDCLASS

/** Creates a new GET widget with optional parent. */
METHOD new( ... ) CLASS HTGet

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
    ::Fheight := 1
    IF ::Fwidth <= 0
        ::Fwidth := 30
    ENDIF

RETURN self

/** Configures all GET properties and creates the internal TGet instance.
 * @param xVar Code block for read/write access to the variable
 * @param cLabel Label text displayed before the input
 * @param cPicture PICTURE format string (full Clipper/Harbour syntax)
 * @param bValid Post-validation code block; .F. return rejects focus change
 * @param bWhen Pre-condition code block; .F. return prevents field activation
 * @param cHelpLine Help text for status bar
 * @param bOnChange Callback fired on each value change
 * @param lReadOnly Read-only mode flag
 * @param lHide Password mode (shows asterisks)
 * @param nWidth Total widget width including label
 */
METHOD PROCEDURE setup( xVar, cLabel, cPicture, bValid, bWhen, cHelpLine, bOnChange, lReadOnly, lHide, nWidth ) CLASS HTGet

    DEFAULT cLabel    := ""
    DEFAULT cPicture  := ""
    DEFAULT cHelpLine := ""
    DEFAULT lReadOnly := .F.
    DEFAULT lHide     := .F.
    DEFAULT nWidth    := 30

    ::xVar      := xVar
    ::label     := cLabel
    ::picture   := cPicture
    ::valid     := bValid
    ::when      := bWhen
    ::helpLine  := cHelpLine
    ::onChange   := bOnChange
    ::readOnly  := lReadOnly
    ::hide      := lHide

    /* calculate label width: label text + 1 space separator */
    IF Len( cLabel ) > 0
        ::FlabelWidth := Len( cLabel ) + 1
    ELSE
        ::FlabelWidth := 0
    ENDIF

    ::Fwidth := nWidth
    ::FinputWidth := ::Fwidth - ::FlabelWidth

    IF ::FinputWidth < 1
        ::FinputWidth := 1
        ::Fwidth := ::FlabelWidth + ::FinputWidth
    ENDIF

    /* create the Harbour TGet instance */
    IF xVar != NIL
        ::FoGet := HTGetBackend():new( 0, ::FlabelWidth, xVar, NIL, cPicture )
        IF bValid != NIL
            ::FoGet:postBlock := bValid
        ENDIF
        IF bWhen != NIL
            ::FoGet:preBlock := bWhen
        ENDIF
    ENDIF

RETURN

/** Renders the label and the TGet edit buffer (or Transform-formatted value when unfocused).
 * @param event HTPaintEvent (unused)
 */
METHOD PROCEDURE paintEvent( event ) CLASS HTGet

    LOCAL cDisplay, cColor, cTransformed
    LOCAL nVisibleWidth
    LOCAL nCursorCol, nCursorPos
    LOCAL nMaxCol := MaxCol()

    HB_SYMBOL_UNUSED( event )

    /* draw label at (0, 0) */
    IF ::FlabelWidth > 0
        DispOutAt( 0, 0, PadR( ::Flabel, ::FlabelWidth ), HTTheme():getColor( HT_CLR_GET_LABEL ) )
    ENDIF

    /* determine input color */
    IF ::FreadOnly
        cColor := HTTheme():getColor( HT_CLR_GET_READONLY )
    ELSEIF ::hasFocus()
        cColor := HTTheme():getColor( HT_CLR_GET_FOCUSED )
    ELSE
        cColor := HTTheme():getColor( HT_CLR_GET_NORMAL )
    ENDIF

    /* get display text from TGet buffer (focused) or Transform (unfocused) */
    IF ::FlGetActive .AND. ::FoGet != NIL .AND. ::FoGet:buffer != NIL
        cTransformed := ::FoGet:buffer
        nCursorPos := ::FoGet:pos
    ELSE
        cTransformed := ::getDisplayValue()
        nCursorPos := 0
    ENDIF

    /* password mode: replace with asterisks */
    IF ::Fhide
        cTransformed := Replicate( "*", Len( cTransformed ) )
    ENDIF

    /* calculate visible input width */
    nVisibleWidth := Min( ::FinputWidth, nMaxCol + 1 - ::FlabelWidth )
    IF nVisibleWidth < 1
        nVisibleWidth := 1
    ENDIF

    /* ensure cursor is visible within display window */
    IF nCursorPos > 0
        IF nCursorPos < ::FdispOffset
            ::FdispOffset := nCursorPos
        ENDIF
        IF nCursorPos > ::FdispOffset + nVisibleWidth - 1
            ::FdispOffset := nCursorPos - nVisibleWidth + 1
        ENDIF
    ELSE
        ::FdispOffset := 1
    ENDIF

    /* extract visible portion of text */
    cDisplay := PadR( SubStr( cTransformed, ::FdispOffset ), nVisibleWidth )

    DispOutAt( 0, ::FlabelWidth, cDisplay, cColor )

    /* position cursor if focused */
    IF ::hasFocus() .AND. ! ::FreadOnly .AND. nCursorPos > 0
        nCursorCol := ::FlabelWidth + nCursorPos - ::FdispOffset
        SetPos( 0, nCursorCol )
    ENDIF

RETURN

/** Delegates keyboard input to the internal TGet for full PICTURE-aware editing.
 * Supports insert/overwrite toggle (Ins), undo (Ctrl+U), word navigation (Ctrl+Left/Right).
 * @param keyEvent HTKeyEvent
 */
METHOD PROCEDURE keyEvent( keyEvent ) CLASS HTGet

    LOCAL parent
    LOCAL lOldChanged
    LOCAL cChar

    IF ::FreadOnly .OR. ::FoGet == NIL .OR. ! ::FlGetActive
        RETURN
    ENDIF

    lOldChanged := ::FoGet:changed

    SWITCH keyEvent:key
    CASE K_LEFT
        ::FoGet:left()
        EXIT
    CASE K_RIGHT
        ::FoGet:right()
        EXIT
    CASE K_HOME
        ::FoGet:home()
        EXIT
    CASE K_END
        ::FoGet:end()
        EXIT
    CASE K_CTRL_LEFT
        ::FoGet:wordLeft()
        EXIT
    CASE K_CTRL_RIGHT
        ::FoGet:wordRight()
        EXIT
    CASE K_BS
        ::FoGet:backSpace()
        EXIT
    CASE K_DEL
        ::FoGet:delete()
        EXIT
    CASE K_CTRL_T
        ::FoGet:delWordRight()
        EXIT
    CASE K_CTRL_Y
        ::FoGet:delEnd()
        EXIT
    CASE K_CTRL_U
        /* undo: restore original value */
        ::FoGet:undo()
        EXIT
    CASE K_INS
        Set( _SET_INSERT, ! Set( _SET_INSERT ) )
        EXIT
    OTHERWISE
        cChar := hb_keyChar( keyEvent:key )
        IF Len( cChar ) = 1 .AND. Asc( cChar ) >= 32
            IF Set( _SET_INSERT )
                ::FoGet:insert( cChar )
            ELSE
                ::FoGet:overStrike( cChar )
            ENDIF
        ELSE
            RETURN
        ENDIF
    ENDSWITCH

    keyEvent:accept()

    /* fire onChange if value was modified */
    IF ! lOldChanged .AND. ::FoGet:changed .AND. ::FonChange != NIL
        ::FoGet:assign()
        Eval( ::FonChange, ::getValue() )
    ELSEIF lOldChanged .AND. ::FonChange != NIL
        ::FoGet:assign()
        Eval( ::FonChange, ::getValue() )
    ENDIF

    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:repaintChild( self )
    ENDIF

RETURN

/** Handles mouse click on the input area to reposition cursor.
 * @param eventMouse HTMouseEvent
 */
METHOD PROCEDURE mouseEvent( eventMouse ) CLASS HTGet

    LOCAL nClickCol, parent, nNewPos

    IF eventMouse:nKey = K_LBUTTONDOWN
        nClickCol := eventMouse:mouseCol - 1 - ::Fx

        /* only react to clicks on the input area */
        IF nClickCol >= ::FlabelWidth .AND. ::FoGet != NIL .AND. ::FlGetActive
            nNewPos := ::FdispOffset + ( nClickCol - ::FlabelWidth )
            IF nNewPos >= 1
                ::FoGet:pos := Min( nNewPos, Len( ::FoGet:buffer ) )
            ENDIF
            parent := ::parent()
            IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
                parent:repaintChild( self )
            ENDIF
        ENDIF
    ENDIF

RETURN

/** Activates the internal TGet (prepares edit buffer, stores original value for undo).
 * Checks WHEN pre-condition before activation.
 * @param eventFocus HTFocusEvent
 */
METHOD PROCEDURE focusInEvent( eventFocus ) CLASS HTGet

    /* check WHEN pre-condition */
    IF ::Fwhen != NIL
        IF ! Eval( ::Fwhen )
            /* WHEN returned .F. — reject focus */
            IF eventFocus != NIL
                eventFocus:ignore()
            ENDIF
            RETURN
        ENDIF
    ENDIF

    /* activate TGet */
    IF ::FoGet != NIL .AND. ! ::FlGetActive
        ::FoGet:setFocus()
        ::FlGetActive := .T.
        ::FdispOffset := 1
    ENDIF

    ::super:focusInEvent( eventFocus )

RETURN

/** Writes the edited value back to the variable via TGet:assign(), runs VALID
 * post-validation. If VALID returns .F., focus is kept on this field.
 * @param eventFocus HTFocusEvent
 */
METHOD PROCEDURE focusOutEvent( eventFocus ) CLASS HTGet

    LOCAL xValue
    LOCAL parent

    IF ::FlGetActive .AND. ::FoGet != NIL

        /* write edited value back to the variable */
        ::FoGet:assign()

        /* run post-validation */
        IF ::Fvalid != NIL
            xValue := ::getValue()
            IF ! Eval( ::Fvalid, xValue )
                /* validation failed — deactivate cleanly, reject the focus change */
                ::FoGet:killFocus()
                ::FlGetActive := .F.
                IF eventFocus != NIL
                    eventFocus:ignore()
                ENDIF
                /* repaint to show validation feedback (e.g. status bar message) */
                parent := ::parent()
                IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
                    parent:repaintChild( self )
                ENDIF
                RETURN
            ENDIF
        ENDIF

        ::FoGet:killFocus()
        ::FlGetActive := .F.

    ENDIF

    ::super:focusOutEvent( eventFocus )

RETURN

/** Returns the current value by evaluating the xVar code block.
 * @return Current value, or empty string if xVar is NIL
 */
METHOD FUNCTION getValue() CLASS HTGet

    IF ::FxVar != NIL
        RETURN Eval( ::FxVar )
    ENDIF

RETURN ""

/** Sets the value by evaluating the xVar code block with the new value.
 * @param x New value to store
 */
METHOD PROCEDURE setValue( x ) CLASS HTGet

    IF ::FxVar != NIL
        Eval( ::FxVar, x )
    ENDIF

RETURN

/** Sets the label text and recalculates label/input widths.
 * @param cLabel New label text
 */
METHOD PROCEDURE setLabel( cLabel ) CLASS HTGet

    ::Flabel := cLabel
    IF Len( cLabel ) > 0
        ::FlabelWidth := Len( cLabel ) + 1
    ELSE
        ::FlabelWidth := 0
    ENDIF
    ::FinputWidth := ::Fwidth - ::FlabelWidth
    IF ::FinputWidth < 1
        ::FinputWidth := 1
    ENDIF

RETURN

/** Sets the PICTURE format string and updates the TGet if it exists.
 * @param cPicture PICTURE clause (full Clipper/Harbour syntax)
 */
METHOD PROCEDURE setPicture( cPicture ) CLASS HTGet
    ::Fpicture := cPicture
    IF ::FoGet != NIL
        ::FoGet:picture := cPicture
    ENDIF
RETURN

/** Sets the variable access code block and recreates the TGet.
 * @param xVar Code block {|x| IIF(x==NIL, val, val:=x)}
 */
METHOD PROCEDURE setXVar( xVar ) CLASS HTGet
    ::FxVar := xVar
    IF xVar != NIL
        ::FoGet := Get():new( 0, ::FlabelWidth, xVar, NIL, ::Fpicture )
        IF ::Fvalid != NIL
            ::FoGet:postBlock := ::Fvalid
        ENDIF
        IF ::Fwhen != NIL
            ::FoGet:preBlock := ::Fwhen
        ENDIF
    ELSE
        ::FoGet := NIL
    ENDIF
RETURN

/** Sets the read-only state.
 * @param lReadOnly .T. to disable editing
 */
METHOD PROCEDURE setReadOnly( lReadOnly ) CLASS HTGet
    ::FreadOnly := lReadOnly
RETURN

/** Overrides the auto-calculated label width and recalculates input width.
 * @param nWidth Label width in columns
 */
METHOD PROCEDURE setLabelWidth( nWidth ) CLASS HTGet

    ::FlabelWidth := nWidth
    ::FinputWidth := ::Fwidth - ::FlabelWidth
    IF ::FinputWidth < 1
        ::FinputWidth := 1
    ENDIF

RETURN

/** Returns the formatted display value for unfocused state.
 * @return Transformed display string
 */
METHOD FUNCTION getDisplayValue() CLASS HTGet

    LOCAL cValue

    cValue := ::getValue()

    IF cValue == NIL
        cValue := ""
    ENDIF

    IF Len( ::Fpicture ) > 0
        RETURN Transform( cValue, ::Fpicture )
    ELSEIF hb_isString( cValue )
        RETURN cValue
    ENDIF

RETURN hb_CStr( cValue )
