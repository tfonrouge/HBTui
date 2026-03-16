/** @class HTLayoutItem
 * Mixin providing alignment support for layout-managed items.
 * @extends HTBase
 */

#include "hbtui.ch"

CLASS HTLayoutItem FROM HTBase

PUBLIC:

    CONSTRUCTOR new( alignment )

    METHOD setAlignment( alignment )

    PROPERTY alignment WRITE setAlignment

ENDCLASS

/** Creates a new layout item with optional alignment.
 * @param alignment Alignment flags (default 0)
 */
METHOD new( alignment ) CLASS HTLayoutItem

    IF alignment = NIL
        alignment := 0
    ENDIF
    ::setAlignment( alignment )

RETURN self

/** Sets the alignment property.
 * @param alignment New alignment flags
 */
METHOD PROCEDURE setAlignment( alignment ) CLASS HTLayoutItem
    ::Falignment := alignment
RETURN
