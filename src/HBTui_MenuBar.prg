/*
   13-03-20144
*/

#include "hbtui.ch"
#include "inkey.ch"

#define OPTION_SPACING  4

CLASS HBTui_MenuBar FROM HBTui_Menu

EXPORT:
   METHOD  Draw()
   METHOD  AddItem( cLabel, oAction, isActive )
   METHOD  NewMenuPos()

   MESSAGE setKeys     IS NULL
   MESSAGE clearKeys   IS NULL

ENDCLASS

/*
   AddItem
*/
METHOD AddItem( cLabel, oAction, isActive ) CLASS HBTui_MenuBar
   LOCAL nCol

   // establish screen column for new option
   IF Len(::items) == 0
      nCol := OPTION_SPACING
   ELSE
        nCol := ATAIL( ::items ):NextCol() + OPTION_SPACING
   ENDIF

   // invoke AddItem in the superclass (HBTui_Menu)
   ::Super:AddItem( 0, nCol, cLabel, oAction, isActive )

RETURN Self

/*
   Draw()
*/
METHOD Draw() CLASS HBTui_MenuBar
   winCurrent( 0 )       // selects main screen
   @ 0, 0                // draw the bar
   ::Super:Draw()        // invoke superclass' draw method
RETURN Self

/*
   NewMenuPos()
*/
METHOD NewMenuPos() CLASS HBTui_MenuBar
// tells a child menu where to put itself
RETURN ::items[ ::currPos ]:Col
