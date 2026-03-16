/*
 *
 */

#include "hbtui.ch"

CLASS HTGridLayout FROM HTLayout

PROTECTED:

    DATA FgridItems INIT {}

PUBLIC:

    CONSTRUCTOR new( parent )

    METHOD addWidget( widget, nRow, nCol, nRowSpan, nColSpan )
    METHOD doLayout( nWidth, nHeight )
    METHOD widgetList()

    PROPERTY rowCount INIT 0
    PROPERTY colCount INIT 0

ENDCLASS

/*
    new
*/
METHOD new( parent ) CLASS HTGridLayout
RETURN ::super:new( parent )

/*
    addWidget
*/
METHOD PROCEDURE addWidget( widget, nRow, nCol, nRowSpan, nColSpan ) CLASS HTGridLayout

    DEFAULT nRow := 0
    DEFAULT nCol := 0
    DEFAULT nRowSpan := 1
    DEFAULT nColSpan := 1

    AAdd( ::FgridItems, { widget, nRow, nCol, nRowSpan, nColSpan } )

    /* update row/col counts */
    IF nRow + nRowSpan > ::FrowCount
        ::FrowCount := nRow + nRowSpan
    ENDIF

    IF nCol + nColSpan > ::FcolCount
        ::FcolCount := nCol + nColSpan
    ENDIF

RETURN

/*
    doLayout - calculate positions for child widgets in a grid
*/
METHOD PROCEDURE doLayout( nWidth, nHeight ) CLASS HTGridLayout

    LOCAL item
    LOCAL nCellWidth
    LOCAL nCellHeight
    LOCAL nRow, nCol, nRowSpan, nColSpan
    LOCAL nX, nY, nW, nH

    IF Len( ::FgridItems ) = 0
        RETURN
    ENDIF

    IF ::FrowCount = 0 .OR. ::FcolCount = 0
        RETURN
    ENDIF

    nCellWidth  := Int( nWidth / ::FcolCount )
    nCellHeight := Int( nHeight / ::FrowCount )

    FOR EACH item IN ::FgridItems

        nRow     := item[ 2 ]
        nCol     := item[ 3 ]
        nRowSpan := item[ 4 ]
        nColSpan := item[ 5 ]

        nX := nCol * nCellWidth
        nY := nRow * nCellHeight

        /* last column/row gets remaining space */
        IF nCol + nColSpan >= ::FcolCount
            nW := nWidth - nX
        ELSE
            nW := nColSpan * nCellWidth
        ENDIF

        IF nRow + nRowSpan >= ::FrowCount
            nH := nHeight - nY
        ELSE
            nH := nRowSpan * nCellHeight
        ENDIF

        IF item[ 1 ]:isDerivedFrom( "HTWidget" )
            item[ 1 ]:Fx := nX
            item[ 1 ]:Fy := nY
            item[ 1 ]:Fwidth := nW
            item[ 1 ]:Fheight := nH
            item[ 1 ]:FisVisible := .T.
        ENDIF

    NEXT

RETURN

/*
    widgetList - returns flat array of widgets for displayLayout compatibility
*/
METHOD FUNCTION widgetList() CLASS HTGridLayout

    LOCAL aList := {}
    LOCAL item

    FOR EACH item IN ::FgridItems
        AAdd( aList, item[ 1 ] )
    NEXT

RETURN aList
