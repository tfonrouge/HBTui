/*
 *
 */

#include "hbtui.ch"

CLASS HTAbstractButton FROM HTWidget

PROTECTED:

PUBLIC:

    METHOD new( parent ) INLINE ::super:new( parent )

    METHOD setChecked( checked )
    METHOD setText( text )

    PROPERTY autoExclusive  INIT .F.
    PROPERTY checkable      INIT .F.
    PROPERTY checked WRITE setChecked INIT .F.
    PROPERTY down           INIT .F.
    PROPERTY onClicked                          /* code block: {|| action } */
    PROPERTY onToggled                          /* code block: {|lChecked| action } */
    PROPERTY shortcut
    PROPERTY text WRITE setText INIT ""

ENDCLASS

/*
    setChecked
*/
METHOD PROCEDURE setChecked( checked ) CLASS HTAbstractButton
    ::Fchecked := checked
RETURN

/*
    setText
*/
METHOD PROCEDURE setText( text ) CLASS HTAbstractButton
    ::Ftext := text
RETURN
