/*
 *
 */

#define HB_CLS_NOTOBJECT

#include "hbtui.ch"

CLASS HTEvent
PUBLIC:
    CONSTRUCTOR New( nKey )

    METHOD accept() INLINE ::FisAccepted := .T.
    METHOD ignore() INLINE ::FisAccepted := .F.
    METHOD setAccepted( accepted ) INLINE ::FisAccepted := accepted

    PROPERTY isAccepted INIT .T.
    PROPERTY nKey
    PROPERTY type INIT HT_EVENT_TYPE_NULL
    PROPERTY hbtObject READWRITE

ENDCLASS

/*
    New
*/
METHOD New( nKey ) CLASS HTEvent
    ::FnKey := nKey
RETURN Self
