/** @class HTAbstractButton
 * Abstract base class for all button widgets. Provides checked state, text, and click/toggle callbacks.
 * @extends HTWidget
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
    PROPERTY onClicked READWRITE                 /* code block: {|| action } */
    PROPERTY onToggled READWRITE                 /* code block: {|lChecked| action } */
    PROPERTY shortcut
    PROPERTY text WRITE setText INIT ""

ENDCLASS

/** Sets the checked state.
 * @param checked New checked value
 */
METHOD PROCEDURE setChecked( checked ) CLASS HTAbstractButton
    ::Fchecked := checked
RETURN

/** Sets the button text.
 * @param text New label text
 */
METHOD PROCEDURE setText( text ) CLASS HTAbstractButton
    ::Ftext := text
RETURN
