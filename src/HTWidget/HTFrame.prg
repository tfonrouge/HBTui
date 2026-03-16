/*
 * HTFrame - Decorative frame/group box with title
 */

#include "hbtui.ch"
#include "inkey.ch"

CLASS HTFrame FROM HTWidget

PROTECTED:

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD paintEvent( paintEvent )
    METHOD setTitle( cTitle )

    PROPERTY title WRITE setTitle INIT ""

ENDCLASS

/*
    new
*/
METHOD new( ... ) CLASS HTFrame

    LOCAL version := 0
    LOCAL cTitle
    LOCAL parent

    SWITCH pCount()
    CASE 2
        cTitle := hb_pValue( 1 )
        parent := hb_pValue( 2 )
        IF hb_isString( cTitle ) .AND. ( parent = NIL .OR. hb_isObject( parent ) )
            version := 1
        ENDIF
        EXIT
    CASE 1
        IF hb_isString( hb_pValue( 1 ) )
            cTitle := hb_pValue( 1 )
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
        IF cTitle != NIL
            ::Ftitle := cTitle
        ENDIF
        ::setFocusPolicy( HT_FOCUS_NONE )
        ::FisVisible := .T.
        ::Fheight := 5
        ::Fwidth := 20
    ELSE
        ::PARAM_ERROR()
    ENDIF

RETURN self

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HTFrame

    LOCAL nMaxRow := MaxRow()
    LOCAL nMaxCol := MaxCol()
    LOCAL cTitle := ::Ftitle

    HB_SYMBOL_UNUSED( paintEvent )

    /* draw the box border */
    DispBox( 0, 0, nMaxRow, nMaxCol, , ::color )

    /* draw title in the top-left if provided */
    IF Len( cTitle ) > 0
        IF Len( cTitle ) > nMaxCol - 3
            cTitle := Left( cTitle, nMaxCol - 3 )
        ENDIF
        DispOutAt( 0, 2, cTitle, ::color )
    ENDIF

RETURN

/*
    setTitle
*/
METHOD PROCEDURE setTitle( cTitle ) CLASS HTFrame
    ::Ftitle := cTitle
RETURN
