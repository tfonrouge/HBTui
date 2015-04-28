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
ENDCLASS
