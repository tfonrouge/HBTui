/*
 *
 */

#include "hbtui.ch"
#include "inkey.ch"

#define _DESKTOP_COLOR  "00/15"
#define _DESKTOP_CHAR   e"\xB1"
#define _WIDGET_COLOR   "11/09"
#define _WIDGET_CHAR    e"\x20"
#define _WIDGET_SHADOW  "00/07"

CLASS HTWidget FROM HTObject
PROTECTED:

    DATA FAsDesktopWidget
    DATA FbtnClosePos
    DATA FBtnHidePos
    DATA FBtnMaximizePos
    DATA FBtnResizePos
    DATA FClearA    INIT "07/15"
    DATA FClearB    INIT _DESKTOP_CHAR
    DATA FColor
    DATA FposDown
    DATA FposUp
    DATA FShadow    INIT _WIDGET_SHADOW
    DATA FwindowId  /* CT Handle */
    DATA FWinSysBtnMove     INIT .F.
    DATA FWinSysBtnClose    INIT .F.
    DATA FWinSysBtnHide     INIT .F.
    DATA FWinSysBtnMaximize INIT .F.
    DATA FWinSysBtnResize   INIT .F.

    METHOD displayLayout()
    METHOD getClearA INLINE ::FClearA
    METHOD getClearB INLINE ::FClearB
    METHOD getColor
    METHOD getPos() INLINE HTPoint():new( ::x, ::y )
    METHOD getShadow INLINE ::FShadow
    METHOD getWindowId()
    METHOD paintMenu()
    METHOD setClearA( clearA ) INLINE ::FClearA := clearA
    METHOD setClearB( clearB ) INLINE ::FClearB := clearB
    METHOD SetColor( color ) INLINE ::FColor := color
    METHOD setShadow( shadow ) INLINE ::FShadow := shadow
    METHOD setWindowId( windowId )

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD addEvent( event, priority )

    METHOD closeEvent( closeEvent )
    METHOD event( event )
    METHOD focusInEvent( eventFocus )
    METHOD focusOutEvent( eventFocus )
    METHOD keyEvent( keyEvent )
    METHOD mouseEvent( eventMouse )
    METHOD move( ... )
    METHOD moveEvent( moveEvent )
    METHOD paintEvent( event )
    METHOD resize( ... )
    METHOD resizeEvent( event )

    METHOD setAsDesktopWidget
    METHOD setBackgroundColor( color )
    METHOD setFocus()
    METHOD setForegroundColor( color )
    METHOD setLayout( layout )
    METHOD setWindowFlags( type ) INLINE ::FwindowFlags := type
    METHOD setWindowTitle( title )

    METHOD show()
    METHOD showEvent( showEvent )

    PROPERTY actions
    PROPERTY backgroundColor WRITE setBackgroundColor
    PROPERTY charWidgetClose INIT hb_BChar( 254 )
    PROPERTY charWidgetHide INIT Chr( 25 )
    PROPERTY charWidgetMaximize INIT Chr( 18 )
    PROPERTY charWidgetResize INIT "<>" //Chr( 254 )
    PROPERTY clearA READ getClearA WRITE setClearA
    PROPERTY clearB READ getClearB WRITE setClearB
    PROPERTY color READ getColor WRITE SetColor
    PROPERTY foregroundColor WRITE setForegroundColor
    PROPERTY height
    PROPERTY isVisible INIT .F.
    PROPERTY layout WRITE setLayout
    PROPERTY pos READ getPos()
    PROPERTY shadow READ getShadow WRITE setShadow
    PROPERTY size
    PROPERTY width
    PROPERTY windowFlags
    PROPERTY windowId READ getWindowId WRITE setWindowId /* only main windows have it */
    PROPERTY windowTitle INIT ""
    PROPERTY x INIT 0
    PROPERTY y INIT 0

ENDCLASS

/*
    new
*/
METHOD new( ... ) CLASS HTWidget
    ::Factions := { }
    SWITCH pCount()
    CASE 0
        EXIT
    CASE 1
    CASE 2
        ::super:new( hb_pValue( 1 ) )
        ::setWindowFlags( hb_pValue( 2 ) )
        EXIT
    OTHERWISE
        ::PARAM_ERROR()
    ENDSWITCH
RETURN Self

/*
    addEvent
*/
METHOD PROCEDURE addEvent( event, priority ) CLASS HTWidget
    event:setWidget( Self )
    HTApplication():queueEvent( event, priority )
RETURN

/*
    closeEvent
*/
METHOD PROCEDURE closeEvent( closeEvent ) CLASS HTWidget
    closeEvent:accept()
    IF ::FwindowId != NIL
        WClose( ::FwindowId )
    ENDIF
RETURN

/*
    displayLayout
*/
METHOD PROCEDURE displayLayout() CLASS HTWidget
    LOCAL itm

    FOR EACH itm IN ::Flayout
    NEXT

RETURN

/*
    event
*/
METHOD FUNCTION event( event ) CLASS HTWidget

    SWITCH event:type
    CASE HT_EVENT_TYPE_CLOSE
        ::closeEvent( event )
        EXIT
    CASE HT_EVENT_TYPE_FOCUSIN
        ::focusInEvent( event )
        EXIT
    CASE HT_EVENT_TYPE_FOCUSOUT
        ::focusOutEvent( event )
        EXIT
    CASE HT_EVENT_TYPE_KEYBOARD
        ::keyEvent( event )
        EXIT
    CASE HT_EVENT_TYPE_MOUSE
        ::mouseEvent( event )
        EXIT
    CASE HT_EVENT_TYPE_MOVE
        ::moveEvent( event )
        EXIT
    CASE HT_EVENT_TYPE_PAINT
        ::paintEvent( event )
        EXIT
    CASE HT_EVENT_TYPE_RESIZE
        ::resizeEvent( event )
        EXIT
    CASE HT_EVENT_TYPE_SHOW
        ::showEvent( event )
        EXIT
    OTHERWISE
        RETURN ::super:event( event )
    ENDSWITCH

    IF ! event:isAccepted() .AND. ::Fparent != NIL
        RETURN ::Fparent:event( event )
    ENDIF

RETURN event:accept()

/*
    focusInEvent
*/
METHOD PROCEDURE focusInEvent( eventFocus ) CLASS HTWidget
    eventFocus:accept()
    IF eventFocus:isAccepted()
        wSelect( ::windowId )
        IF MLeftDown()
            ::addEvent( HTMouseEvent():new( K_LBUTTONDOWN ) )
        ENDIF
    ENDIF
RETURN

/*
    focusOutEvent
*/
METHOD PROCEDURE focusOutEvent( eventFocus ) CLASS HTWidget
    IF eventFocus:isAccepted()

    ENDIF
RETURN

/*
    getColor
*/
METHOD FUNCTION getColor CLASS HTWidget
    IF ::FColor != NIL
        RETURN ::FColor
    ELSE
        IF ::Fparent != NIL
            RETURN ::Fparent:Color
        ENDIF
    ENDIF
RETURN iif( ::FAsDesktopWidget = .T., _DESKTOP_COLOR, _WIDGET_COLOR )

/*
    getWindowId
*/
METHOD FUNCTION getWindowId() CLASS HTWidget
    IF ::FwindowId = NIL .AND. ::Fparent != NIL
        RETURN ::parent:windowId
    ENDIF
RETURN ::FwindowId

/*
    keyEvent
*/
METHOD PROCEDURE keyEvent( keyEvent ) CLASS HTWidget
    HB_SYMBOL_UNUSED( keyEvent )
RETURN

/*
    mouseEvent
*/
METHOD PROCEDURE mouseEvent( eventMouse ) CLASS HTWidget
    LOCAL pos
    LOCAL x
    LOCAL y

    SWITCH eventMouse:nKey
    CASE K_LBUTTONDOWN

        ::FposUp := NIL
        ::FposDown := HTPoint():new( eventMouse:mouseCol, eventMouse:mouseRow )

        ::FWinSysBtnClose := ::FbtnClosePos != NIL .AND. ::FposDown:y = -1 .AND. ::FposDown:x >= ::FbtnClosePos[ 1 ] .AND. ::FposDown:x <= ::FbtnClosePos[ 2 ]

        ::FWinSysBtnHide := ::FBtnHidePos != NIL .AND. ::FposDown:y = -1 .AND. ::FposDown:x >= ::FBtnHidePos[ 1 ] .AND. ::FposDown:x <= ::FBtnHidePos[ 2 ]

        ::FWinSysBtnMaximize := ::FBtnMaximizePos != NIL .AND. ::FposDown:y = -1 .AND. ::FposDown:x >= ::FBtnMaximizePos[ 1 ] .AND. ::FposDown:x <= ::FBtnMaximizePos[ 2 ]

        ::FWinSysBtnResize := ::FBtnResizePos != NIL .AND. ::FposDown:y = ( ::Fheight - 1 ) .AND. ::FposDown:x >= ::FBtnResizePos[ 1 ] .AND. ::FposDown:x <= ::FBtnResizePos[ 2 ]

        IF ::FposDown:y = -1 .AND. ! ::FWinSysBtnClose .AND. ! ::FWinSysBtnHide .AND. ! ::FWinSysBtnMaximize .AND. ! ::FWinSysBtnResize
            ::FWinSysBtnMove := .T.
        ENDIF

        IF HTApplication():activeWindow() = NIL .OR. HTApplication():activeWindow():windowId != ::windowId
            ::addEvent( HTFocusEvent():new( HT_EVENT_TYPE_FOCUSIN ) )
        ENDIF

        EXIT

    CASE K_LBUTTONUP

        ::FposDown := NIL
        ::FposUp := HTPoint():new( eventMouse:mouseCol, eventMouse:mouseRow )

        /* Close Event */
        IF ::FposUp:y = -1 .AND. ::FWinSysBtnClose .AND. ::FposUp:x >= ::FbtnClosePos[ 1 ] .AND. ::FposUp:x <= ::FbtnClosePos[ 2 ]
            ::addEvent( HTCloseEvent():new() )
        ENDIF

        /* Hide Event */
        IF ::FposUp:y = -1 .AND. ::FWinSysBtnHide .AND. ::FposUp:x >= ::FBtnHidePos[ 1 ] .AND. ::FposUp:x <= ::FBtnHidePos[ 2 ]
            ::addEvent( HTHideEvent():new() )
        ENDIF

        /* Maximize Event */
        IF ::FposUp:y = -1 .AND. ::FWinSysBtnMaximize .AND. ::FposUp:x >= ::FBtnMaximizePos[ 1 ] .AND. ::FposUp:x <= ::FBtnMaximizePos[ 2 ]
            ::addEvent( HTMaximizeEvent():new() )
        ENDIF

        ::FWinSysBtnMove     := .F.
        ::FWinSysBtnClose    := .F.
        ::FWinSysBtnHide     := .F.
        ::FWinSysBtnMaximize := .F.

        EXIT

    CASE K_MOUSEMOVE

        IF ::FposDown != NIL

            x := mCol( .T. ) - ( ::FposDown:x + 1 )
            y := mRow( .T. )

            IF MLeftDown()
                IF ::FWinSysBtnMove
                    pos := HTPoint():new( x, y )
                    ::addEvent( HTMoveEvent():new( pos, ::pos ) )
                ENDIF
                IF ::FWinSysBtnResize
                    ::addEvent( HTResizeEvent():new() )
                ENDIF
            ENDIF

        ENDIF

    ENDSWITCH

RETURN

/*
    move
*/
METHOD PROCEDURE move( ... ) CLASS HTWidget
    LOCAL moveEvent

    SWITCH pCount()
    CASE 2
        moveEvent := HTMoveEvent():new( HTPoint():new( hb_pValue( 1 ), hb_pValue( 2 ) ), ::pos )
        EXIT
    CASE 1
        moveEvent := HTMoveEvent():new( hb_pValue( 1 ), ::pos )
        EXIT
    ENDSWITCH
    IF moveEvent != NIL
        ::addEvent( moveEvent )
    ENDIF
RETURN

/*
    moveEvent
*/
METHOD PROCEDURE moveEvent( moveEvent ) CLASS HTWidget

    moveEvent:accept()

    IF ::FwindowId != NIL
        wSelect( ::FwindowId )
        wMove( moveEvent:pos:y, moveEvent:pos:x )
        ::Fx := wCol()
        ::Fy := wRow()
    ENDIF

RETURN

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( event ) CLASS HTWidget
    LOCAL n
    LOCAL child

    HB_SYMBOL_UNUSED( event )

    /* no parent, widget is a window */
    IF ::parent = NIL
        IF ::FwindowId = NIL
            ::Fheight := 10
            ::Fwidth := 40
            IF ::Fx = NIL
                ::Fx := maxRow() / 2 - ::Fheight / 2
            ENDIF
            IF ::Fy = NIL
                ::Fy := maxCol() / 2 - ::Fwidth / 2
            ENDIF
            ::setWindowId( wOpen( ::Fx, ::Fy, ::Fx + ::Fheight, ::Fy + ::Fwidth, .T. ) )
            wFormat()
            setClearB( _WIDGET_CHAR )
            wBox( NIL, ::color )
            n := 0
            IF ::charWidgetClose = NIL
                ::FbtnClosePos := NIL
            ELSE
                ::FbtnClosePos := { n, n += len( ::charWidgetClose ) - 1 }
                dispOutAt( -1, n, ::charWidgetClose, ::color )
                ++n
            ENDIF
            IF ::charWidgetHide = NIL
                ::FBtnHidePos := NIL
            ELSE
                ::FBtnHidePos := { n, n += len( ::charWidgetHide ) - 1 }
                dispOutAt( -1, n, ::charWidgetHide, ::color )
                ++n
            ENDIF
            IF ::charWidgetMaximize = NIL
                ::FBtnMaximizePos := NIL
            ELSE
                ::FBtnMaximizePos := { n, n += len( ::charWidgetMaximize ) - 1 }
                dispOutAt( -1, n, ::charWidgetMaximize, ::color )
                ++n
            ENDIF
            wFormat()
            wFormat( 1, 1, 0, 0 )
            IF ::charWidgetResize = NIL
                ::FBtnResizePos := NIL
            ELSE
                n := len( ::charWidgetResize )
                ::FBtnResizePos := { ::Fwidth - n, ::Fwidth }
                dispOutAt( ::Fheight - 1, ::FBtnResizePos[ 1 ], ::charWidgetResize, ::color )
            ENDIF
            wFormat()
            wFormat( 1, 1, 1, 1 )
        ENDIF
    ENDIF

    IF ::Flayout != NIL
        ::displayLayout()
    ELSE
        FOR EACH child IN ::Fchildren
            IF child:IsDerivedFrom( "HTWidget" )
                child:paintEvent()
            ENDIF
        NEXT
    ENDIF

RETURN

/*
    paintMenu
*/
METHOD PROCEDURE paintMenu() CLASS HTWidget
RETURN

/*
    resize
*/
METHOD PROCEDURE resize( ... ) CLASS HTWidget
    LOCAL eventResize
    SWITCH pCount()
    CASE 2
        eventResize := HTResizeEvent():new( HTSize():new( hb_pValue( 1 ), hb_pValue( 2 ) ), ::size )
        EXIT
    CASE 1
        eventResize := HTResizeEvent():new( hb_pValue( 1 ), ::size )
        EXIT
    ENDSWITCH
    IF eventResize != NIL
        ::addEvent( eventResize )
    ENDIF
RETURN

/*
    resizeEvent
*/
METHOD PROCEDURE resizeEvent( event ) CLASS HTWidget
    HB_SYMBOL_UNUSED( event )
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
    setFocus
*/
METHOD PROCEDURE setFocus() CLASS HTWidget
    LOCAL activeWindow := HTApplication():activeWindow()

    IF ! activeWindow == Self
        IF activeWindow != NIL
            activeWindow:focusOutEvent( NIL )
        ENDIF
        ::focusInEvent( NIL )
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
    setWindowId
*/
METHOD PROCEDURE setWindowId( windowId ) CLASS HTWidget
    IF ::FwindowId = NIL
        ::FwindowId := windowId
        HTApplication():addTopLevelWindow( windowId, Self )
    ENDIF
RETURN

/*
    setWindowTitle
*/
METHOD PROCEDURE setWindowTitle( title ) CLASS HTWidget
    ::FwindowTitle := title
RETURN

/*
    show
*/
METHOD PROCEDURE show() CLASS HTWidget

    ::FisVisible := .T.

    ::addEvent( HTPaintEvent():new() )
    ::addEvent( HTFocusEvent():new( HT_EVENT_TYPE_FOCUSIN ) )
    ::addEvent( HTShowEvent():new() )

RETURN

/*
    showEvent
*/
METHOD PROCEDURE showEvent( showEvent ) CLASS HTWidget
    showEvent:accept()
RETURN

/*
    EndClass
*/
