/*
 *
 */

#include "hbtui.ch"

CLASS HTMainWindow FROM HTWidget
PROTECTED:
    DATA FmenuBar
PUBLIC:
    METHOD menuBar()
    METHOD show()
ENDCLASS

/*
    menuBar
*/
METHOD FUNCTION menuBar() CLASS HTMainWindow
    IF ::FmenuBar = NIL
        ::FmenuBar := HTMenuBar():new( Self )
    ENDIF
RETURN ::FmenuBar

/*
    show
*/
METHOD PROCEDURE show() CLASS HTMainWindow
    ::Super:show()
RETURN
