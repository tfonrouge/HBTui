/*
 *   31-12-2014
 */

#include "hbtui.ch"
#include "inkey.ch"

CLASS HBTui_Menu FROM HBTui_Widget
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
METHOD New( nTop, nLeft, nWidth, nHeight, cColor, wId ) CLASS HBTui_Menu

    ::Super:New( nTop, nLeft, nWidth, nHeight, cColor, wId )

RETURN Self

/*
    AddAction
*/
METHOD PROCEDURE AddAction() CLASS HBTui_Menu
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

RETURN

/*
    AddMenu
*/
METHOD PROCEDURE AddMenu() CLASS HBTui_Menu

RETURN
/*
    PositionMenu()
*/
METHOD FUNCTION PositionMenu() CLASS HBTui_Menu

     // ( nTop, nLeft, nBottom, nRight )

RETURN Self
