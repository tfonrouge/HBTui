/*
 *
 */

#include "hbtui.ch"

CLASS HTAbstractButton FROM HTWidget
PROTECTED:

PUBLIC:

    METHOD new( parent ) INLINE ::super:new( parent )

    METHOD setText( text )

    PROPERTY autoExclusive  INIT .f.
    PROPERTY checkable      INIT .f.
    PROPERTY checked        INIT .f.
    PROPERTY down           INIT .f.
    PROPERTY shortcut
    PROPERTY text WRITE setText INIT ""

ENDCLASS

/*
    setText
*/
METHOD PROCEDURE setText( text ) CLASS HTAbstractButton
    ::Ftext := text
RETURN
