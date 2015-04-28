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
ENDCLASS
