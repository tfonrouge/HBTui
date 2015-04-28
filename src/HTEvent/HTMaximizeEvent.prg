/*
 *
 */

#include "hbtui.ch"

/*
    HTMaximizeEvent
*/
CLASS HTMaximizeEvent FROM HTEvent
PROTECTED:
    DATA Ftype INIT HT_EVENT_TYPE_MAXIMIZE
PUBLIC:
    CONSTRUCTOR New()
ENDCLASS

/*
    New
*/
METHOD New() CLASS HTMaximizeEvent
RETURN Self