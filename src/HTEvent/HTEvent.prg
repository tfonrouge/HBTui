/*
 *
 */

#define HB_CLS_NOTOBJECT

#include "hbtui.ch"

CLASS HEvent

PUBLIC:

    METHOD accept() INLINE ::FisAccepted := .T.
    METHOD ignore() INLINE ::FisAccepted := .F.
    METHOD setAccepted( accepted ) INLINE ::FisAccepted := accepted
    METHOD setWidget( widget ) INLINE ::Fwidget := widget

    PROPERTY isAccepted INIT .T.
    PROPERTY type INIT HT_EVENT_TYPE_NULL
    PROPERTY widget

ENDCLASS
