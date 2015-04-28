/*
 *
 */

#include "hbtui.ch"

/*
    HTKeyEvent
*/
CLASS HTKeyEvent FROM HTEvent
PROTECTED:
    DATA Ftype INIT HT_EVENT_TYPE_KEYBOARD
PUBLIC:
ENDCLASS
