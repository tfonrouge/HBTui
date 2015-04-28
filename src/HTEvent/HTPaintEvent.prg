/*
 *
 */

#include "hbtui.ch"

/*
    HTPaintEvent
*/
CLASS HTPaintEvent FROM HTEvent
PROTECTED:
    DATA Ftype INIT HT_EVENT_TYPE_PAINT
PUBLIC:
    CONSTRUCTOR New()
ENDCLASS

/*
    New
*/
METHOD New() CLASS HTPaintEvent
RETURN Self