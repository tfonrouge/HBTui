/** @class HTGridLayout
 * Layout that arranges widgets in a 2D grid with row/column spans.
 * @extends HTLayout
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

/** Creates a new grid layout.
 * @param parent Optional parent HTWidget
 */
METHOD new( parent ) CLASS HTGridLayout
RETURN ::super:new( parent )

/** Adds a widget to the grid at the specified position.
 * @param widget The widget to add
 * @param nRow Row index (0-based)
 * @param nCol Column index (0-based)
 * @param nRowSpan Number of rows to span (default 1)
 * @param nColSpan Number of columns to span (default 1)
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

/** Calculates and assigns positions for all widgets in the grid.
 * @param nWidth Available width in characters
 * @param nHeight Available height in rows
 */
METHOD PROCEDURE doLayout( nWidth, nHeight ) CLASS HTGridLayout

    LOCAL item
    LOCAL nCellWidth
    LOCAL nCellHeight
    LOCAL nRow, nCol, nRowSpan, nColSpan
    LOCAL nX, nY, nW, nH
    LOCAL nContentWidth, nContentHeight

    IF Len( ::FgridItems ) = 0
        RETURN
    ENDIF

    IF ::FrowCount = 0 .OR. ::FcolCount = 0
        RETURN
    ENDIF

    /* usable area after margins */
    nContentWidth  := nWidth  - ::FmarginLeft - ::FmarginRight
    nContentHeight := nHeight - ::FmarginTop  - ::FmarginBottom

    IF nContentWidth <= 0 .OR. nContentHeight <= 0
        RETURN
    ENDIF

    nCellWidth  := Int( ( nContentWidth  - ::Fspacing * ( ::FcolCount - 1 ) ) / ::FcolCount )
    nCellHeight := Int( ( nContentHeight - ::Fspacing * ( ::FrowCount - 1 ) ) / ::FrowCount )

    FOR EACH item IN ::FgridItems

        nRow     := item[ 2 ]
        nCol     := item[ 3 ]
        nRowSpan := item[ 4 ]
        nColSpan := item[ 5 ]

        nX := ::FmarginLeft + nCol * ( nCellWidth + ::Fspacing )
        nY := ::FmarginTop  + nRow * ( nCellHeight + ::Fspacing )

        /* last column/row gets remaining space */
        IF nCol + nColSpan >= ::FcolCount
            nW := ::FmarginLeft + nContentWidth - nX
        ELSE
            nW := nColSpan * nCellWidth + ( nColSpan - 1 ) * ::Fspacing
        ENDIF

        IF nRow + nRowSpan >= ::FrowCount
            nH := ::FmarginTop + nContentHeight - nY
        ELSE
            nH := nRowSpan * nCellHeight + ( nRowSpan - 1 ) * ::Fspacing
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

/** Returns a flat array of all widgets in the grid.
 * @return Array of widgets
 */
METHOD FUNCTION widgetList() CLASS HTGridLayout

    LOCAL aList := {}
    LOCAL item

    FOR EACH item IN ::FgridItems
        AAdd( aList, item[ 1 ] )
    NEXT

RETURN aList
