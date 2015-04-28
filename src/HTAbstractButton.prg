/*
 *
 */

#include "hbtui.ch"

CLASS HTAbstractButton FROM HTWidget
PROTECTED:

PUBLIC:

    METHOD New( parent ) INLINE ::Super:New( parent )

    METHOD setText( text )

    PROPERTY autoExclusive  INIT .F.
    PROPERTY checkable      INIT .F.
    PROPERTY checked        INIT .F.
    PROPERTY down           INIT .F.
    PROPERTY shortcut
    PROPERTY text WRITE setText INIT ""

ENDCLASS

/*
    setText
*/
METHOD PROCEDURE setText( text ) CLASS HTAbstractButton
    ::Ftext := text
RETURN
