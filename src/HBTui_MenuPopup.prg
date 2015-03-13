/*
   13-03-2014
*/

#include "hbtui.ch"

CLASS HBTui_MenuPopup FROM HBTui_Menu

PROTECTED:
    VAR     widget
    VAR     width

    METHOD  menuTop, menuLeft

EXPORT:
    METHOD  New( aItems )
    METHOD  Draw()
    METHOD  AddItem( cLabel, oAction, isActive )
    METHOD  exec

    MESSAGE setKeys     IS NULL
    MESSAGE clearKeys   IS NULL

ENDCLASS

/*
   New
*/
METHOD New( aItems ) CLASS HBTui_MenuPopup

    ::width := 0
    ::Super:New( aItems )

RETURN Self

/*
   Draw
*/
METHOD Draw() CLASS HBTui_MenuPopup
    LOCAL nBottom, nRight

    IF ::widget == NIL
        nBottom := ::menuTop + LEN(::items) + 1
        nRight  := ::menuLeft + ::width + 1
        ::widget := HBTui_Widget():New( ::menuTop, ::menuLeft, nBottom, nRight, SNGLBORD )
    ENDIF

    ::Super:Draw()

RETURN Self

/*

*/
METHOD menuTop CLASS HBTui_MenuPopup
RETURN winTop() + ::parent:NewMenuPos()


METHOD menuLeft CLASS HBTui_MenuPopup
RETURN winLeft() + 2


METHOD AddItem( cLabel, oAction, isActive ) CLASS HBTui_MenuPopup
    LOCAL nRow

    // establish screen row for new option
    IF LEN( ::items ) == 0
        nRow := 0
    ELSE
        nRow := ATAIL( ::items ):nextRow
    END

    ::Super:addItem( nRow, 0, cLabel, oAction, isActive )
    ::width := MAX( ::width, LEN( cLabel ) )
RETURN Self


METHOD Exec( oParent ) CLASS HBTui_MenuPopup
    // invoke the exec method in the superclass (HBTui_Menu)
    ::Super:Exec( oParent )
    ::widget:kill()
    ::widget := NIL
RETURN Self
