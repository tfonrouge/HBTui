/*
 *
 */

#include "hbtui.ch"

/*
    HTHideEvent
*/
CLASS HTHideEvent FROM HTEvent
PROTECTED:
    DATA Ftype INIT HT_EVENT_TYPE_HIDE
PUBLIC:
    CONSTRUCTOR New()
ENDCLASS

/*
    New
*/
METHOD New() CLASS HTHideEvent
RETURN Self