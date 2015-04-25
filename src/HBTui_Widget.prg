/*
 *
 */

#include "hbtui.ch"
#include "inkey.ch"

CLASS HTWidget FROM HTObject
PROTECTED:

    DATA FWid
    DATA FWinSysActMove     INIT .F.
    DATA FWinSysBtnClose    INIT .F.
    DATA FWinSysBtnHide     INIT .F.
    DATA FWinSysBtnMaximize INIT .F.
    DATA FMoveOrigin

    METHOD DisplayChildren()
    METHOD displayLayout()
    METHOD DrawWindow()
    METHOD GetWId()
    METHOD SetWId( wId )

PUBLIC:

    METHOD AddEvent( event )
    METHOD SetFocus()
    METHOD Show()

    METHOD CloseEvent( closeEvent )
    METHOD FocusInEvent( eventFocus )
    METHOD FocusOutEvent( eventFocus )
    METHOD KeyEvent( keyEvent )
    METHOD MouseEvent( eventMouse )
    METHOD MoveEvent( moveEvent )
    METHOD PaintEvent( event )

    METHOD setLayout( layout )

    PROPERTY charWidgetClose INIT hb_BChar( 254 )
    PROPERTY charWidgetHide INIT Chr( 25 )
    PROPERTY charWidgetMaximize INIT Chr( 18 )
    PROPERTY height READWRITE
    PROPERTY layout WRITE setLayout
    PROPERTY WId READ GetWId WRITE SetWId /* only main windows have it */
    PROPERTY width READWRITE
    PROPERTY x READWRITE
    PROPERTY y READWRITE

ENDCLASS

/*
    AddEvent
*/
METHOD PROCEDURE AddEvent( event ) CLASS HTWidget
    OutStd("on AddEvent: " + event:ClassName +E"\n" )
    event:hbtObject := HTUI_UnRefCountCopy( Self )
    HTApplication():eventStack := event
RETURN

/*
  CloseEvent
*/
METHOD PROCEDURE CloseEvent( closeEvent ) CLASS HTWidget
    HB_SYMBOL_UNUSED( closeEvent )
    WClose( ::FWId )
RETURN

/*
  DisplayChildren
*/
METHOD PROCEDURE DisplayChildren() CLASS HTWidget
    LOCAL child

    IF ::Flayout != NIL
        ::displayLayout()
    ELSE
        FOR EACH child IN ::Fchildren
            IF child:IsDerivedFrom( "HTWidget" )
                child:PaintEvent()
            ENDIF
        NEXT
    ENDIF

RETURN

/*
    displayLayout
*/
METHOD PROCEDURE displayLayout() CLASS HTWidget
    LOCAL itm

//    AltD()
    FOR EACH itm IN ::Flayout
    NEXT

RETURN

/*
    DrawWindow
*/
METHOD PROCEDURE DrawWindow() CLASS HTWidget
    IF ::FWId = NIL
        ::Fheight := 10
        ::FWidth := 20
        IF ::Fx = NIL
            ::Fx := MaxRow() / 2 - ::Fheight / 2
        ENDIF
        IF ::Fy = NIL
            ::Fy := MaxCol() / 2 - ::Fwidth / 2
        ENDIF
        ::SetWId( WOpen( ::Fx, ::Fy, ::Fx + ::Fheight, ::Fy + ::Fwidth, .T. ) )
        WBox()
        //DevOut( 0, 1, Chr( 254 ) )
        @ -1, 0 SAY ::charWidgetClose + ::charWidgetHide + ::charWidgetMaximize
        HTUI_SetFocusedWindow( Self )
    ENDIF
RETURN

/*
    FocusInEvent
*/
METHOD PROCEDURE FocusInEvent( eventFocus ) CLASS HTWidget
    IF eventFocus:IsAccepted
        WSelect( ::WId )
        HTUI_SetFocusedWindow( Self )
        ::DisplayChildren()
    ENDIF
RETURN

/*
    FocusOutEvent
*/
METHOD PROCEDURE FocusOutEvent( eventFocus ) CLASS HTWidget
    IF eventFocus:IsAccepted

    ENDIF
RETURN

/*
    GetWId
*/
METHOD FUNCTION GetWId() CLASS HTWidget
    IF ::FWId = NIL .AND. ::Fparent != NIL
        RETURN ::parent:WId
    ENDIF
RETURN ::FWId

/*
    KeyEvent
*/
METHOD PROCEDURE KeyEvent( keyEvent ) CLASS HTWidget
    HB_SYMBOL_UNUSED( keyEvent )
RETURN

/*
    MouseEvent
*/
METHOD PROCEDURE MouseEvent( eventMouse ) CLASS HTWidget

    IF eventMouse:nKey = K_LBUTTONDOWN
    
        ::FWinSysBtnClose := eventMouse:MouseRow = -1 .AND. eventMouse:MouseCol = 0

        IF ! ( ::FWinSysBtnClose .OR. ::FWinSysBtnHide .OR. ::FWinSysBtnMaximize ) .AND. eventMouse:MouseRow = -1
            ::FWinSysActMove := .T.
        ENDIF

        IF HTApplication():FocusWindow = NIL .OR. HTApplication():FocusWindow:WId != ::WId
            ::AddEvent( HTEventFocus():New() )
        ENDIF

    ENDIF

    IF eventMouse:nKey = K_LBUTTONUP

        ::FMoveOrigin := NIL
        
        /* Close Event */
        IF eventMouse:MouseRow = -1 .AND. eventMouse:MouseCol = 0 .AND. ::FWinSysBtnClose
            ::AddEvent( HTEventClose():New() )
        ENDIF

        ::FWinSysActMove     := .F.
        ::FWinSysBtnClose    := .F.
        ::FWinSysBtnHide     := .F.
        ::FWinSysBtnMaximize := .F.

    ELSEIF MLeftDown() .AND. eventMouse:nKey = K_MOUSEMOVE .AND. ::FWinSysActMove
        IF ::FMoveOrigin = NIL
            ::FMoveOrigin := { MRow(), MCol() }
        ENDIF
        ::AddEvent( HTEventMove():New() )
    ENDIF

RETURN

/*
    MoveEvent
*/
METHOD PROCEDURE MoveEvent( moveEvent ) CLASS HTWidget

//    ? Seconds(), moveEvent:MouseAbsRow, moveEvent:MouseAbsCol
    WMove( moveEvent:MouseAbsRow, moveEvent:MouseAbsCol - ::FMoveOrigin[ 2 ] )

RETURN

/*
    PaintEvent
*/
METHOD PROCEDURE PaintEvent( event ) CLASS HTWidget

    HB_SYMBOL_UNUSED( event )

    IF ::Fparent = NIL /* window */

        ::DrawWindow()

    ELSE /* widget ctrl */

        ::DrawControl()

    ENDIF

RETURN

/*
  SetFocus
*/
METHOD PROCEDURE SetFocus() CLASS HTWidget
    LOCAL focusWindow := HTApplication():FocusWindow()

    IF !focusWindow == Self
        IF focusWindow != NIL
            focusWindow:FocusOutEvent( NIL )
        ENDIF
        ::FocusInEvent( NIL )
    ENDIF

RETURN

/*
    setLayout
*/
METHOD PROCEDURE setLayout( layout ) CLASS HTWidget
    IF ::Flayout = NIL
        ::Flayout := layout
    ENDIF
RETURN

/*
    SetWId
*/
METHOD PROCEDURE SetWId( wId ) CLASS HTWidget
    IF ::FWId = NIL
        ::FWId := wId
        HTUI_AddMainWidget( Self )  
    ENDIF
RETURN

/*
  Show
*/
METHOD PROCEDURE Show() CLASS HTWidget
    ::AddEvent( HTEventPaint():New() )
    ::AddEvent( HTEventFocus():New() )
RETURN
