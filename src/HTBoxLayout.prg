/** @class HTBoxLayout
 * Layout that arranges widgets in a horizontal or vertical line.
 * Supports spacing, margins, stretch factors, fixed spacers, and nested layouts.
 * @extends HTLayout
 *
 * @property direction Direction: 0 = horizontal, 2 = vertical
 * @property spacing  Gap in characters between adjacent items (inherited from HTLayout)
 *
 * Items in the layout are tuples { xItem, nType, nStretch }:
 *   nType: 0 = widget, 1 = stretch, 2 = fixed spacing, 3 = nested layout container
 *   nStretch: stretch factor (0 = use widget's own size, >0 = proportional)
 *
 * @example
 *   oLayout := HTVBoxLayout():new( oWindow )
 *   oLayout:spacing := 1
 *   oLayout:setContentsMargins( 1, 1, 1, 1 )
 *   oLayout:addWidget( oLabel )
 *   oLayout:addStretch()
 *   oLayout:addWidget( oButton )
 *
 * @see HTVBoxLayout, HTHBoxLayout, HTGridLayout
 */

#include "hbtui.ch"

#define _ITEM_WIDGET   0
#define _ITEM_STRETCH  1
#define _ITEM_SPACING  2

CLASS HTBoxLayout FROM HTLayout

PROTECTED:

    DATA FitemList INIT {}

PUBLIC:

    CONSTRUCTOR new( dir, parent )

    METHOD addWidget( w )
    METHOD addStretch( nFactor )
    METHOD addSpacing( nChars )
    METHOD addLayout( oLayout )
    METHOD doLayout( nWidth, nHeight )

    METHOD setDirection( dir )
    METHOD widgetList()

    PROPERTY direction WRITE setDirection

ENDCLASS

/** Creates a new box layout with the given direction.
 * @param dir Direction: 0 = horizontal, 2 = vertical
 * @param parent Optional parent HTWidget
 */
METHOD new( dir, parent ) CLASS HTBoxLayout
    ::setDirection( dir )
RETURN ::super:new( parent )

/** Adds a widget to the layout.
 * @param w The widget to add
 */
METHOD PROCEDURE addWidget( w ) CLASS HTBoxLayout
    AAdd( ::FitemList, { w, _ITEM_WIDGET, 0 } )
RETURN

/** Adds a stretch item that expands to fill available space.
 * @param nFactor Stretch factor (default 1); higher values get proportionally more space
 */
METHOD PROCEDURE addStretch( nFactor ) CLASS HTBoxLayout
    DEFAULT nFactor := 1
    AAdd( ::FitemList, { NIL, _ITEM_STRETCH, nFactor } )
RETURN

/** Adds a fixed-size spacer.
 * @param nChars Size in characters (columns for horizontal, rows for vertical)
 */
METHOD PROCEDURE addSpacing( nChars ) CLASS HTBoxLayout
    DEFAULT nChars := 1
    AAdd( ::FitemList, { NIL, _ITEM_SPACING, nChars } )
RETURN

/** Adds a child layout wrapped in a container widget.
 * @param oLayout The child HTLayout to nest
 */
METHOD PROCEDURE addLayout( oLayout ) CLASS HTBoxLayout

    LOCAL oContainer

    oContainer := HTWidget():new()
    oContainer:setLayout( oLayout )
    oContainer:FisVisible := .T.
    AAdd( ::FitemList, { oContainer, _ITEM_WIDGET, 0 } )

RETURN

/** Calculates and assigns positions for all items (widgets, stretches, spacers).
 * @param nWidth Available width in characters
 * @param nHeight Available height in rows
 */
METHOD PROCEDURE doLayout( nWidth, nHeight ) CLASS HTBoxLayout

    LOCAL itm, w
    LOCAL nPos
    LOCAL nCount := Len( ::FitemList )
    LOCAL nContentWidth, nContentHeight
    LOCAL nAvail, nFixedTotal, nStretchTotal, nStretchUnit
    LOCAL nItemSize
    LOCAL nWidgetCount

    IF nCount = 0
        RETURN
    ENDIF

    /* usable area after margins */
    nContentWidth  := nWidth  - ::FmarginLeft - ::FmarginRight
    nContentHeight := nHeight - ::FmarginTop  - ::FmarginBottom

    IF nContentWidth <= 0 .OR. nContentHeight <= 0
        RETURN
    ENDIF

    /* first pass: calculate fixed space and total stretch */
    nFixedTotal := ::Fspacing * ( nCount - 1 )
    nStretchTotal := 0

    FOR EACH itm IN ::FitemList
        IF itm[ 2 ] = _ITEM_SPACING
            nFixedTotal += itm[ 3 ]
        ELSEIF itm[ 2 ] = _ITEM_STRETCH
            nStretchTotal += itm[ 3 ]
        ENDIF
    NEXT

    /* available space for widgets and stretches */
    IF ::Fdirection = 2
        nAvail := nContentHeight - nFixedTotal
    ELSE
        nAvail := nContentWidth - nFixedTotal
    ENDIF

    /* count non-stretch, non-spacing items (widgets) */
    nItemSize := 0
    FOR EACH itm IN ::FitemList
        IF itm[ 2 ] = _ITEM_WIDGET
            nItemSize++
        ENDIF
    NEXT

    /* if no stretches: divide space equally among widgets */
    IF nStretchTotal = 0 .AND. nItemSize > 0
        nStretchUnit := 0
        nItemSize := Int( nAvail / nItemSize )
    ELSE
        /* widgets get minimum size (1), stretches get proportional rest */
        nItemSize := 1
        nStretchUnit := IIF( nStretchTotal > 0, ;
            Int( ( nAvail - nItemSize * 0 ) / nStretchTotal ), 0 )

        /* recalculate: widgets share space equally, stretches fill the rest */
        nWidgetCount := 0
        FOR EACH itm IN ::FitemList
            IF itm[ 2 ] = _ITEM_WIDGET
                nWidgetCount++
            ENDIF
        NEXT
        IF nWidgetCount > 0
            nItemSize := Int( ( nAvail - nStretchUnit * nStretchTotal ) / nWidgetCount )
            nItemSize := Max( nItemSize, 1 )
        ENDIF
    ENDIF

    /* second pass: assign positions */
    IF ::Fdirection = 2
        /* vertical */
        nPos := ::FmarginTop
        FOR EACH itm IN ::FitemList
            IF itm[ 2 ] = _ITEM_SPACING
                nPos += itm[ 3 ] + ::Fspacing
            ELSEIF itm[ 2 ] = _ITEM_STRETCH
                nPos += nStretchUnit * itm[ 3 ] + ::Fspacing
            ELSE
                w := itm[ 1 ]
                IF w:isDerivedFrom( "HTWidget" )
                    w:Fx := ::FmarginLeft
                    w:Fy := nPos
                    w:Fwidth := nContentWidth
                    w:Fheight := nItemSize
                    w:FisVisible := .T.
                ENDIF
                nPos += nItemSize + ::Fspacing
            ENDIF
        NEXT

        /* last widget gets remaining space */
        FOR EACH itm IN ::FitemList DESCEND
            IF itm[ 2 ] = _ITEM_WIDGET
                w := itm[ 1 ]
                IF w:isDerivedFrom( "HTWidget" )
                    w:Fheight := Max( 1, ::FmarginTop + nContentHeight - w:Fy )
                ENDIF
                EXIT
            ENDIF
        NEXT
    ELSE
        /* horizontal */
        nPos := ::FmarginLeft
        FOR EACH itm IN ::FitemList
            IF itm[ 2 ] = _ITEM_SPACING
                nPos += itm[ 3 ] + ::Fspacing
            ELSEIF itm[ 2 ] = _ITEM_STRETCH
                nPos += nStretchUnit * itm[ 3 ] + ::Fspacing
            ELSE
                w := itm[ 1 ]
                IF w:isDerivedFrom( "HTWidget" )
                    w:Fx := nPos
                    w:Fy := ::FmarginTop
                    w:Fwidth := nItemSize
                    w:Fheight := nContentHeight
                    w:FisVisible := .T.
                ENDIF
                nPos += nItemSize + ::Fspacing
            ENDIF
        NEXT

        /* last widget gets remaining space */
        FOR EACH itm IN ::FitemList DESCEND
            IF itm[ 2 ] = _ITEM_WIDGET
                w := itm[ 1 ]
                IF w:isDerivedFrom( "HTWidget" )
                    w:Fwidth := Max( 1, ::FmarginLeft + nContentWidth - w:Fx )
                ENDIF
                EXIT
            ENDIF
        NEXT
    ENDIF

RETURN

/** Returns a flat array of all widgets in the layout (excluding stretches/spacers).
 * @return Array of HTWidget instances
 */
METHOD FUNCTION widgetList() CLASS HTBoxLayout

    LOCAL aList := {}
    LOCAL itm

    FOR EACH itm IN ::FitemList
        IF itm[ 2 ] = _ITEM_WIDGET .AND. itm[ 1 ] != NIL
            AAdd( aList, itm[ 1 ] )
        ENDIF
    NEXT

RETURN aList

/** Sets the layout direction.
 * @param dir Direction: 0 = horizontal, 2 = vertical
 */
METHOD PROCEDURE setDirection( dir ) CLASS HTBoxLayout
    ::Fdirection := dir
RETURN
