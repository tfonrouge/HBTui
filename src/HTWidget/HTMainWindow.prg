/*
 *
 */

#include "hbtui.ch"

CLASS HTMainWindow FROM HTWidget
PROTECTED:
PUBLIC:
    METHOD menuBar()
    METHOD show()
ENDCLASS

/*
    menuBar
*/
METHOD FUNCTION menuBar() CLASS HTMainWindow
    IF ::FmenuBar = NIL
        HTMenuBar():new( self )
    ENDIF
RETURN ht_objectFromId( ::FmenuBar )

/*
    show
*/
METHOD PROCEDURE show() CLASS HTMainWindow
    ::super:show()
RETURN
