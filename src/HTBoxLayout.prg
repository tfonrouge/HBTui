/*
 *
 */

#include "hbtui.ch"

CLASS HBoxLayout FROM HLayout

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
METHOD new( dir, parent ) CLASS HBoxLayout
    ::setDirection( dir )
RETURN ::super:new( parent )

/*
    addWidget
*/
METHOD PROCEDURE addWidget( w ) CLASS HBoxLayout
    ::addItem( w )
RETURN

/*
    setDirection
*/
METHOD PROCEDURE setDirection( dir ) CLASS HBoxLayout
    ::Fdirection := dir
RETURN
