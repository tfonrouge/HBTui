/** @class HTSpinner
 * Numeric input with Up/Down arrow increment/decrement and direct digit entry.
 * @extends HTWidget
 */

#include "hbtui.ch"
#include "inkey.ch"


CLASS HTSpinner FROM HTWidget

PROTECTED:

    DATA FnValue     INIT 0
    DATA FnMinimum   INIT 0
    DATA FnMaximum   INIT 100
    DATA FnStep      INIT 1
    DATA FcLabel     INIT ""
    DATA FnLabelWidth INIT 0
    DATA FcDigitBuf  INIT ""

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD paintEvent( event )
    METHOD keyEvent( keyEvent )
    METHOD mouseEvent( eventMouse )

    METHOD setup( cLabel, nMin, nMax, nStep, nInitial )
    METHOD setValue( n )
    METHOD setMinimum( n )
    METHOD setMaximum( n )

    PROPERTY value WRITE setValue INIT 0
    PROPERTY minimum WRITE setMinimum INIT 0
    PROPERTY maximum WRITE setMaximum INIT 100
    PROPERTY step INIT 1
    PROPERTY onChanged READWRITE                 /* {|nValue| ... } */

HIDDEN:

    METHOD applyDigitBuf()

ENDCLASS

/** Creates a new spinner with optional parent widget. */
METHOD new( ... ) CLASS HTSpinner

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
    ::Fwidth := 20

RETURN self

/** Configures the spinner label, range, step, and initial value.
 * @param cLabel Label text displayed before the value box
 * @param nMin Minimum allowed value
 * @param nMax Maximum allowed value
 * @param nStep Increment/decrement step size
 * @param nInitial Initial value
 */
METHOD PROCEDURE setup( cLabel, nMin, nMax, nStep, nInitial ) CLASS HTSpinner

    IF cLabel != NIL
        ::FcLabel := cLabel
        ::FnLabelWidth := Len( cLabel ) + 2
    ENDIF
    IF nMin != NIL
        ::FnMinimum := nMin
        ::Fminimum := nMin
    ENDIF
    IF nMax != NIL
        ::FnMaximum := nMax
        ::Fmaximum := nMax
    ENDIF
    IF nStep != NIL
        ::FnStep := nStep
        ::Fstep := nStep
    ENDIF
    IF nInitial != NIL
        ::setValue( nInitial )
    ENDIF

RETURN

/** Renders the label and value box with up/down arrow indicators.
 * @param event HTPaintEvent (unused)
 */
METHOD PROCEDURE paintEvent( event ) CLASS HTSpinner

    LOCAL cDisplay, cColor, cValueStr, nBoxWidth, cBox, cLabel

    HB_SYMBOL_UNUSED( event )

    cColor := IIF( ::hasFocus(), HTTheme():getColor( HT_CLR_SPINNER_FOCUSED ), HTTheme():getColor( HT_CLR_SPINNER_NORMAL ) )

    /* build label portion */
    cLabel := ""
    IF ! Empty( ::FcLabel )
        cLabel := ::FcLabel + ": "
    ENDIF

    /* build value box: right-justified value with arrows */
    nBoxWidth := MaxCol() + 1 - Len( cLabel )
    IF nBoxWidth < 5
        nBoxWidth := 5
    ENDIF

    cValueStr := LTrim( Str( ::FnValue ) )
    cBox := "[" + PadL( cValueStr, nBoxWidth - 5 ) + " " + Chr( 30 ) + Chr( 31 ) + "]"

    cDisplay := cLabel + cBox
    IF Len( cDisplay ) > MaxCol() + 1
        cDisplay := Left( cDisplay, MaxCol() + 1 )
    ENDIF

    DispOutAt( 0, 0, cDisplay, cColor )

RETURN

/** Handles Up/Down/Home/End keys and direct digit entry.
 * @param keyEvent HTKeyEvent
 */
METHOD PROCEDURE keyEvent( keyEvent ) CLASS HTSpinner

    LOCAL parent
    LOCAL lChanged := .F.
    LOCAL nOldValue := ::FnValue
    LOCAL cChar

    SWITCH keyEvent:key
    CASE K_UP
        ::applyDigitBuf()
        IF ::FnValue + ::FnStep <= ::FnMaximum
            ::FnValue := ::FnValue + ::FnStep
        ELSE
            ::FnValue := ::FnMaximum
        ENDIF
        ::Fvalue := ::FnValue
        lChanged := ( ::FnValue != nOldValue )
        EXIT
    CASE K_DOWN
        ::applyDigitBuf()
        IF ::FnValue - ::FnStep >= ::FnMinimum
            ::FnValue := ::FnValue - ::FnStep
        ELSE
            ::FnValue := ::FnMinimum
        ENDIF
        ::Fvalue := ::FnValue
        lChanged := ( ::FnValue != nOldValue )
        EXIT
    CASE K_HOME
        ::applyDigitBuf()
        ::FnValue := ::FnMinimum
        ::Fvalue := ::FnValue
        lChanged := ( ::FnValue != nOldValue )
        EXIT
    CASE K_END
        ::applyDigitBuf()
        ::FnValue := ::FnMaximum
        ::Fvalue := ::FnValue
        lChanged := ( ::FnValue != nOldValue )
        EXIT
    OTHERWISE
        cChar := hb_keyChar( keyEvent:key )
        IF Len( cChar ) = 1 .AND. cChar >= "0" .AND. cChar <= "9"
            ::FcDigitBuf += cChar
        ELSEIF ! Empty( ::FcDigitBuf )
            ::applyDigitBuf()
            lChanged := ( ::FnValue != nOldValue )
        ELSE
            RETURN
        ENDIF
    ENDSWITCH

    keyEvent:accept()

    IF lChanged .AND. ::FonChanged != NIL
        Eval( ::FonChanged, ::FnValue )
    ENDIF

    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:repaintChild( self )
    ENDIF

RETURN

/** Handles mouse wheel scrolling to increment/decrement value.
 * @param eventMouse HTMouseEvent
 */
METHOD PROCEDURE mouseEvent( eventMouse ) CLASS HTSpinner

    LOCAL parent
    LOCAL nOldValue := ::FnValue

    SWITCH eventMouse:nKey
    CASE K_LBUTTONDOWN
        /* check if click landed on up/down arrows (last 2 chars before ']') */
        IF eventMouse:mouseCol = ::Fwidth - 3  /* up arrow */
            IF ::FnValue + ::FnStep <= ::FnMaximum
                ::FnValue := ::FnValue + ::FnStep
            ELSE
                ::FnValue := ::FnMaximum
            ENDIF
            ::Fvalue := ::FnValue
        ELSEIF eventMouse:mouseCol = ::Fwidth - 2  /* down arrow */
            IF ::FnValue - ::FnStep >= ::FnMinimum
                ::FnValue := ::FnValue - ::FnStep
            ELSE
                ::FnValue := ::FnMinimum
            ENDIF
            ::Fvalue := ::FnValue
        ENDIF
        EXIT
    CASE K_MWFORWARD
        IF ::FnValue + ::FnStep <= ::FnMaximum
            ::FnValue := ::FnValue + ::FnStep
        ELSE
            ::FnValue := ::FnMaximum
        ENDIF
        ::Fvalue := ::FnValue
        EXIT
    CASE K_MWBACKWARD
        IF ::FnValue - ::FnStep >= ::FnMinimum
            ::FnValue := ::FnValue - ::FnStep
        ELSE
            ::FnValue := ::FnMinimum
        ENDIF
        ::Fvalue := ::FnValue
        EXIT
    OTHERWISE
        RETURN
    ENDSWITCH

    IF ::FnValue != nOldValue .AND. ::FonChanged != NIL
        Eval( ::FonChanged, ::FnValue )
    ENDIF

    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:repaintChild( self )
    ENDIF

RETURN

/** Sets the value, clamping to the min/max range.
 * @param n New numeric value
 */
METHOD PROCEDURE setValue( n ) CLASS HTSpinner

    IF n < ::FnMinimum
        n := ::FnMinimum
    ENDIF
    IF n > ::FnMaximum
        n := ::FnMaximum
    ENDIF
    ::FnValue := n
    ::Fvalue := n

RETURN

/** Sets the minimum value. Adjusts current value if below new minimum.
 * @param n New minimum
 */
METHOD PROCEDURE setMinimum( n ) CLASS HTSpinner

    ::FnMinimum := n
    IF ::FnValue < n
        ::FnValue := n
        ::Fvalue := n
    ENDIF

RETURN

/** Sets the maximum value. Adjusts current value if above new maximum.
 * @param n New maximum
 */
METHOD PROCEDURE setMaximum( n ) CLASS HTSpinner

    ::FnMaximum := n
    IF ::FnValue > n
        ::FnValue := n
        ::Fvalue := n
    ENDIF

RETURN

/** Applies the accumulated digit buffer as a new value, clamped to range. */
METHOD PROCEDURE applyDigitBuf() CLASS HTSpinner

    LOCAL nNew

    IF ! Empty( ::FcDigitBuf )
        nNew := Val( ::FcDigitBuf )
        ::FcDigitBuf := ""
        ::setValue( nNew )
    ENDIF

RETURN
