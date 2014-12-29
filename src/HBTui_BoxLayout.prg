/*
 *
 */

#include "hbtui.ch"

CLASS HBTui_BoxLayout FROM HBTui_Layout
PROTECTED:
    DATA FwidgetList INIT {}
PUBLIC:

    CONSTRUCTOR New( dir, parent )

    METHOD addWidget( w )

    METHOD setDirection( dir )

    PROPERTY direction WRITE setDirection

ENDCLASS

/*
    New
*/
METHOD New( dir, parent ) CLASS HBTui_BoxLayout
    ::setDirection( dir )
RETURN ::Super:New( parent )

/*
    addWidget
*/
METHOD PROCEDURE addWidget( w ) CLASS HBTui_BoxLayout
    ::addItem( w )
RETURN

/*
    setDirection
*/
METHOD PROCEDURE setDirection( dir ) CLASS HBTui_BoxLayout
    ::Fdirection := dir
RETURN