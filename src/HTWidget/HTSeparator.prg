/*
 * HTSeparator - Horizontal or vertical line separator
 */

#include "hbtui.ch"
#include "inkey.ch"

#define HT_SEPARATOR_HORIZONTAL  0
#define HT_SEPARATOR_VERTICAL    1

CLASS HTSeparator FROM HTWidget

PROTECTED:

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD paintEvent( paintEvent )
    METHOD setOrientation( n )

    PROPERTY orientation WRITE setOrientation INIT HT_SEPARATOR_HORIZONTAL

ENDCLASS

/*
    new
*/
METHOD new( ... ) CLASS HTSeparator

    LOCAL version := 0
    LOCAL nOrientation
    LOCAL parent

    SWITCH pCount()
    CASE 2
        nOrientation := hb_pValue( 1 )
        parent := hb_pValue( 2 )
        IF hb_isNumeric( nOrientation ) .AND. ( parent = NIL .OR. hb_isObject( parent ) )
            version := 1
        ENDIF
        EXIT
    CASE 1
        IF hb_isNumeric( hb_pValue( 1 ) )
            nOrientation := hb_pValue( 1 )
            version := 1
        ELSEIF hb_isObject( hb_pValue( 1 ) )
            parent := hb_pValue( 1 )
            version := 1
        ENDIF
        EXIT
    CASE 0
        version := 1
        EXIT
    ENDSWITCH

    IF version = 1
        ::super:new( parent )
        IF nOrientation != NIL
            ::Forientation := nOrientation
        ENDIF
        ::setFocusPolicy( HT_FOCUS_NONE )
        ::FisVisible := .T.
        IF ::Forientation = HT_SEPARATOR_VERTICAL
            ::Fheight := 5
            ::Fwidth := 1
        ELSE
            ::Fheight := 1
            ::Fwidth := 20
        ENDIF
    ELSE
        ::PARAM_ERROR()
    ENDIF

RETURN self

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HTSeparator

    LOCAL nMaxRow := MaxRow()
    LOCAL nMaxCol := MaxCol()
    LOCAL i
    LOCAL cLine

    HB_SYMBOL_UNUSED( paintEvent )

    IF ::Forientation = HT_SEPARATOR_VERTICAL
        FOR i := 0 TO nMaxRow
            DispOutAt( i, 0, e"\xB3", ::color )
        NEXT
    ELSE
        cLine := Replicate( e"\xC4", nMaxCol + 1 )
        DispOutAt( 0, 0, cLine, ::color )
    ENDIF

RETURN

/*
    setOrientation
*/
METHOD PROCEDURE setOrientation( n ) CLASS HTSeparator

    ::Forientation := n

    IF n = HT_SEPARATOR_VERTICAL
        ::Fheight := 5
        ::Fwidth := 1
    ELSE
        ::Fheight := 1
        ::Fwidth := 20
    ENDIF

RETURN
