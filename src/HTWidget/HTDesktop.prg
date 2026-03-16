/** @class HTDesktop
 * Singleton desktop background widget that fills the entire screen.
 * Creates the CT window system and renders the desktop pattern.
 * @extends HTWidget
 */

#include "hbtui.ch"

SINGLETON CLASS HTDesktop FROM HTWidget

PROTECTED:
PUBLIC:

    CONSTRUCTOR new()

    METHOD paintEvent( paintEvent )

ENDCLASS

/** Creates the desktop with a default system menu (About, Quit). */
METHOD new() CLASS HTDesktop

    LOCAL menu

    ::super:new( NIL, HT_DESKTOP )

    menu := HTMenuBar():new( self ):addMenu(e"\xfe") /* always present menu */

    menu:addAction("About")
    menu:addSeparator()
    menu:addAction("Quit")

RETURN self

/** Initializes the CT window system, paints the desktop background,
 * and registers as window 0.
 * @param paintEvent HTPaintEvent instance
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
