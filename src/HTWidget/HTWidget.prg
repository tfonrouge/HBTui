/*
 *
 */

#include "hbtui.ch"
#include "inkey.ch"

#define _DESKTOP_COLOR  "03/01"
#define _DESKTOP_CHAR   e"\xB1"
#define _WIDGET_COLOR   "11/09"
#define _WIDGET_CHAR    e"\x20"
#define _WIDGET_SHADOW  8

CLASS HTWidget FROM HTObject

PROTECTED:

    DATA Factions
    DATA FAsDesktopWidget
    DATA FbtnClosePos
    DATA FBtnHidePos
    DATA FbtnMaximizePos
    DATA FbtnResizePos
    DATA FclearA    INIT "07/15"
    DATA FclearB    INIT _DESKTOP_CHAR
    DATA Fcolor
    DATA FposDown
//    DATA FposUp
    DATA Fshadow    INIT _WIDGET_SHADOW
    DATA FwindowId  /* CT Handle */
    DATA FwinSysBtnMove     INIT .F.
    DATA FwinSysBtnClose    INIT .F.
    DATA FwinSysBtnHide     INIT .F.
    DATA FwinSysBtnMaximize INIT .F.
    DATA FwinSysBtnResize   INIT .F.

    METHOD displayLayout()
    METHOD getClearA INLINE ::FclearA
    METHOD getClearB INLINE ::FclearB
    METHOD getColor
    METHOD getPos() INLINE HTPoint():new( ::x, ::y )
    METHOD getShadow INLINE ::Fshadow
    METHOD getWindowId()
    METHOD paintTopLevelWindow()
    METHOD paintWidget()
    METHOD setClearA( clearA ) INLINE ::FclearA := clearA
    METHOD setClearB( clearB ) INLINE ::FclearB := clearB
    METHOD SetColor( color ) INLINE ::Fcolor := color
    METHOD setShadow( shadow ) INLINE ::Fshadow := shadow
    METHOD setWindowId( windowId )

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD actions()
    METHOD addAction( action )
    METHOD addEvent( target, event, priority )

    METHOD closeEvent( closeEvent )
    METHOD event( event )
    METHOD focusInEvent( eventFocus )
    METHOD focusOutEvent( eventFocus )
    METHOD keyEvent( keyEvent )
    METHOD mouseEvent( eventMouse )
    METHOD move( ... )
    METHOD moveEvent( moveEvent )
    METHOD paintEvent( event )
    METHOD repaint()
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

    METHOD windowType() INLINE hb_bitAnd( ::windowFlags, 0x000000ff )

    PROPERTY backgroundColor WRITE setBackgroundColor
    PROPERTY charWidgetClose    INIT hb_BChar( 254 )
    PROPERTY charWidgetHide     INIT hb_BChar( 254 )
    PROPERTY charWidgetMaximize INIT hb_BChar( 254 )
    PROPERTY charWidgetResize INIT "<>" //Chr( 254 )
    PROPERTY clearA READ getClearA WRITE setClearA
    PROPERTY clearB READ getClearB WRITE setClearB
    PROPERTY color READ getColor WRITE SetColor
    PROPERTY foregroundColor WRITE setForegroundColor
    PROPERTY height INIT 0
    PROPERTY isVisible INIT .F.
    PROPERTY layout WRITE setLayout
    PROPERTY pos READ getPos()
    PROPERTY shadow READ getShadow WRITE setShadow
    PROPERTY size
    PROPERTY width INIT 0
    PROPERTY windowFlags INIT 0
    PROPERTY windowId READ getWindowId WRITE setWindowId /* only main windows have it */
    PROPERTY windowTitle INIT ""
    PROPERTY x INIT 0
    PROPERTY y INIT 0

    /* */

    PROPERTY posUp

    /* */

ENDCLASS

/*
    new
*/
METHOD new( ... ) CLASS HTWidget

    LOCAL version := 0
    LOCAL parent
    LOCAL f

    ::Factions := {}

    IF pCount() <= 2
        parent := hb_pValue( 1 )
        f := hb_pValue( 2 )
        IF parent == NIL .OR. hb_isObject( parent )
            version := 1
        ENDIF
    ENDIF

    SWITCH version
    CASE 1
        ::super:new( parent )
        ::setWindowFlags( f )
        EXIT
    OTHERWISE
        ::PARAM_ERROR()
    ENDSWITCH

RETURN self

/*
    actions
*/
METHOD FUNCTION actions() CLASS HTWidget

RETURN ::Factions

/*
    addAction
*/
METHOD PROCEDURE addAction( action ) CLASS HTWidget
    IF AScan( ::Factions, action ) = 0
        AAdd( ::Factions, action )
    ENDIF
RETURN

/*
    addEvent
*/
METHOD PROCEDURE addEvent( target, event, priority ) CLASS HTWidget
    event:setWidget( self )
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
    LOCAL parent

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

    parent := ::parent()

    IF ! event:isAccepted() .AND. parent != NIL
        RETURN parent:event( event )
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
    LOCAL parent

    IF ::Fcolor != NIL
        RETURN ::Fcolor
    ELSE
        parent := ::parent()
        IF parent != NIL
            RETURN parent:Color
        ENDIF
    ENDIF
RETURN IIF( ::FAsDesktopWidget = .T., _DESKTOP_COLOR, _WIDGET_COLOR )

/*
    getWindowId
*/
METHOD FUNCTION getWindowId() CLASS HTWidget
    LOCAL parent := ::parent()
    IF ::FwindowId = NIL .AND. parent != NIL
        RETURN parent:windowId
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

    LOCAL x
    LOCAL y

    SWITCH eventMouse:nKey
    CASE K_LBUTTONDOWN

        ::FposUp := NIL
        ::FposDown := HTPoint():new( eventMouse:mouseCol, eventMouse:mouseRow )

        ::FwinSysBtnClose := ::FbtnClosePos != NIL .AND. ::FposDown:y = 0 .AND. ::FposDown:x >= ::FbtnClosePos[ 1 ] .AND. ::FposDown:x <= ::FbtnClosePos[ 2 ]

        ::FwinSysBtnHide := ::FBtnHidePos != NIL .AND. ::FposDown:y = 0 .AND. ::FposDown:x >= ::FBtnHidePos[ 1 ] .AND. ::FposDown:x <= ::FBtnHidePos[ 2 ]

        ::FwinSysBtnMaximize := ::FbtnMaximizePos != NIL .AND. ::FposDown:y = 0 .AND. ::FposDown:x >= ::FbtnMaximizePos[ 1 ] .AND. ::FposDown:x <= ::FbtnMaximizePos[ 2 ]

        ::FwinSysBtnResize := ::FbtnResizePos != NIL .AND. ::FposDown:y = ( ::Fheight - 1 ) .AND. ::FposDown:x >= ::FbtnResizePos[ 1 ] .AND. ::FposDown:x <= ::FbtnResizePos[ 2 ]

        IF ::FposDown:y = 0 .AND. ! ::FwinSysBtnClose .AND. ! ::FwinSysBtnHide .AND. ! ::FwinSysBtnMaximize .AND. ! ::FwinSysBtnResize
            ::FwinSysBtnMove := .T.
        ENDIF

        OutStd( ::FposDown:y, ::FposDown:x, e"\n" )

        IF HTApplication():activeWindow() = NIL .OR. HTApplication():activeWindow():windowId != ::windowId
            ::addEvent( HTFocusEvent():new( HT_EVENT_TYPE_FOCUSIN ) )
        ENDIF

        EXIT

    CASE K_LBUTTONUP

        ::FposDown := NIL
        ::FposUp := HTPoint():new( eventMouse:mouseCol, eventMouse:mouseRow )

        /* Close Event */
        IF ::FposUp:y = 0 .AND. ::FwinSysBtnClose .AND. ::FposUp:x >= ::FbtnClosePos[ 1 ] .AND. ::FposUp:x <= ::FbtnClosePos[ 2 ]
            ::addEvent( HTCloseEvent():new() )
        ENDIF

        /* Hide Event */
        IF ::FposUp:y = 0 .AND. ::FwinSysBtnHide .AND. ::FposUp:x >= ::FBtnHidePos[ 1 ] .AND. ::FposUp:x <= ::FBtnHidePos[ 2 ]
            ::addEvent( HTHideEvent():new() )
        ENDIF

        /* Maximize Event */
        IF ::FposUp:y = 0 .AND. ::FwinSysBtnMaximize .AND. ::FposUp:x >= ::FbtnMaximizePos[ 1 ] .AND. ::FposUp:x <= ::FbtnMaximizePos[ 2 ]
            ::addEvent( HTMaximizeEvent():new() )
        ENDIF

        ::FwinSysBtnMove     := .F.
        ::FwinSysBtnClose    := .F.
        ::FwinSysBtnHide     := .F.
        ::FwinSysBtnMaximize := .F.

        EXIT

    CASE K_MOUSEMOVE

        IF ::FposDown != NIL

            x := mCol( .T. ) - ( ::FposDown:x + 1 )
            y := mRow( .T. )

            IF MLeftDown()
                IF ::FwinSysBtnMove
                    ::move( HTPoint():new( x, y ) )
                ELSEIF ::FwinSysBtnResize
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
    LOCAL pos

    SWITCH PCount()
    CASE 1
        pos := HB_PValue( 1 )
        IF HB_IsObject( pos ) .AND. pos:classH = HTPoint():classH
            ::addEvent( HTMoveEvent():new( pos, ::pos ) )
            RETURN
        ENDIF
        EXIT
    CASE 2
        IF hb_isNumeric( HB_PValue( 1 ) ) .AND. hb_isNumeric( HB_PValue( 2 ) )
            ::addEvent( HTMoveEvent():new( HTPoint():new( HB_PValue(1), HB_PValue(2) ), ::pos ) )
            RETURN
        ENDIF
        EXIT
    ENDSWITCH

    ::PARAM_ERROR()

RETURN

/*
    moveEvent
*/
METHOD PROCEDURE moveEvent( moveEvent ) CLASS HTWidget
    LOCAL pos

    pos := moveEvent:pos

    IF ::FwindowId != NIL
        wSelect( ::FwindowId, .F. )
        wMove( pos:y, pos:x )
    ELSE
        ::Fx := pos:x
        ::Fy := pos:y
        ::repaint()
    ENDIF

RETURN

/*
    paintEvent
*/
METHOD PROCEDURE paintEvent( event ) CLASS HTWidget

    HB_SYMBOL_UNUSED( event )

    /* no parent, widget has/is a top level window */
    IF ::FwindowId != NIL .OR. ( ::parent = NIL .AND. ::FwindowId = NIL )
        ::paintTopLevelWindow()
    ENDIF

    ::paintWidget()

RETURN

/*
    paintTopLevelWindow
*/
METHOD PROCEDURE paintTopLevelWindow() CLASS HTWidget

    LOCAL n

    ::Fheight := 10
    ::Fwidth := 40

    IF ::Fx = NIL
        ::Fx := MaxRow() / 2 - ::Fheight / 2
    ENDIF

    IF ::Fy = NIL
        ::Fy := MaxCol() / 2 - ::Fwidth / 2
    ENDIF

    ::setWindowId( wOpen( ::Fx, ::Fy, ::Fx + ::Fheight - 1, ::Fy + ::Fwidth - 1, .T. ) )

    SetClearB( _WIDGET_CHAR )
    wBox( NIL, ::color ) /* border window */
    wFormat()

    n := 1

    IF ::charWidgetClose = NIL
        ::FbtnClosePos := NIL
    ELSE
        ::FbtnClosePos := { n, n += Len( ::charWidgetClose ) - 1 }
        DispOutAt( 0, n, ::charWidgetClose, "04/09" )
        ++n
    ENDIF

    IF ::charWidgetHide = NIL
        ::FBtnHidePos := NIL
    ELSE
        ::FBtnHidePos := { n, n += Len( ::charWidgetHide ) - 1 }
        DispOutAt( 0, n, ::charWidgetHide, "14/09" )
        ++n
    ENDIF

    IF ::charWidgetMaximize = NIL
        ::FbtnMaximizePos := NIL
    ELSE
        ::FbtnMaximizePos := { n, n += Len( ::charWidgetMaximize ) - 1 }
        DispOutAt( 0, n, ::charWidgetMaximize, "02/09" )
        ++n
    ENDIF

    IF ::charWidgetResize = NIL
        ::FbtnResizePos := NIL
    ELSE
        n := Len( ::charWidgetResize )
        ::FbtnResizePos := { ::Fwidth - n, ::Fwidth }
        DispOutAt( ::Fheight - 1, ::FbtnResizePos[ 1 ], ::charWidgetResize, ::color )
    ENDIF

    wFormat()

RETURN

/*
    paintWidget
*/
METHOD PROCEDURE paintWidget() CLASS HTWidget

    LOCAL menuBar := ht_objectFromId( ::FmenuBar )
    LOCAL child

    IF menuBar != NIL
        menuBar:repaint()
    ENDIF

    IF ::Flayout != NIL
        ::displayLayout()
    ELSE
        FOR EACH child IN ::Fchildren
            IF ! menuBar == child .AND. child:isDerivedFrom( "HTWidget" )
                child:repaint()
            ENDIF
        NEXT
    ENDIF

RETURN

/*
    repaint
*/
METHOD PROCEDURE repaint() CLASS HTWidget
    ::paintEvent()
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

    IF ! activeWindow == self
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
        HTApplication():addTopLevelWindow( windowId, self )
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
