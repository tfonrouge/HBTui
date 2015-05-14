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
    CONSTRUCTOR new( nKey )
    PROPERTY nKey
ENDCLASS

/*
    new
*/
METHOD new( nKey ) CLASS HTKeyEvent
    ::FnKey := nKey
RETURN self