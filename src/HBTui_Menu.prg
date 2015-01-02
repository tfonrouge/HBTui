/*
 *   31-12-2014
 */

#include "hbtui.ch"
#include "inkey.ch"

CLASS HBTui_Menu FROM HBTui_Widget
PROTECTED:

PUBLIC:

    CONSTRUCTOR New()

    METHOD AddAction()
    METHOD PositionMenu()
    METHOD AddMenu()

ENDCLASS

/*
    New
*/
METHOD New() CLASS HBTui_Menu

RETURN Self

/*
    AddAction
*/
METHOD AddAction() CLASS HBTui_Menu
    LOCAL nKey

    DO WHILE .T.

      nKey := Inkey( 0 )

        DO CASE
        CASE nKey == K_MOUSEMOVE


        CASE nKey == K_LBUTTONDOWN


        CASE nKey == K_LBUTTONUP


        CASE nKey == K_DOWN


        CASE nKey == K_UP


        CASE nKey == K_LEFT


        CASE nKey == K_RIGHT


        CASE nKey == K_ENTER


        CASE nKey == K_ESC


        ENDCASE

    ENDDO

RETURN Self

/*
    PositionMenu()
*/
METHOD PositionMenu() CLASS HBTui_Menu

     // ( nTop, nLeft, nBottom, nRight )

RETURN Self

/*
    AddMenu
*/
METHOD AddMenu() CLASS HBTui_Menu

RETURN Self
