/** @class HTLineEdit
 * Single-line text input with cursor movement, text selection, and clipboard support.
 * @extends HTWidget
 */

#include "hbtui.ch"
#include "inkey.ch"
#include "hbgtinfo.ch"


CLASS HTLineEdit FROM HTWidget

PROTECTED:

    DATA FcursorPos  INIT 1
    DATA FdispOffset INIT 1
    DATA FselStart   INIT 0    /* 1-based; 0 = no selection */
    DATA FselEnd     INIT 0
    DATA FselAnchor  INIT 0    /* where shift-selection started */

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD paintEvent( event )
    METHOD keyEvent( keyEvent )
    METHOD mouseEvent( eventMouse )

    METHOD setText( text )
    METHOD hasSelection() INLINE ::FselStart > 0 .AND. ::FselEnd > 0 .AND. ::FselStart != ::FselEnd
    METHOD selectedText()
    METHOD clearSelection()

    PROPERTY onChanged READWRITE                 /* {|cText| ... } */
    PROPERTY text WRITE setText INIT ""

HIDDEN:

    METHOD deleteSelection()
    METHOD updateSelection( lShift )

ENDCLASS

/** Creates a new line edit. Accepts optional text and/or parent widget. */
METHOD new( ... ) CLASS HTLineEdit

    LOCAL p

    IF pCount() > 0
        p := hb_pValue( 1 )
        IF hb_isObject( p )
            ::super:new( p )
        ELSE
            ::setText( p )
            ::super:new( hb_pValue( 2 ) )
        ENDIF
    ELSE
        ::super:new()
    ENDIF

    ::setFocusPolicy( HT_FOCUS_STRONG )
    ::FisVisible := .T.
    ::Fheight := 1
    IF ::Fwidth <= 0
        ::Fwidth := 20
    ENDIF

RETURN self

/** Renders the text field with selection highlighting and cursor positioning.
 * @param event HTPaintEvent (unused)
 */
METHOD PROCEDURE paintEvent( event ) CLASS HTLineEdit

    LOCAL cDisplay, cColor, cPre, cSel, cPost
    LOCAL nMaxCol := MaxCol()
    LOCAL nVisibleWidth := nMaxCol + 1
    LOCAL nCursorCol
    LOCAL nSelL, nSelR, nVisSelL, nVisSelR

    HB_SYMBOL_UNUSED( event )

    cColor := IIF( ::hasFocus(), HTTheme():getColor( HT_CLR_LINEEDIT_FOCUSED ), HTTheme():getColor( HT_CLR_LINEEDIT_NORMAL ) )

    /* ensure cursor is visible within display window */
    IF ::FcursorPos < ::FdispOffset
        ::FdispOffset := ::FcursorPos
    ENDIF
    IF ::FcursorPos > ::FdispOffset + nVisibleWidth - 1
        ::FdispOffset := ::FcursorPos - nVisibleWidth + 1
    ENDIF

    /* extract visible portion of text */
    cDisplay := PadR( SubStr( ::Ftext, ::FdispOffset ), nVisibleWidth )

    /* paint with selection highlighting if active */
    IF ::hasSelection() .AND. ::hasFocus()
        nSelL := Min( ::FselStart, ::FselEnd )
        nSelR := Max( ::FselStart, ::FselEnd )

        /* convert to visible coordinates (0-based) */
        nVisSelL := Max( nSelL - ::FdispOffset, 0 )
        nVisSelR := Min( nSelR - ::FdispOffset, nVisibleWidth )

        IF nVisSelL < nVisibleWidth .AND. nVisSelR > 0
            cPre  := Left( cDisplay, nVisSelL )
            cSel  := SubStr( cDisplay, nVisSelL + 1, nVisSelR - nVisSelL )
            cPost := SubStr( cDisplay, nVisSelR + 1 )

            IF Len( cPre ) > 0
                DispOutAt( 0, 0, cPre, cColor )
            ENDIF
            DispOutAt( 0, nVisSelL, cSel, HTTheme():getColor( HT_CLR_LINEEDIT_SELECTED ) )
            IF Len( cPost ) > 0
                DispOutAt( 0, nVisSelR, cPost, cColor )
            ENDIF
        ELSE
            DispOutAt( 0, 0, cDisplay, cColor )
        ENDIF
    ELSE
        DispOutAt( 0, 0, cDisplay, cColor )
    ENDIF

    /* position cursor if focused */
    IF ::hasFocus()
        nCursorCol := ::FcursorPos - ::FdispOffset
        SetPos( 0, nCursorCol )
    ENDIF

RETURN

/** Handles keyboard input: cursor movement, shift-selection, editing, and clipboard (Ctrl+C/X/V).
 * @param keyEvent HTKeyEvent
 */
METHOD PROCEDURE keyEvent( keyEvent ) CLASS HTLineEdit

    LOCAL parent
    LOCAL cChar, cPaste
    LOCAL lChanged := .F.
    LOCAL lShift := hb_bitAnd( hb_gtInfo( HB_GTI_KBDSHIFTS ), HB_GTI_KBD_SHIFT ) != 0

    SWITCH keyEvent:key
    CASE K_LEFT
        ::updateSelection( lShift )
        IF ::FcursorPos > 1
            ::FcursorPos--
        ENDIF
        IF ! lShift
            ::clearSelection()
        ELSE
            ::FselStart := Min( ::FselAnchor, ::FcursorPos )
            ::FselEnd   := Max( ::FselAnchor, ::FcursorPos )
        ENDIF
        EXIT
    CASE K_RIGHT
        ::updateSelection( lShift )
        IF ::FcursorPos <= Len( ::Ftext )
            ::FcursorPos++
        ENDIF
        IF ! lShift
            ::clearSelection()
        ELSE
            ::FselStart := Min( ::FselAnchor, ::FcursorPos )
            ::FselEnd   := Max( ::FselAnchor, ::FcursorPos )
        ENDIF
        EXIT
    CASE K_HOME
        ::updateSelection( lShift )
        ::FcursorPos := 1
        IF ! lShift
            ::clearSelection()
        ELSE
            ::FselStart := Min( ::FselAnchor, ::FcursorPos )
            ::FselEnd   := Max( ::FselAnchor, ::FcursorPos )
        ENDIF
        EXIT
    CASE K_END
        ::updateSelection( lShift )
        ::FcursorPos := Len( ::Ftext ) + 1
        IF ! lShift
            ::clearSelection()
        ELSE
            ::FselStart := Min( ::FselAnchor, ::FcursorPos )
            ::FselEnd   := Max( ::FselAnchor, ::FcursorPos )
        ENDIF
        EXIT
    CASE K_BS
        IF ::hasSelection()
            ::deleteSelection()
            lChanged := .T.
        ELSEIF ::FcursorPos > 1
            ::Ftext := Left( ::Ftext, ::FcursorPos - 2 ) + SubStr( ::Ftext, ::FcursorPos )
            ::FcursorPos--
            lChanged := .T.
        ENDIF
        EXIT
    CASE K_DEL
        IF ::hasSelection()
            ::deleteSelection()
            lChanged := .T.
        ELSEIF ::FcursorPos <= Len( ::Ftext )
            ::Ftext := Left( ::Ftext, ::FcursorPos - 1 ) + SubStr( ::Ftext, ::FcursorPos + 1 )
            lChanged := .T.
        ENDIF
        EXIT
    CASE K_CTRL_C   /* copy */
        IF ::hasSelection()
            hb_gtInfo( HB_GTI_CLIPBOARDDATA, ::selectedText() )
        ENDIF
        EXIT
    CASE K_CTRL_X   /* cut */
        IF ::hasSelection()
            hb_gtInfo( HB_GTI_CLIPBOARDDATA, ::selectedText() )
            ::deleteSelection()
            lChanged := .T.
        ENDIF
        EXIT
    CASE K_CTRL_V   /* paste */
        cPaste := hb_gtInfo( HB_GTI_CLIPBOARDDATA )
        IF hb_isString( cPaste ) .AND. Len( cPaste ) > 0
            IF ::hasSelection()
                ::deleteSelection()
            ENDIF
            ::Ftext := Left( ::Ftext, ::FcursorPos - 1 ) + cPaste + SubStr( ::Ftext, ::FcursorPos )
            ::FcursorPos += Len( cPaste )
            lChanged := .T.
        ENDIF
        EXIT
    OTHERWISE
        /* printable character */
        cChar := hb_keyChar( keyEvent:key )
        IF Len( cChar ) = 1 .AND. hb_asciiUpper( Asc( cChar ) ) >= 32
            IF ::hasSelection()
                ::deleteSelection()
            ENDIF
            ::Ftext := Left( ::Ftext, ::FcursorPos - 1 ) + cChar + SubStr( ::Ftext, ::FcursorPos )
            ::FcursorPos++
            lChanged := .T.
        ELSE
            RETURN
        ENDIF
    ENDSWITCH

    keyEvent:accept()

    IF lChanged .AND. ::FonChanged != NIL
        Eval( ::FonChanged, ::Ftext )
    ENDIF

    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:repaintChild( self )
    ENDIF

RETURN

/** Handles mouse click to reposition cursor.
 * @param eventMouse HTMouseEvent
 */
METHOD PROCEDURE mouseEvent( eventMouse ) CLASS HTLineEdit

    LOCAL nClickCol, parent

    IF eventMouse:nKey = K_LBUTTONDOWN
        nClickCol := eventMouse:mouseCol
        IF nClickCol >= 0
            ::FcursorPos := Min( ::FdispOffset + nClickCol, Len( ::Ftext ) + 1 )
            ::clearSelection()
            parent := ::parent()
            IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
                parent:repaintChild( self )
            ENDIF
        ENDIF
    ENDIF

RETURN

/** Sets the text content and moves cursor to end.
 * @param text New text string
 */
METHOD PROCEDURE setText( text ) CLASS HTLineEdit
    ::Ftext := text
    ::FcursorPos := Len( text ) + 1
    ::clearSelection()
RETURN

/** Returns the currently selected text, or empty string if no selection.
 * @return Selected text substring
 */
METHOD FUNCTION selectedText() CLASS HTLineEdit

    LOCAL nL, nR

    IF ::hasSelection()
        nL := Min( ::FselStart, ::FselEnd )
        nR := Max( ::FselStart, ::FselEnd )
        RETURN SubStr( ::Ftext, nL, nR - nL )
    ENDIF

RETURN ""

/** Clears the current text selection. */
METHOD PROCEDURE clearSelection() CLASS HTLineEdit
    ::FselStart  := 0
    ::FselEnd    := 0
    ::FselAnchor := 0
RETURN

/** Removes the selected text and repositions cursor to selection start. */
METHOD PROCEDURE deleteSelection() CLASS HTLineEdit

    LOCAL nL, nR

    IF ::hasSelection()
        nL := Min( ::FselStart, ::FselEnd )
        nR := Max( ::FselStart, ::FselEnd )
        ::Ftext := Left( ::Ftext, nL - 1 ) + SubStr( ::Ftext, nR )
        ::FcursorPos := nL
        ::clearSelection()
    ENDIF

RETURN

/** Sets the selection anchor point when starting a new shift-selection.
 * @param lShift .T. if Shift key is held
 */
METHOD PROCEDURE updateSelection( lShift ) CLASS HTLineEdit
    IF lShift .AND. ::FselAnchor = 0
        ::FselAnchor := ::FcursorPos
    ENDIF
RETURN
