/*
 *
 */

#include "hbtui.ch"

STATIC s_FocusedWindow
STATIC s_MainWidget

/*
    HBTui_Object
*/
CLASS HBTui_Object FROM HBTui_Base
PROTECTED:
    METHOD AddChild( child )
PUBLIC:

    CONSTRUCTOR New( parent )

    METHOD SetParent( parent )

    PROPERTY children INIT {}
    PROPERTY parent WRITE SetParent

ENDCLASS

/*
  New
*/
METHOD New( parent ) CLASS HBTui_Object
    ::SetParent( parent )
RETURN Self

/*
  AddChild
*/
METHOD PROCEDURE AddChild( child ) CLASS HBTui_Object
    AAdd( ::Fchildren, child )
RETURN

/*
  SetParent
*/
METHOD PROCEDURE SetParent( parent ) CLASS HBTui_Object
    IF parent != NIL
        IF parent:IsDerivedFrom("HBTui_Object")
            ::Fparent := parent
            parent:AddChild( Self )
        ELSE
            ::Error_Parent_Is_Not_Derived_From_TXObject()
        ENDIF
    ENDIF
RETURN

/*
    End HBTui_Object Class
*/

/*
    HBTui_UI_AddMainWidget
*/
FUNCTION HBTui_UI_AddMainWidget( widget )
    IF s_MainWidget = NIL
        s_MainWidget := {}
    ENDIF
    IF Len( s_MainWidget ) < widget:WId
        ASize( s_MainWidget, widget:WId )
    ENDIF
    s_MainWidget[ widget:WId ] := HBTui_UI_UnRefCountCopy( widget )
RETURN s_MainWidget

/*
  HBTui_UI_GetFocusedWindow
*/
FUNCTION HBTui_UI_GetFocusedWindow()
    IF s_FocusedWindow = NIL
        RETURN HBTui_Desktop()
    ENDIF
RETURN s_FocusedWindow

/*
  HBTui_UI_SetFocusedWindow
*/
FUNCTION HBTui_UI_SetFocusedWindow( window )
  LOCAL oldWindow

  oldWindow := s_FocusedWindow
  s_FocusedWindow := window

RETURN oldWindow

/*
    HBTui_UI_WindowAtMousePos
*/
FUNCTION HBTui_UI_WindowAtMousePos()
    LOCAL wId := HBTui_UI_WIdAtMousePos()

    IF s_MainWidget != NIL .AND. wId > 0 .AND. wId <= Len( s_MainWidget )
        RETURN s_MainWidget[ wId ]
    ENDIF

RETURN HBTui_Desktop()
