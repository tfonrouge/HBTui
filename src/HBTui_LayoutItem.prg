/*
 *
 */

#include "hbtui.ch"

CLASS HBTui_LayoutItem FROM HBTui_Base
PUBLIC:

    CONSTRUCTOR New( alignment )

    METHOD setAlignment( alignment )

    PROPERTY alignment WRITE setAlignment

ENDCLASS

/*
    New
*/
METHOD New( alignment ) CLASS HBTui_LayoutItem
    IF alignment = NIL
        alignment := 0
    ENDIF
    ::setAlignment( alignment )
RETURN Self

/*
    setAlignment
*/
METHOD PROCEDURE setAlignment( alignment ) CLASS HBTui_LayoutItem
    ::Falignment := alignment
RETURN
