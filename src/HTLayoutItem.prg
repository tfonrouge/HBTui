/*
 *
 */

#include "hbtui.ch"

CLASS HLayoutItem FROM HBase

PUBLIC:

    CONSTRUCTOR new( alignment )

    METHOD setAlignment( alignment )

    PROPERTY alignment WRITE setAlignment

ENDCLASS

/*
    new
*/
METHOD new( alignment ) CLASS HLayoutItem

    IF alignment = NIL
        alignment := 0
    ENDIF
    ::setAlignment( alignment )

RETURN self

/*
    setAlignment
*/
METHOD PROCEDURE setAlignment( alignment ) CLASS HLayoutItem
    ::Falignment := alignment
RETURN
