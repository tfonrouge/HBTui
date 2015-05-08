/*
 *
 */

#include "hbtui.ch"

SINGLETON CLASS HTDesktop FROM HTWidget
PROTECTED:
PUBLIC:
    METHOD addEvent( event )
    METHOD paintEvent( paintEvent )
ENDCLASS

/*
    addEvent
*/
METHOD PROCEDURE addEvent( event ) CLASS HTDesktop
    ::super:addEvent( event, HT_EVENT_PRIORITY_HIGH )
RETURN

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HTDesktop
    ctWInit()
    paintEvent:accept()
    wBoard() /* available physical screen */
    wMode( .F., .F., .F., .F. ) /* windows cannot be moved outside of screen ( top, left, bottom, right ) */
    wSetShadow( ::FShadow )
    setClearA( ::FClearA )
    setClearB( ::FClearB )
    dispBox( 0, 0, maxRow(), maxCol(), replicate( ::FClearB, 9 ), ::color )
    setPos( 0, 0 )
    ::FisVisible := .T.
    ::setWindowId( 0 )
RETURN
