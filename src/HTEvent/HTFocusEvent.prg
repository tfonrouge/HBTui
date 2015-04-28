/*
 *
 */

#include "hbtui.ch"

/*
    HTFocusEvent
*/
CLASS HTFocusEvent FROM HTEvent
PROTECTED:
PUBLIC:
    CONSTRUCTOR New( type, reason )
    PROPERTY gotFocus READ Ftype = HT_EVENT_TYPE_FOCUSIN
    PROPERTY lostFocus READ Ftype = HT_EVENT_TYPE_FOCUSOUT
    PROPERTY reason
ENDCLASS

/*
    New
*/
METHOD New( type, reason ) CLASS HTFocusEvent
    ::Ftype := type
    ::Freason := reason
RETURN Self