/** @class HTLayout
 * Abstract base class for layout managers.
 * @extends HTObject, HTLayoutItem
 */

#include "hbtui.ch"

CLASS HTLayout FROM HTObject, HTLayoutItem

PROTECTED:

    DATA FmarginTop    INIT 0
    DATA FmarginLeft   INIT 0
    DATA FmarginBottom INIT 0
    DATA FmarginRight  INIT 0

PUBLIC:

    CONSTRUCTOR new( parent )

    METHOD addWidget( w ) VIRTUAL
    METHOD setContentsMargins( nTop, nLeft, nBottom, nRight )

    PROPERTY spacing INIT 0

ENDCLASS

/** Creates a new layout and attaches it to the parent widget.
 * @param parent Optional parent HTWidget to attach this layout to
 */
METHOD new( parent ) CLASS HTLayout
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:setLayout( self )
    ENDIF
RETURN self

/** Sets the layout content margins.
 * @param nTop Top margin
 * @param nLeft Left margin
 * @param nBottom Bottom margin
 * @param nRight Right margin
 */
METHOD PROCEDURE setContentsMargins( nTop, nLeft, nBottom, nRight ) CLASS HTLayout
    ::FmarginTop    := nTop
    ::FmarginLeft   := nLeft
    ::FmarginBottom := nBottom
    ::FmarginRight  := nRight
RETURN
