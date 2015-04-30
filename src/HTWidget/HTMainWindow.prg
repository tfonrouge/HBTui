/*
 *
 */

#include "hbtui.ch"

CLASS HTMainWindow FROM HTWidget
PROTECTED:
    DATA FmenuBar
PUBLIC:
    METHOD menuBar()
ENDCLASS

/*
    menuBar
*/
METHOD FUNCTION menuBar() CLASS HTMainWindow
    IF ::FmenuBar = NIL
        ::FmenuBar := HTMenuBar():New( Self )
    ENDIF
RETURN ::FmenuBar
