/*
 * HTStatusBar - Status bar with sections
 */

#include "hbtui.ch"
#include "inkey.ch"

#define _STATUSBAR_COLOR "00/07"

CLASS HTStatusBar FROM HTWidget

PROTECTED:

    DATA Fsections INIT {}

PUBLIC:

    CONSTRUCTOR new( parent )

    METHOD paintEvent( paintEvent )
    METHOD setSection( nIndex, cText )
    METHOD addSection( cText )
    METHOD sectionCount() INLINE Len( ::Fsections )

ENDCLASS

/*
    new
*/
METHOD new( parent ) CLASS HTStatusBar

    IF parent != NIL
        ::super:new( parent )
    ELSE
        ::super:new()
    ENDIF

    ::setFocusPolicy( HT_FOCUS_NONE )
    ::FisVisible := .T.
    ::Fheight := 1
    ::Fwidth := 40
    ::Fcolor := _STATUSBAR_COLOR

RETURN self

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HTStatusBar

    LOCAL nMaxCol := MaxCol()
    LOCAL nBarWidth := nMaxCol + 1
    LOCAL cBar
    LOCAL i
    LOCAL nCount := Len( ::Fsections )

    HB_SYMBOL_UNUSED( paintEvent )

    IF nCount = 0
        DispOutAt( 0, 0, Space( nBarWidth ), ::color )
        RETURN
    ENDIF

    cBar := ""
    FOR i := 1 TO nCount
        IF i > 1
            cBar += e"\xB3"
        ENDIF
        cBar += ::Fsections[ i ]
    NEXT

    cBar := PadR( cBar, nBarWidth )

    DispOutAt( 0, 0, cBar, ::color )

RETURN

/*
    setSection
*/
METHOD PROCEDURE setSection( nIndex, cText ) CLASS HTStatusBar

    LOCAL parent

    IF nIndex >= 1 .AND. nIndex <= Len( ::Fsections )
        ::Fsections[ nIndex ] := cText
        parent := ::parent()
        IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
            parent:repaintChild( self )
        ENDIF
    ENDIF

RETURN

/*
    addSection
*/
METHOD PROCEDURE addSection( cText ) CLASS HTStatusBar
    AAdd( ::Fsections, cText )
RETURN
