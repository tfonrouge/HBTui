/*
 *
 */

#include "hbtui.ch"

CLASS HTBoxLayout FROM HTLayout

PROTECTED:

    DATA FwidgetList INIT {}

PUBLIC:

    CONSTRUCTOR new( dir, parent )

    METHOD addWidget( w )
    METHOD doLayout( nWidth, nHeight )

    METHOD setDirection( dir )
    METHOD widgetList() INLINE ::FwidgetList

    PROPERTY direction WRITE setDirection

ENDCLASS

/*
    new
*/
METHOD new( dir, parent ) CLASS HTBoxLayout
    ::setDirection( dir )
RETURN ::super:new( parent )

/*
    addWidget
*/
METHOD PROCEDURE addWidget( w ) CLASS HTBoxLayout
    AAdd( ::FwidgetList, w )
RETURN

/*
    doLayout - calculate positions for child widgets
    direction 0 = horizontal, 2 = vertical
*/
METHOD PROCEDURE doLayout( nWidth, nHeight ) CLASS HTBoxLayout

    LOCAL w
    LOCAL nPos := 0
    LOCAL nCount := Len( ::FwidgetList )
    LOCAL nItemSize

    IF nCount = 0
        RETURN
    ENDIF

    IF ::Fdirection = 2
        /* vertical: stack widgets top to bottom */
        nItemSize := Int( nHeight / nCount )
        FOR EACH w IN ::FwidgetList
            IF w:isDerivedFrom( "HTWidget" )
                w:Fx := 0
                w:Fy := nPos
                w:Fwidth := nWidth
                w:Fheight := IIF( w:__enumIndex() = nCount, nHeight - nPos, nItemSize )
                w:FisVisible := .T.
                nPos += w:Fheight
            ENDIF
        NEXT
    ELSE
        /* horizontal: stack widgets left to right */
        nItemSize := Int( nWidth / nCount )
        FOR EACH w IN ::FwidgetList
            IF w:isDerivedFrom( "HTWidget" )
                w:Fx := nPos
                w:Fy := 0
                w:Fwidth := IIF( w:__enumIndex() = nCount, nWidth - nPos, nItemSize )
                w:Fheight := nHeight
                w:FisVisible := .T.
                nPos += w:Fwidth
            ENDIF
        NEXT
    ENDIF

RETURN

/*
    setDirection
*/
METHOD PROCEDURE setDirection( dir ) CLASS HTBoxLayout
    ::Fdirection := dir
RETURN
