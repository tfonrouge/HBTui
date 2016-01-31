/*
 *
 */

#include "hbtui.ch"

CLASS HMainWindow FROM HWidget
PROTECTED:
PUBLIC:
    METHOD menuBar()
    METHOD show()
ENDCLASS

/*
    menuBar
*/
METHOD FUNCTION menuBar() CLASS HMainWindow
    IF ::FmenuBar = NIL
        HMenuBar():new( self )
    ENDIF
RETURN ht_objectFromId( ::FmenuBar )

/*
    show
*/
METHOD PROCEDURE show() CLASS HMainWindow
    ::super:show()
RETURN
