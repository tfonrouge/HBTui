/** @class HTProgressBar
 * Progress bar that fills proportionally between minimum and maximum values.
 * @extends HTWidget
 */

#include "hbtui.ch"
#include "inkey.ch"

CLASS HTProgressBar FROM HTWidget

PROTECTED:

PUBLIC:

    CONSTRUCTOR new( parent )

    METHOD paintEvent( paintEvent )
    METHOD setValue( n )
    METHOD setRange( nMin, nMax )

    PROPERTY value WRITE setValue INIT 0
    PROPERTY minimum INIT 0
    PROPERTY maximum INIT 100

ENDCLASS

/** Creates a new progress bar with optional parent. */
METHOD new( parent ) CLASS HTProgressBar

    IF parent != NIL
        ::super:new( parent )
    ELSE
        ::super:new()
    ENDIF

    ::setFocusPolicy( HT_FOCUS_NONE )
    ::FisVisible := .T.
    ::Fheight := 1
    ::Fwidth := 20

RETURN self

/** Renders a filled/empty bar proportional to the current value within range.
 * @param paintEvent HTPaintEvent (unused)
 */
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HTProgressBar

    LOCAL nMaxCol := MaxCol()
    LOCAL nBarWidth := nMaxCol + 1
    LOCAL nRange
    LOCAL nFilled
    LOCAL cBar

    HB_SYMBOL_UNUSED( paintEvent )

    nRange := ::Fmaximum - ::Fminimum
    IF nRange <= 0
        nFilled := 0
    ELSE
        nFilled := Int( ( ::Fvalue - ::Fminimum ) * nBarWidth / nRange )
        IF nFilled < 0
            nFilled := 0
        ELSEIF nFilled > nBarWidth
            nFilled := nBarWidth
        ENDIF
    ENDIF

    cBar := Replicate( e"\xDB", nFilled ) + Replicate( e"\xB0", nBarWidth - nFilled )

    DispOutAt( 0, 0, cBar, ::color )

RETURN

/** Sets the progress value, clamped to range, and triggers repaint.
 * @param n New value
 */
METHOD PROCEDURE setValue( n ) CLASS HTProgressBar

    LOCAL parent

    IF n < ::Fminimum
        n := ::Fminimum
    ELSEIF n > ::Fmaximum
        n := ::Fmaximum
    ENDIF

    ::Fvalue := n

    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:repaintChild( self )
    ENDIF

RETURN

/** Sets the minimum and maximum range, clamping current value if needed.
 * @param nMin New minimum
 * @param nMax New maximum
 */
METHOD PROCEDURE setRange( nMin, nMax ) CLASS HTProgressBar

    ::Fminimum := nMin
    ::Fmaximum := nMax

    IF ::Fvalue < nMin
        ::Fvalue := nMin
    ELSEIF ::Fvalue > nMax
        ::Fvalue := nMax
    ENDIF

RETURN
