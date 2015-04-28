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
    CONSTRUCTOR New( nKey )
    PROPERTY nKey
ENDCLASS

/*
    New
*/
METHOD New( nKey ) CLASS HTKeyEvent
    ::FnKey := nKey
RETURN Self