/*
 *
 */

#include "hbtui.ch"

SINGLETON CLASS HTDesktop FROM HTWidget

PROTECTED:
PUBLIC:

    CONSTRUCTOR new()

    METHOD addEvent( event )
    METHOD paintEvent( paintEvent )

ENDCLASS

/*
    new
*/
METHOD new() CLASS HTDesktop

    LOCAL menu

    ::super:new( NIL, HT_DESKTOP )

    menu := HTMenuBar():new( self ):addMenu(e"\xfe") /* always present menu */

    menu:addAction("About")
    menu:addSeparator()
    menu:addAction("Quit")

RETURN self

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

    wSelect( 0 )

    paintEvent:accept()
    wBoard() /* available physical screen */
    wMode( .f., .f., .f., .f. ) /* windows cannot be moved outside of screen ( top, left, bottom, right ) */
    wSetShadow( ::Fshadow )
    SetClearA( ::FclearA )
    SetClearB( ::FclearB )
    DispBox( 0, 0, MaxRow(), MaxCol(), Replicate( ::FclearB, 9 ), ::color )
    SetPos( 0, 0 )
    ::FisVisible := .T.
    ::setWindowId( 0 )
    ::Fwidth := MaxCol() + 1
    ::Fheight := MaxRow() + 1

    wBoard( NIL, NIL, NIL, NIL )

    ::paintWidget()

RETURN
