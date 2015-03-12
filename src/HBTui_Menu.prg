/*
   13-03-2014
*/

#include "hbtui.ch"
#include "inkey.ch"

CLASS HBTui_Menu FROM HBTui_Widget

PROTECTED:
   VAR items         AS ARRAY   INIT {}
   VAR idVar         AS NUMERIC INIT 1
   VAR parent        AS OBJECT

EXPORT:
   METHOD New( aItems )
   METHOD AddItem
   METHOD Draw()
   METHOD Exec( oParent )
   METHOD NewMenuPos()

   MESSAGE SetKeys   IS DEFERRED
   MESSAGE ClearKeys IS DEFERRED

END CLASS

/*
   New
*/
METHOD New( aItems ) CLASS HBTui_Menu
   LOCAL i

    // ::items := {}
    // ::idVar := 1

    IF aItems != NIL
       FOR i := 1 TO LEN( aItems )
          ::AddItem( aItems[i, 1], aItems[i, 2] )
       NEXT
    ENDIF

RETURN Self

/*
   Draw
*/
METHOD Draw() CLASS HBTui_Menu
   LOCAL i

   FOR i := 1 TO LEN( ::items )
      ::items[i]:Draw()
   NEXT i

RETURN Self

/*
   AddItem
*/
METHOD AddItem( nRow, nCol, cLabel, oAction, lActive ) CLASS HBTui_Menu

   AADD( ::items, MenuItem():New( nRow, nCol, cLabel, oAction, lActive ) )

RETURN Self

/*
   Exec
*/
METHOD Exec( oParent ) CLASS HBTui_Menu
   LOCAL finished := .F.

   ::parent := oParent

   WHILE !finished
      ::Draw()

      ::SetKeys()
      MENU TO ::idVar
      ::ClearKeys()

      finished := ( ::idVar == 0 )

      IF !finished
         ::items[::idVar]:Exec( Self )
      ENDIF

   ENDDO

RETURN Self

/*
   NewMenuPos
*/
METHOD NewMenuPos() CLASS HBTui_Menu
RETURN ::idVar
