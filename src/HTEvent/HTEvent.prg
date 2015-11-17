/*
 *
 */

#define HB_CLS_NOTOBJECT

#include "hbtui.ch"

CLASS HTEvent
PUBLIC:

    METHOD accept() INLINE ::FisAccepted := .t.
    METHOD ignore() INLINE ::FisAccepted := .f.
    METHOD setAccepted( accepted ) INLINE ::FisAccepted := accepted
    METHOD setWidget( widget ) INLINE ::Fwidget := widget

    PROPERTY isAccepted INIT .t.
    PROPERTY type INIT HT_EVENT_TYPE_NULL
    PROPERTY widget

ENDCLASS
