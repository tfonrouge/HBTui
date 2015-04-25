/*
 *
 */

#include "hbtui.ch"

CLASS HTBoxLayout FROM HTLayout
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
METHOD New( dir, parent ) CLASS HTBoxLayout
    ::setDirection( dir )
RETURN ::Super:New( parent )

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