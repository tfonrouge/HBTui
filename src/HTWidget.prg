/*
 *
 */

#include "hbtui.ch"
#include "inkey.ch"

#define _DESKTOP_COLOR  "00/15"
#define _DESKTOP_CHAR   e"\xB0"
#define _WIDGET_COLOR   "11/09"
#define _WIDGET_CHAR    e"\xB1"
#define _WIDGET_SHADOW  "00/07"

CLASS HTWidget FROM HTObject
PROTECTED:

    DATA FAsDesktopWidget
    DATA FClearA    INIT "07/15"
    DATA FClearB    INIT _DESKTOP_CHAR
    DATA FColor
    DATA FShadow    INIT _WIDGET_SHADOW
    DATA FWid
    DATA FWinSysActMove     INIT .F.
    DATA FWinSysBtnClose    INIT .F.
    DATA FWinSysBtnHide     INIT .F.
    DATA FWinSysBtnMaximize INIT .F.
    DATA FMoveOrigin

    METHOD DisplayChildren()
    METHOD displayLayout()
    METHOD DrawWindow()
    METHOD GetClearA INLINE ::FClearA
    METHOD GetClearB INLINE ::FClearB
    METHOD GetColor
    METHOD GetShadow INLINE ::FShadow
    METHOD GetWId()
    METHOD SetClearA( clearA ) INLINE ::FClearA := clearA
    METHOD SetClearB( clearB ) INLINE ::FClearB := clearB
    METHOD SetColor( color ) INLINE ::FColor := color
    METHOD SetShadow( shadow ) INLINE ::FShadow := shadow
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

    METHOD setAsDesktopWidget
    METHOD setBackgroundColor( color )
    METHOD setForegroundColor( color )
    METHOD setLayout( layout )

    PROPERTY backgroundColor WRITE setBackgroundColor
    PROPERTY charWidgetClose INIT hb_BChar( 254 )
    PROPERTY charWidgetHide INIT Chr( 25 )
    PROPERTY charWidgetMaximize INIT Chr( 18 )
    PROPERTY clearA READ GetClearA WRITE SetClearA
    PROPERTY clearB READ GetClearB WRITE SetClearB
    PROPERTY color READ GetColor WRITE SetColor
    PROPERTY foregroundColor WRITE setForegroundColor
    PROPERTY height READWRITE
    PROPERTY layout WRITE setLayout
    PROPERTY shadow READ GetShadow WRITE SetShadow
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
    OutStd( "Closing...", WList(), e"\n" )
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
        SetClearB( _WIDGET_CHAR )
        WBox( NIL, ::color )
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
    GetColor
*/
METHOD FUNCTION GetColor CLASS HTWidget
    IF ::FColor != NIL
        RETURN ::FColor
    ELSE
        IF ::Fparent != NIL
            RETURN ::Fparent:Color
        ENDIF
    ENDIF
RETURN iif( ::FAsDesktopWidget = .T., _DESKTOP_COLOR, _WIDGET_COLOR )

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
    setAsDesktopWidget
*/
METHOD PROCEDURE setAsDesktopWidget CLASS HTWidget

    /* just one widget can be the desktop widget */
    IF ::FAsDesktopWidget = NIL .AND. HTApplication():desktop = NIL
        ::FAsDesktopWidget := .T.
    ENDIF

RETURN

/*
    setBackgroundColor
*/
METHOD FUNCTION setBackgroundColor( color ) CLASS HTWidget
    ::FbackgroundColor := color
RETURN ::FbackgroundColor

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
    setForegroundColor
*/
METHOD FUNCTION setForegroundColor( color ) CLASS HTWidget
    ::FforegroundColor := color
RETURN ::FforegroundColor

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
    IF ::FAsDesktopWidget = .T.
        WBoard() /* available physical screen */
        WMode( .F., .F., .F., .F. ) /* windows cannot be moved outside of screen ( top, left, bottom, right ) */
        WSetShadow( ::FShadow )
        SetClearA( ::FClearA )
        SetClearB( ::FClearB )
        DispBox( 0, 0, MaxRow(), MaxCol(), Replicate( ::FClearB, 9 ), ::color )
        SetPos( 0, 0 )
    ELSE
        ::AddEvent( HTEventPaint():New() )
        ::AddEvent( HTEventFocus():New() )
    ENDIF
RETURN
