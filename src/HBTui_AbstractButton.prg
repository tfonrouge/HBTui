/*
 *
 */

#include "hbtui.ch"

CLASS HBTui_AbstractButton FROM HBTui_Widget
PROTECTED:

    METHOD DrawControl()

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
    DrawControl
*/
METHOD PROCEDURE DrawControl() CLASS HBTui_AbstractButton
    ? "Drawing button..."
RETURN

/*
    setText
*/
METHOD PROCEDURE setText( text ) CLASS HBTui_AbstractButton
    ::Ftext := text
RETURN
