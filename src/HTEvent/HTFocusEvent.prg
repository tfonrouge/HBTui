/*
 *
 */

#include "hbtui.ch"

/*
    HTFocusEvent
*/
CLASS HFocusEvent FROM HEvent
PROTECTED:
PUBLIC:
    CONSTRUCTOR new( type, reason )
    PROPERTY gotFocus READ Ftype = HT_EVENT_TYPE_FOCUSIN
    PROPERTY lostFocus READ Ftype = HT_EVENT_TYPE_FOCUSOUT
    PROPERTY reason
ENDCLASS

/*
    new
*/
METHOD new( type, reason ) CLASS HFocusEvent
    ::Ftype := type
    ::Freason := reason
RETURN self
