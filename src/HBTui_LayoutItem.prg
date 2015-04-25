/*
 *
 */

#include "hbtui.ch"

CLASS HTLayoutItem FROM HTBase
PUBLIC:

    CONSTRUCTOR New( alignment )

    METHOD setAlignment( alignment )

    PROPERTY alignment WRITE setAlignment

ENDCLASS

/*
    New
*/
METHOD New( alignment ) CLASS HTLayoutItem
    IF alignment = NIL
        alignment := 0
    ENDIF
    ::setAlignment( alignment )
RETURN Self

/*
    setAlignment
*/
METHOD PROCEDURE setAlignment( alignment ) CLASS HTLayoutItem
    ::Falignment := alignment
RETURN
