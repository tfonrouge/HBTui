/** @class HTGetBackend
 * Display-suppressed TGet subclass used internally by HTGet.
 * @extends Get
 *
 * TGet was designed for Clipper's READ system where GETs paint themselves
 * at fixed absolute screen coordinates via display(). HTGet operates in
 * a viewport-based rendering system (CT windows + wFormat margins) and
 * handles all painting in its own paintEvent().
 *
 * This subclass overrides display() to compute internal state (nMaxLen,
 * nDispLen) needed by TGet's editing methods, but suppresses all screen
 * output (DispOutAt, SetPos) that would conflict with viewport rendering.
 */

#include "hbtui.ch"

CREATE CLASS HTGetBackend FROM Get

    EXPORTED:

    METHOD display()

ENDCLASS

/** Computes TGet internal display state without any screen output.
 * Maintains nMaxLen and nDispLen so that TGet's editing methods
 * (overStrike, insert, etc.) work correctly.
 */
METHOD display() CLASS HTGetBackend

    LOCAL cBuffer

    IF ::hasFocus
        cBuffer := ::cBuffer
    ELSE
        ::cType   := ValType( ::xVarGet := ::varGet() )
        ::picture := ::cPicture
        cBuffer   := ::PutMask( ::xVarGet )
    ENDIF

    ::nMaxLen      := Len( cBuffer )
    ::nDispLen     := iif( ::nPicLen == NIL, ::nMaxLen, ::nPicLen )
    ::nOldPos      := 1
    ::lSuppDisplay := .F.

RETURN Self
