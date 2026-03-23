/** @class HTScrollBar
 * Standalone scrollbar with proportional thumb. Responds to mouse clicks and wheel.
 * Does not accept focus.
 * @extends HTWidget
 */

#include "hbtui.ch"
#include "inkey.ch"

#define _SB_ORIENT_VERTICAL     0
#define _SB_ORIENT_HORIZONTAL   1

#define _SB_CHAR_TRACK   e"\xB0"
#define _SB_CHAR_THUMB   e"\xDB"

CLASS HTScrollBar FROM HTWidget

PROTECTED:

    DATA FnValue     INIT 0
    DATA FnMinimum   INIT 0
    DATA FnMaximum   INIT 100
    DATA FnPageStep  INIT 10

PUBLIC:

    CONSTRUCTOR new( parent )

    METHOD paintEvent( event )
    METHOD mouseEvent( eventMouse )

    METHOD setValue( n )
    METHOD setMinimum( n )
    METHOD setMaximum( n )
    METHOD setPageStep( n )

    PROPERTY value WRITE setValue INIT 0
    PROPERTY minimum WRITE setMinimum INIT 0
    PROPERTY maximum WRITE setMaximum INIT 100
    PROPERTY pageStep WRITE setPageStep INIT 10
    PROPERTY orientation INIT _SB_ORIENT_VERTICAL
    PROPERTY onValueChanged READWRITE            /* {|nValue| ... } */

ENDCLASS

/** Creates a new vertical scrollbar with optional parent. */
METHOD new( parent ) CLASS HTScrollBar

    ::super:new( parent )
    ::setFocusPolicy( HT_FOCUS_NONE )
    ::FisVisible := .T.
    ::Fheight := 10
    ::Fwidth := 1

RETURN self

/** Renders the track and proportional thumb indicator.
 * @param event HTPaintEvent (unused)
 */
METHOD PROCEDURE paintEvent( event ) CLASS HTScrollBar

    LOCAL nTrackLen, nThumbPos, nThumbSize
    LOCAL nRange, i
    LOCAL cColor := HTTheme():getColor( HT_CLR_SCROLLBAR )

    HB_SYMBOL_UNUSED( event )

    IF ::Forientation = _SB_ORIENT_VERTICAL

        nTrackLen := MaxRow() + 1
        IF nTrackLen <= 0
            RETURN
        ENDIF

        nRange := ::FnMaximum - ::FnMinimum
        IF nRange <= 0
            /* no range: fill with track */
            FOR i := 0 TO nTrackLen - 1
                DispOutAt( i, 0, _SB_CHAR_TRACK, cColor )
            NEXT
            RETURN
        ENDIF

        /* calculate thumb size (proportional to pageStep/range) */
        nThumbSize := Max( 1, Int( nTrackLen * ::FnPageStep / ( nRange + ::FnPageStep ) ) )
        nThumbSize := Min( nThumbSize, nTrackLen )

        /* calculate thumb position */
        nThumbPos := Int( ( ::FnValue - ::FnMinimum ) * ( nTrackLen - nThumbSize ) / nRange )
        nThumbPos := Max( 0, Min( nThumbPos, nTrackLen - nThumbSize ) )

        /* draw track */
        FOR i := 0 TO nTrackLen - 1
            IF i >= nThumbPos .AND. i < nThumbPos + nThumbSize
                DispOutAt( i, 0, _SB_CHAR_THUMB, cColor )
            ELSE
                DispOutAt( i, 0, _SB_CHAR_TRACK, cColor )
            ENDIF
        NEXT

    ELSE
        /* horizontal */
        nTrackLen := MaxCol() + 1
        IF nTrackLen <= 0
            RETURN
        ENDIF

        nRange := ::FnMaximum - ::FnMinimum
        IF nRange <= 0
            DispOutAt( 0, 0, Replicate( _SB_CHAR_TRACK, nTrackLen ), cColor )
            RETURN
        ENDIF

        nThumbSize := Max( 1, Int( nTrackLen * ::FnPageStep / ( nRange + ::FnPageStep ) ) )
        nThumbSize := Min( nThumbSize, nTrackLen )

        nThumbPos := Int( ( ::FnValue - ::FnMinimum ) * ( nTrackLen - nThumbSize ) / nRange )
        nThumbPos := Max( 0, Min( nThumbPos, nTrackLen - nThumbSize ) )

        FOR i := 0 TO nTrackLen - 1
            IF i >= nThumbPos .AND. i < nThumbPos + nThumbSize
                DispOutAt( 0, i, _SB_CHAR_THUMB, cColor )
            ELSE
                DispOutAt( 0, i, _SB_CHAR_TRACK, cColor )
            ENDIF
        NEXT

    ENDIF

RETURN

/** Handles click-to-position and mouse wheel scrolling.
 * @param eventMouse HTMouseEvent
 */
METHOD PROCEDURE mouseEvent( eventMouse ) CLASS HTScrollBar

    LOCAL nTrackLen, nRange, nClickPos, nNewValue, nThumbSize
    LOCAL parent
    LOCAL nOldValue := ::FnValue

    nRange := ::FnMaximum - ::FnMinimum
    IF nRange <= 0
        RETURN
    ENDIF

    SWITCH eventMouse:nKey
    CASE K_LBUTTONDOWN
        /* click-to-position */
        IF ::Forientation = _SB_ORIENT_VERTICAL
            nTrackLen := ::Fheight
            nClickPos := eventMouse:mouseRow
        ELSE
            nTrackLen := ::Fwidth
            nClickPos := eventMouse:mouseCol
        ENDIF

        IF nTrackLen > 0 .AND. nClickPos >= 0
            nThumbSize := Max( 1, Int( nTrackLen * ::FnPageStep / ( nRange + ::FnPageStep ) ) )
            nNewValue := ::FnMinimum + Int( nClickPos * nRange / Max( 1, nTrackLen - nThumbSize ) )
            ::setValue( nNewValue )
        ENDIF
        EXIT

    CASE K_MWFORWARD
        ::setValue( ::FnValue - ::FnPageStep )
        EXIT

    CASE K_MWBACKWARD
        ::setValue( ::FnValue + ::FnPageStep )
        EXIT

    OTHERWISE
        RETURN
    ENDSWITCH

    IF ::FnValue != nOldValue .AND. ::FonValueChanged != NIL
        Eval( ::FonValueChanged, ::FnValue )
    ENDIF

    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:repaintChild( self )
    ENDIF

RETURN

/** Sets the scrollbar value, clamped to min/max range.
 * @param n New value
 */
METHOD PROCEDURE setValue( n ) CLASS HTScrollBar
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
METHOD PROCEDURE setMinimum( n ) CLASS HTScrollBar
    ::FnMinimum := n
    ::Fminimum  := n
    IF ::FnValue < n
        ::FnValue := n
        ::Fvalue  := n
    ENDIF
RETURN

/** Sets the maximum value. Adjusts current value if above new maximum.
 * @param n New maximum
 */
METHOD PROCEDURE setMaximum( n ) CLASS HTScrollBar
    ::FnMaximum := n
    ::Fmaximum  := n
    IF ::FnValue > n
        ::FnValue := n
        ::Fvalue  := n
    ENDIF
RETURN

/** Sets the page step size used for page-up/down scrolling.
 * @param n New page step value (must be >= 1)
 */
METHOD PROCEDURE setPageStep( n ) CLASS HTScrollBar
    ::FnPageStep := n
    ::FpageStep  := n
RETURN
