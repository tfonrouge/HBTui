/** @class HTFocusEvent
 * Event emitted when a widget gains or loses keyboard focus.
 * @extends HTEvent
 */

#include "hbtui.ch"

CLASS HTFocusEvent FROM HTEvent

PROTECTED:
PUBLIC:

    CONSTRUCTOR new( type, reason )
    PROPERTY gotFocus READ Ftype = HT_EVENT_TYPE_FOCUSIN
    PROPERTY lostFocus READ Ftype = HT_EVENT_TYPE_FOCUSOUT
    PROPERTY reason
    
ENDCLASS

/** Creates a new focus event.
 * @param type HT_EVENT_TYPE_FOCUSIN or HT_EVENT_TYPE_FOCUSOUT
 * @param reason The reason for the focus change
 */
METHOD new( type, reason ) CLASS HTFocusEvent
    ::Ftype := type
    ::Freason := reason
RETURN self
