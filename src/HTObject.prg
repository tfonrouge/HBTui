/*
 *
 */

#include "hbtui.ch"

STATIC s_FocusedWindow
STATIC s_MainWidget

/*
    HTObject
*/
CLASS HTObject FROM HTBase
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
METHOD New( parent ) CLASS HTObject
    ::SetParent( parent )
RETURN Self

/*
  AddChild
*/
METHOD PROCEDURE AddChild( child ) CLASS HTObject
    AAdd( ::Fchildren, child )
RETURN

/*
  SetParent
*/
METHOD PROCEDURE SetParent( parent ) CLASS HTObject
    IF parent != NIL
        IF parent:IsDerivedFrom("HTObject")
            ::Fparent := parent
            parent:AddChild( Self )
        ELSE
            ::Error_Parent_Is_Not_Derived_From_TXObject()
        ENDIF
    ENDIF
RETURN

/*
    End HTObject Class
*/

/*
    HTUI_AddMainWidget
*/
FUNCTION HTUI_AddMainWidget( widget )
    IF s_MainWidget = NIL
        s_MainWidget := {}
    ENDIF
    IF Len( s_MainWidget ) < widget:WId
        ASize( s_MainWidget, widget:WId )
    ENDIF
    s_MainWidget[ widget:WId ] := HBTui_UI_UnRefCountCopy( widget )
RETURN s_MainWidget

/*
  HTUI_GetFocusedWindow
*/
FUNCTION HTUI_GetFocusedWindow()
    IF s_FocusedWindow = NIL
        RETURN HTDesktop()
    ENDIF
RETURN s_FocusedWindow

/*
  HTUI_SetFocusedWindow
*/
FUNCTION HTUI_SetFocusedWindow( window )
  LOCAL oldWindow

  oldWindow := s_FocusedWindow
  s_FocusedWindow := window

RETURN oldWindow

/*
    HTUI_WindowAtMousePos
*/
FUNCTION HTUI_WindowAtMousePos()
    LOCAL wId := _HT_WidgetAtMousePos()

    IF s_MainWidget != NIL .AND. wId > 0 .AND. wId <= Len( s_MainWidget )
        RETURN s_MainWidget[ wId ]
    ENDIF

RETURN HTDesktop()
