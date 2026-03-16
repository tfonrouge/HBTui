/** @class HTMainWindow
 * Top-level application window with an optional menu bar.
 * @extends HTWidget
 */

#include "hbtui.ch"

CLASS HTMainWindow FROM HTWidget

PROTECTED:

PUBLIC:

    METHOD menuBar()
    METHOD show()

ENDCLASS

/** Returns the menu bar, creating one if it does not exist.
 * @return HTMenuBar instance
 */
METHOD FUNCTION menuBar() CLASS HTMainWindow
    IF ::FmenuBar = NIL
        HTMenuBar():new( self )
    ENDIF
RETURN ht_objectFromId( ::FmenuBar )

/** Shows the main window by delegating to the parent show(). */
METHOD PROCEDURE show() CLASS HTMainWindow
    ::super:show()
RETURN
