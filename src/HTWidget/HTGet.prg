/*
 * HTGet - Combined Label + LineEdit widget with PICTURE clause support
 * Arel ERP compatible GET widget
 */

#include "hbtui.ch"
#include "inkey.ch"

#define _GET_COLOR_LABEL    "00/07"
#define _GET_COLOR_NORMAL   "N/W"
#define _GET_COLOR_FOCUSED  "N/BG"
#define _GET_COLOR_READONLY "N+/W"

CLASS HTGet FROM HTWidget

PROTECTED:

    DATA FcursorPos  INIT 1
    DATA FdispOffset INIT 1

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD paintEvent( event )
    METHOD keyEvent( keyEvent )
    METHOD mouseEvent( eventMouse )
    METHOD focusOutEvent( eventFocus )

    METHOD setup( xVar, cLabel, cPicture, bValid, bWhen, cHelpLine, bOnChange, lReadOnly, lHide, nWidth )
    METHOD getValue()
    METHOD setValue( x )

    PROPERTY label WRITE setLabel INIT ""
    PROPERTY picture WRITE setPicture INIT ""
    PROPERTY xVar WRITE setXVar                     /* {|x| IIF( x == NIL, cValue, cValue := x ) } */
    PROPERTY valid                                   /* {|xValue| lOk } */
    PROPERTY when                                    /* {|| lEnabled } */
    PROPERTY helpLine INIT ""
    PROPERTY onChange                                 /* {|xValue| ... } */
    PROPERTY readOnly WRITE setReadOnly INIT .F.
    PROPERTY hide INIT .F.                           /* password mode */
    PROPERTY labelWidth WRITE setLabelWidth INIT 0
    PROPERTY inputWidth INIT 0

ENDCLASS

/*
    new
*/
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

/*
    setup
*/
METHOD PROCEDURE setup( xVar, cLabel, cPicture, bValid, bWhen, cHelpLine, bOnChange, lReadOnly, lHide, nWidth ) CLASS HTGet

    LOCAL cValue

    DEFAULT cLabel    := ""
    DEFAULT cPicture  := ""
    DEFAULT cHelpLine := ""
    DEFAULT lReadOnly := .F.
    DEFAULT lHide     := .F.
    DEFAULT nWidth    := 30

    ::FxVar     := xVar
    ::Flabel    := cLabel
    ::Fpicture  := cPicture
    ::Fvalid    := bValid
    ::Fwhen     := bWhen
    ::FhelpLine := cHelpLine
    ::FonChange := bOnChange
    ::FreadOnly := lReadOnly
    ::Fhide     := lHide

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

    /* position cursor at end of current value */
    IF ::FxVar != NIL
        cValue := ::getValue()
        IF hb_isString( cValue )
            ::FcursorPos := Len( RTrim( cValue ) ) + 1
        ELSE
            ::FcursorPos := 1
        ENDIF
    ENDIF

RETURN

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( event ) CLASS HTGet

    LOCAL cDisplay, cColor, cValue, cTransformed
    LOCAL nVisibleWidth
    LOCAL nCursorCol
    LOCAL nMaxCol := MaxCol()

    HB_SYMBOL_UNUSED( event )

    /* draw label at (0, 0) */
    IF ::FlabelWidth > 0
        DispOutAt( 0, 0, PadR( ::Flabel, ::FlabelWidth ), _GET_COLOR_LABEL )
    ENDIF

    /* determine input color */
    IF ::FreadOnly
        cColor := _GET_COLOR_READONLY
    ELSEIF ::hasFocus()
        cColor := _GET_COLOR_FOCUSED
    ELSE
        cColor := _GET_COLOR_NORMAL
    ENDIF

    /* get display value */
    cValue := ::getValue()

    IF cValue == NIL
        cValue := ""
    ENDIF

    /* apply PICTURE transformation */
    IF Len( ::Fpicture ) > 0
        cTransformed := Transform( cValue, ::Fpicture )
    ELSEIF hb_isString( cValue )
        cTransformed := cValue
    ELSE
        cTransformed := hb_CStr( cValue )
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
    IF ::FcursorPos < ::FdispOffset
        ::FdispOffset := ::FcursorPos
    ENDIF
    IF ::FcursorPos > ::FdispOffset + nVisibleWidth - 1
        ::FdispOffset := ::FcursorPos - nVisibleWidth + 1
    ENDIF

    /* extract visible portion of text */
    cDisplay := PadR( SubStr( cTransformed, ::FdispOffset ), nVisibleWidth )

    DispOutAt( 0, ::FlabelWidth, cDisplay, cColor )

    /* position cursor if focused */
    IF ::hasFocus() .AND. ! ::FreadOnly
        nCursorCol := ::FlabelWidth + ::FcursorPos - ::FdispOffset
        SetPos( 0, nCursorCol )
    ENDIF

RETURN

/*
    keyEvent
*/
METHOD PROCEDURE keyEvent( keyEvent ) CLASS HTGet

    LOCAL parent
    LOCAL cChar, cValue
    LOCAL lChanged := .F.
    LOCAL lWhenOk

    /* check WHEN condition */
    IF ::FreadOnly
        RETURN
    ENDIF

    IF ::Fwhen != NIL
        lWhenOk := Eval( ::Fwhen )
        IF ! lWhenOk
            RETURN
        ENDIF
    ENDIF

    cValue := ::getValue()
    IF cValue == NIL
        cValue := ""
    ENDIF
    IF ! hb_isString( cValue )
        cValue := hb_CStr( cValue )
    ENDIF

    SWITCH keyEvent:key
    CASE K_LEFT
        IF ::FcursorPos > 1
            ::FcursorPos--
        ENDIF
        EXIT
    CASE K_RIGHT
        IF ::FcursorPos <= Len( cValue )
            ::FcursorPos++
        ENDIF
        EXIT
    CASE K_HOME
        ::FcursorPos := 1
        EXIT
    CASE K_END
        ::FcursorPos := Len( RTrim( cValue ) ) + 1
        EXIT
    CASE K_BS
        IF ::FcursorPos > 1
            cValue := Left( cValue, ::FcursorPos - 2 ) + SubStr( cValue, ::FcursorPos )
            ::FcursorPos--
            ::setValue( cValue )
            lChanged := .T.
        ENDIF
        EXIT
    CASE K_DEL
        IF ::FcursorPos <= Len( cValue )
            cValue := Left( cValue, ::FcursorPos - 1 ) + SubStr( cValue, ::FcursorPos + 1 )
            ::setValue( cValue )
            lChanged := .T.
        ENDIF
        EXIT
    OTHERWISE
        /* printable character */
        cChar := hb_keyChar( keyEvent:key )
        IF Len( cChar ) = 1 .AND. hb_asciiUpper( Asc( cChar ) ) >= 32
            /* apply PICTURE mask character filtering */
            IF ! ::isCharAllowed( cChar )
                RETURN
            ENDIF
            cValue := Left( cValue, ::FcursorPos - 1 ) + cChar + SubStr( cValue, ::FcursorPos )
            ::FcursorPos++
            ::setValue( cValue )
            lChanged := .T.
        ELSE
            RETURN
        ENDIF
    ENDSWITCH

    keyEvent:accept()

    IF lChanged .AND. ::FonChange != NIL
        Eval( ::FonChange, ::getValue() )
    ENDIF

    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:repaintChild( self )
    ENDIF

RETURN

/*
    mouseEvent
*/
METHOD PROCEDURE mouseEvent( eventMouse ) CLASS HTGet

    LOCAL nClickCol, parent

    IF eventMouse:nKey = K_LBUTTONDOWN
        nClickCol := eventMouse:mouseCol - 1 - ::Fx

        /* only react to clicks on the input area */
        IF nClickCol >= ::FlabelWidth
            nClickCol := nClickCol - ::FlabelWidth
            ::FcursorPos := Min( ::FdispOffset + nClickCol, Len( RTrim( hb_CStr( ::getValue() ) ) ) + 1 )
            parent := ::parent()
            IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
                parent:repaintChild( self )
            ENDIF
        ENDIF
    ENDIF

RETURN

/*
    focusOutEvent
    Validate on losing focus
*/
METHOD PROCEDURE focusOutEvent( eventFocus ) CLASS HTGet

    LOCAL xValue

    /* run post-validation */
    IF ::Fvalid != NIL
        xValue := ::getValue()
        Eval( ::Fvalid, xValue )
    ENDIF

    ::super:focusOutEvent( eventFocus )

RETURN

/*
    getValue
*/
METHOD FUNCTION getValue() CLASS HTGet

    IF ::FxVar != NIL
        RETURN Eval( ::FxVar )
    ENDIF

RETURN ""

/*
    setValue
*/
METHOD PROCEDURE setValue( x ) CLASS HTGet

    IF ::FxVar != NIL
        Eval( ::FxVar, x )
    ENDIF

RETURN

/*
    setLabel
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

/*
    setPicture
*/
METHOD PROCEDURE setPicture( cPicture ) CLASS HTGet
    ::Fpicture := cPicture
RETURN

/*
    setXVar
*/
METHOD PROCEDURE setXVar( xVar ) CLASS HTGet
    ::FxVar := xVar
RETURN

/*
    setReadOnly
*/
METHOD PROCEDURE setReadOnly( lReadOnly ) CLASS HTGet
    ::FreadOnly := lReadOnly
RETURN

/*
    setLabelWidth
*/
METHOD PROCEDURE setLabelWidth( nWidth ) CLASS HTGet

    ::FlabelWidth := nWidth
    ::FinputWidth := ::Fwidth - ::FlabelWidth
    IF ::FinputWidth < 1
        ::FinputWidth := 1
    ENDIF

RETURN

/*
    isCharAllowed
    Apply PICTURE character mask filtering
    Returns .T. if the character is allowed at current cursor position
*/
METHOD FUNCTION isCharAllowed( cChar ) CLASS HTGet

    LOCAL cMask, cMaskChar
    LOCAL nFuncEnd, cFunc, cTemplate
    LOCAL nPos

    IF Len( ::Fpicture ) = 0
        RETURN .T.
    ENDIF

    /* separate function string from template */
    cFunc := ""
    cTemplate := ::Fpicture

    IF Left( cTemplate, 1 ) == "@"
        nFuncEnd := At( " ", cTemplate )
        IF nFuncEnd > 0
            cFunc := SubStr( cTemplate, 2, nFuncEnd - 2 )
            cTemplate := SubStr( cTemplate, nFuncEnd + 1 )
        ELSE
            cFunc := SubStr( cTemplate, 2 )
            cTemplate := ""
        ENDIF
    ENDIF

    /* function-level checks */
    IF "!" $ cFunc
        /* force uppercase - allow all, will be uppercased */
        RETURN .T.
    ENDIF

    /* template-level checks */
    IF Len( cTemplate ) = 0
        RETURN .T.
    ENDIF

    nPos := ::FcursorPos
    IF nPos > Len( cTemplate )
        RETURN .T.
    ENDIF

    cMask := cTemplate
    cMaskChar := SubStr( cMask, nPos, 1 )

    SWITCH cMaskChar
    CASE "A"
        /* alpha only */
        RETURN IsAlpha( cChar )
    CASE "N"
        /* alpha, digit, space */
        RETURN IsAlpha( cChar ) .OR. IsDigit( cChar ) .OR. cChar == " "
    CASE "9"
        /* digit, sign */
        RETURN IsDigit( cChar ) .OR. cChar == "-" .OR. cChar == "+"
    CASE "#"
        /* digit, sign, space */
        RETURN IsDigit( cChar ) .OR. cChar == "-" .OR. cChar == "+" .OR. cChar == " "
    CASE "L"
        /* logical: T/F/Y/N */
        RETURN Upper( cChar ) $ "TFYN"
    CASE "Y"
        /* logical: Y/N */
        RETURN Upper( cChar ) $ "YN"
    CASE "!"
        /* force uppercase, any char */
        RETURN .T.
    CASE "X"
        /* any character */
        RETURN .T.
    OTHERWISE
        /* literal character in template - skip */
        RETURN .T.
    ENDSWITCH

RETURN .T.

/*
    EndClass
*/
