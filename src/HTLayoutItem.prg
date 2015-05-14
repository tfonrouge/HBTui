/*
 *
 */

#include "hbtui.ch"

CLASS HTLayoutItem FROM HTBase
PUBLIC:

    CONSTRUCTOR new( alignment )

    METHOD setAlignment( alignment )

    PROPERTY alignment WRITE setAlignment

ENDCLASS

/*
    new
*/
METHOD new( alignment ) CLASS HTLayoutItem
    IF alignment = NIL
        alignment := 0
    ENDIF
    ::setAlignment( alignment )
RETURN self

/*
    setAlignment
*/
METHOD PROCEDURE setAlignment( alignment ) CLASS HTLayoutItem
    ::Falignment := alignment
RETURN
