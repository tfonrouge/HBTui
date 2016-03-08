/*
 *
 */

#include "hbtui.ch"

CLASS HTBoxLayout FROM HTLayout

PROTECTED:

    DATA FwidgetList INIT {}

PUBLIC:

    CONSTRUCTOR new( dir, parent )

    METHOD addWidget( w )

    METHOD setDirection( dir )

    PROPERTY direction WRITE setDirection

ENDCLASS

/*
    new
*/
METHOD new( dir, parent ) CLASS HTBoxLayout
    ::setDirection( dir )
RETURN ::super:new( parent )

/*
    addWidget
*/
METHOD PROCEDURE addWidget( w ) CLASS HTBoxLayout
    ::addItem( w )
RETURN

/*
    setDirection
*/
METHOD PROCEDURE setDirection( dir ) CLASS HTBoxLayout
    ::Fdirection := dir
RETURN
