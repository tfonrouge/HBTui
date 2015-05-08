/*
 *
 */

#include "hbtui.ch"

SINGLETON CLASS HTDesktop FROM HTWidget
PROTECTED:
    METHOD paintMenu()
PUBLIC:
    METHOD addEvent( event )
    METHOD paintEvent( paintEvent )
ENDCLASS

/*
    addEvent
*/
METHOD PROCEDURE addEvent( event ) CLASS HTDesktop
    ::Super:addEvent( event, HT_EVENT_PRIORITY_HIGH )
RETURN

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HTDesktop
    CTWInit()
    paintEvent:accept()
    WBoard() /* available physical screen */
    WMode( .F., .F., .F., .F. ) /* windows cannot be moved outside of screen ( top, left, bottom, right ) */
    WsetShadow( ::FShadow )
    setClearA( ::FClearA )
    setClearB( ::FClearB )
    DispBox( 0, 0, MaxRow(), MaxCol(), Replicate( ::FClearB, 9 ), ::color )
    SetPos( 0, 0 )
    ::FisVisible := .T.
    ::setWindowId( 0 )
RETURN

/*
    paintMenu
*/
METHOD PROCEDURE paintMenu() CLASS HTDesktop
RETURN