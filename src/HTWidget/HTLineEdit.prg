/*
 * HTLineEdit - Single-line text input with cursor
 */

#include "hbtui.ch"
#include "inkey.ch"

#define _EDT_COLOR_NORMAL   "N/W"
#define _EDT_COLOR_FOCUSED  "N/BG"

CLASS HTLineEdit FROM HTWidget

PROTECTED:

    DATA FcursorPos  INIT 1
    DATA FdispOffset INIT 1

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD paintEvent( event )
    METHOD keyEvent( keyEvent )
    METHOD mouseEvent( eventMouse )

    METHOD setText( text )

    PROPERTY onChanged                          /* {|cText| ... } */
    PROPERTY text WRITE setText INIT ""

ENDCLASS

/*
    new
*/
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

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( event ) CLASS HTLineEdit

    LOCAL cDisplay, cColor
    LOCAL nMaxCol := MaxCol()
    LOCAL nVisibleWidth := nMaxCol + 1
    LOCAL nCursorCol

    HB_SYMBOL_UNUSED( event )

    cColor := IIF( ::hasFocus(), _EDT_COLOR_FOCUSED, _EDT_COLOR_NORMAL )

    /* ensure cursor is visible within display window */
    IF ::FcursorPos < ::FdispOffset
        ::FdispOffset := ::FcursorPos
    ENDIF
    IF ::FcursorPos > ::FdispOffset + nVisibleWidth - 1
        ::FdispOffset := ::FcursorPos - nVisibleWidth + 1
    ENDIF

    /* extract visible portion of text */
    cDisplay := PadR( SubStr( ::Ftext, ::FdispOffset ), nVisibleWidth )

    DispOutAt( 0, 0, cDisplay, cColor )

    /* position cursor if focused */
    IF ::hasFocus()
        nCursorCol := ::FcursorPos - ::FdispOffset
        SetPos( 0, nCursorCol )
    ENDIF

RETURN

/*
    keyEvent
*/
METHOD PROCEDURE keyEvent( keyEvent ) CLASS HTLineEdit

    LOCAL parent
    LOCAL cChar
    LOCAL lChanged := .F.

    SWITCH keyEvent:key
    CASE K_LEFT
        IF ::FcursorPos > 1
            ::FcursorPos--
        ENDIF
        EXIT
    CASE K_RIGHT
        IF ::FcursorPos <= Len( ::Ftext )
            ::FcursorPos++
        ENDIF
        EXIT
    CASE K_HOME
        ::FcursorPos := 1
        EXIT
    CASE K_END
        ::FcursorPos := Len( ::Ftext ) + 1
        EXIT
    CASE K_BS
        IF ::FcursorPos > 1
            ::Ftext := Left( ::Ftext, ::FcursorPos - 2 ) + SubStr( ::Ftext, ::FcursorPos )
            ::FcursorPos--
            lChanged := .T.
        ENDIF
        EXIT
    CASE K_DEL
        IF ::FcursorPos <= Len( ::Ftext )
            ::Ftext := Left( ::Ftext, ::FcursorPos - 1 ) + SubStr( ::Ftext, ::FcursorPos + 1 )
            lChanged := .T.
        ENDIF
        EXIT
    OTHERWISE
        /* printable character */
        cChar := hb_keyChar( keyEvent:key )
        IF Len( cChar ) = 1 .AND. hb_asciiUpper( Asc( cChar ) ) >= 32
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

/*
    mouseEvent
*/
METHOD PROCEDURE mouseEvent( eventMouse ) CLASS HTLineEdit

    LOCAL nClickCol, parent

    IF eventMouse:nKey = K_LBUTTONDOWN
        nClickCol := eventMouse:mouseCol - 1 - ::Fx
        IF nClickCol >= 0
            ::FcursorPos := Min( ::FdispOffset + nClickCol, Len( ::Ftext ) + 1 )
            parent := ::parent()
            IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
                parent:repaintChild( self )
            ENDIF
        ENDIF
    ENDIF

RETURN

/*
    setText
*/
METHOD PROCEDURE setText( text ) CLASS HTLineEdit
    ::Ftext := text
    ::FcursorPos := Len( text ) + 1
RETURN
