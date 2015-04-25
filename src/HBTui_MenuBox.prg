/*
 *   31-12-2014
 */

#include "hbtui.ch"

CLASS HTMenuBox FROM HTMenu
PROTECTED:

PUBLIC:

    CONSTRUCTOR New( nTop, nLeft, nWidth, nHeight, cColor, wId )

ENDCLASS

/*
    New
*/
METHOD New( nTop, nLeft, nWidth, nHeight, cColor, wId ) CLASS HTMenuBox

    ::Super:New( nTop, nLeft, nWidth, nHeight, cColor, wId )

RETURN Self
