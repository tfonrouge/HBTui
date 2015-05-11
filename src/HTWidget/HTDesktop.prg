/*
 *
 */

#include "hbtui.ch"

SINGLETON CLASS HTDesktop FROM HTWidget
PROTECTED:
PUBLIC:
    CONSTRUCTOR new( ... )
    METHOD addEvent( event )
    METHOD paintEvent( paintEvent )
    PROPERTY menuBar
ENDCLASS

/*
    new
*/
METHOD new( ... ) CLASS HTDesktop

    ::FmenuBar := HTMenuBar():new()
    ::FmenuBar:addMenu(e"\fe")

RETURN ::super:new( ... )

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
    wMode( .f., .f., .f., .f. ) /* windows cannot be moved outside of screen ( top, left, bottom, right ) */
    wSetShadow( ::FShadow )
    setClearA( ::FClearA )
    setClearB( ::FClearB )
    dispBox( 0, 0, maxRow(), maxCol(), replicate( ::FClearB, 9 ), ::color )
    setPos( 0, 0 )
    ::FisVisible := .t.
    ::setWindowId( 0 )
    ::Fwidth := maxCol() + 1
    ::Fheight := maxRow() + 1
    ::paintMenu()
    wBoard( 1, NIL, NIL, NIL )
RETURN
