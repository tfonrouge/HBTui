/*
 *   31-12-2014
 */

#include "hbtui.ch"
#include "inkey.ch"

CLASS HBTui_MenuBar FROM HBTui_Menu
PROTECTED:

PUBLIC:

    CONSTRUCTOR New( nTop, nLeft, nWidth, nHeight, cColor, wId )

    METHOD AddAction()
    METHOD AddMenu()
    METHOD PositionMenu()

ENDCLASS

/*
    New
*/
METHOD New( nTop, nLeft, nWidth, nHeight, cColor, wId ) CLASS HBTui_MenuBar

    ::Super:New( nTop, nLeft, nWidth, nHeight, cColor, wId )

RETURN Self

/*
    AddAction
*/
METHOD AddAction() CLASS HBTui_MenuBar
    LOCAL nKey

    DO WHILE .T.

      nKey := Inkey( 0 )

        DO CASE
        CASE nKey == K_MOUSEMOVE


        CASE nKey == K_LBUTTONDOWN


        CASE nKey == K_LBUTTONUP


        CASE nKey == K_DOWN


        CASE nKey == K_UP


        CASE nKey == K_END


        CASE nKey == K_HOME


        CASE nKey == K_LEFT


        CASE nKey == K_RIGHT


        CASE nKey == K_ENTER


        CASE nKey == K_ESC


        ENDCASE

    ENDDO

RETURN Self

/*
    AddMenu
*/
METHOD AddMenu() CLASS HBTui_MenuBar

RETURN Self

/*
    PositionMenu()
*/
METHOD PositionMenu() CLASS HBTui_MenuBar

     // ( nTop, nLeft, nBottom, nRight )

RETURN Self
