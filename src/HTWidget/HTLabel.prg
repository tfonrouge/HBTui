/** @class HTLabel
 * Static text display with left, center, or right alignment.
 * @extends HTWidget
 */

#include "hbtui.ch"

CLASS HTLabel FROM HTWidget

PROTECTED:

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD paintEvent( paintEvent )
    METHOD setText( text )

    PROPERTY alignment INIT HT_ALIGN_LEFT
    PROPERTY text INIT ""

ENDCLASS

/** Creates a new label. Accepts optional text and/or parent widget. */
METHOD new( ... ) CLASS HTLabel

    LOCAL version := 0
    LOCAL text
    LOCAL parent

    SWITCH pCount()
    CASE 2
        text := hb_pValue( 1 )
        parent := hb_pValue( 2 )
        IF hb_isString( text ) .AND. ( parent = NIL .OR. hb_isObject( parent ) )
            version := 1
        ENDIF
        EXIT
    CASE 1
        IF hb_isString( hb_pValue( 1 ) )
            text := hb_pValue( 1 )
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
        IF text != NIL
            ::Ftext := text
        ENDIF
        ::Fheight := 1
        ::Fwidth := Len( ::Ftext )
        ::FisVisible := .T.
    ELSE
        ::PARAM_ERROR()
    ENDIF

RETURN self

/** Renders the label text with the configured alignment.
 * @param paintEvent HTPaintEvent (unused)
 */
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HTLabel

    LOCAL cDisplay
    LOCAL nMaxCol := MaxCol()

    HB_SYMBOL_UNUSED( paintEvent )

    cDisplay := ::Ftext

    /* truncate if wider than viewport */
    IF Len( cDisplay ) > nMaxCol + 1
        cDisplay := Left( cDisplay, nMaxCol + 1 )
    ENDIF

    /* apply alignment */
    SWITCH ::Falignment
    CASE HT_ALIGN_CENTER
        cDisplay := PadC( cDisplay, nMaxCol + 1 )
        EXIT
    CASE HT_ALIGN_RIGHT
        cDisplay := PadL( cDisplay, nMaxCol + 1 )
        EXIT
    OTHERWISE
        cDisplay := PadR( cDisplay, nMaxCol + 1 )
    ENDSWITCH

    DispOutAt( 0, 0, cDisplay, ::color )

RETURN

/** Sets the label text and adjusts widget width to match.
 * @param text New text string
 */
METHOD PROCEDURE setText( text ) CLASS HTLabel
    ::Ftext := text
    ::Fwidth := Len( text )
RETURN
