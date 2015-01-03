/*
 *   31-12-2014
 */

#include "hbtui.ch"

CLASS HBTui_MenuBox FROM HBTui_Menu
PROTECTED:

PUBLIC:

    CONSTRUCTOR New( nTop, nLeft, nWidth, nHeight, cColor, wId )

ENDCLASS

/*
    New
*/
METHOD New( nTop, nLeft, nWidth, nHeight, cColor, wId ) CLASS HBTui_MenuBox

    ::Super:New( nTop, nLeft, nWidth, nHeight, cColor, wId )

RETURN Self
