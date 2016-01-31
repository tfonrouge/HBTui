/*
 *
 */

#include "hbtui.ch"

SINGLETON CLASS HDesktop FROM HWidget
PROTECTED:
PUBLIC:

    CONSTRUCTOR new()

    METHOD addEvent( event )
    METHOD paintEvent( paintEvent )

ENDCLASS

/*
    new
*/
METHOD new() CLASS HDesktop
    LOCAL menu

    ::super:new( NIL, HT_DESKTOP )

    menu := HMenuBar():new( self ):addMenu(e"\xfe") /* always present menu */

    menu:addAction("About")
    menu:addSeparator()
    menu:addAction("Quit")

RETURN self

/*
    addEvent
*/
METHOD PROCEDURE addEvent( event ) CLASS HDesktop
    ::super:addEvent( event, HT_EVENT_PRIORITY_HIGH )
RETURN

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( paintEvent ) CLASS HDesktop

    ctWInit()

    wSelect( 0 )

    paintEvent:accept()
    wBoard() /* available physical screen */
    wMode( .f., .f., .f., .f. ) /* windows cannot be moved outside of screen ( top, left, bottom, right ) */
    wSetShadow( ::Fshadow )
    setClearA( ::FclearA )
    setClearB( ::FclearB )
    dispBox( 0, 0, maxRow(), maxCol(), replicate( ::FclearB, 9 ), ::color )
    setPos( 0, 0 )
    ::FisVisible := .t.
    ::setWindowId( 0 )
    ::Fwidth := maxCol() + 1
    ::Fheight := maxRow() + 1

    wBoard( NIL, NIL, NIL, NIL )

    ::paintChildren()

RETURN
