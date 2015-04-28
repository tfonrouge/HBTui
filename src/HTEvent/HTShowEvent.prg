/*
 *
 */

#include "hbtui.ch"

/*
    HTShowEvent
*/
CLASS HTShowEvent FROM HTEvent
PROTECTED:
    DATA Ftype INIT HT_EVENT_TYPE_SHOW
PUBLIC:
    CONSTRUCTOR New()
ENDCLASS

/*
    New
*/
METHOD New() CLASS HTShowEvent
RETURN Self