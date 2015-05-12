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

    DATA Factions
    DATA FAsDesktopWidget
    DATA FbtnClosePos
    DATA FBtnHidePos
    DATA FbtnMaximizePos
    DATA FbtnResizePos
    DATA FclearA    INIT "07/15"
    DATA FclearB    INIT _DESKTOP_CHAR
    DATA FColor
    DATA FposDown
    DATA FposUp
    DATA FShadow    INIT _WIDGET_SHADOW
    DATA FwindowId  /* CT Handle */
    DATA FwinSysBtnMove     INIT .f.
    DATA FwinSysBtnClose    INIT .f.
    DATA FwinSysBtnHide     INIT .f.
    DATA FwinSysBtnMaximize INIT .f.
    DATA FwinSysBtnResize   INIT .f.

    METHOD displayLayout()
    METHOD getClearA INLINE ::FclearA
    METHOD getClearB INLINE ::FclearB
    METHOD getColor
    METHOD getPos() INLINE HTPoint():new( ::x, ::y )
    METHOD getShadow INLINE ::FShadow
    METHOD getWindowId()
    METHOD paintMenuBar()
    METHOD setClearA( clearA ) INLINE ::FclearA := clearA
    METHOD setClearB( clearB ) INLINE ::FclearB := clearB
    METHOD SetColor( color ) INLINE ::FColor := color
    METHOD setShadow( shadow ) INLINE ::FShadow := shadow
    METHOD setWindowId( windowId )

PUBLIC:

    CONSTRUCTOR new( ... )

    METHOD actions INLINE iif( ::Factions = NIL, ::Factions := {}, NIL ), ::Factions
    METHOD addAction( action )
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

    METHOD windowType() INLINE hb_bitAnd( ::windowFlags, 0x000000ff )

    PROPERTY backgroundColor WRITE setBackgroundColor
    PROPERTY charWidgetClose INIT hb_BChar( 254 )
    PROPERTY charWidgetHide INIT Chr( 25 )
    PROPERTY charWidgetMaximize INIT Chr( 18 )
    PROPERTY charWidgetResize INIT "<>" //Chr( 254 )
    PROPERTY clearA READ getClearA WRITE setClearA
    PROPERTY clearB READ getClearB WRITE setClearB
    PROPERTY color READ getColor WRITE SetColor
    PROPERTY foregroundColor WRITE setForegroundColor
    PROPERTY height INIT 0
    PROPERTY isVisible INIT .f.
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

ENDCLASS

/*
    new
*/
METHOD new( ... ) CLASS HTWidget
    LOCAL version := 0
    LOCAL parent
    LOCAL f

    IF pCount() <= 2
        parent := hb_pValue( 1 )
        f := hb_pValue( 2 )
        IF hb_isNil( parent ) .OR. hb_isObject( parent )
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

RETURN Self

/*
    addAction
*/
METHOD PROCEDURE addAction( action ) CLASS HTWidget
    IF aScan( ::actions, action ) = 0
        aAdd( ::actions, action )
    ENDIF
RETURN

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

    IF ::FColor != NIL
        RETURN ::FColor
    ELSE
        parent := ::parent()
        IF parent != NIL
            RETURN parent:Color
        ENDIF
    ENDIF
RETURN iif( ::FAsDesktopWidget = .t., _DESKTOP_COLOR, _WIDGET_COLOR )

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
    LOCAL pos
    LOCAL x
    LOCAL y

    SWITCH eventMouse:nKey
    CASE K_LBUTTONDOWN

        ::FposUp := NIL
        ::FposDown := HTPoint():new( eventMouse:mouseCol, eventMouse:mouseRow )

        ::FwinSysBtnClose := ::FbtnClosePos != NIL .AND. ::FposDown:y = -1 .AND. ::FposDown:x >= ::FbtnClosePos[ 1 ] .AND. ::FposDown:x <= ::FbtnClosePos[ 2 ]

        ::FwinSysBtnHide := ::FBtnHidePos != NIL .AND. ::FposDown:y = -1 .AND. ::FposDown:x >= ::FBtnHidePos[ 1 ] .AND. ::FposDown:x <= ::FBtnHidePos[ 2 ]

        ::FwinSysBtnMaximize := ::FbtnMaximizePos != NIL .AND. ::FposDown:y = -1 .AND. ::FposDown:x >= ::FbtnMaximizePos[ 1 ] .AND. ::FposDown:x <= ::FbtnMaximizePos[ 2 ]

        ::FwinSysBtnResize := ::FbtnResizePos != NIL .AND. ::FposDown:y = ( ::Fheight - 1 ) .AND. ::FposDown:x >= ::FbtnResizePos[ 1 ] .AND. ::FposDown:x <= ::FbtnResizePos[ 2 ]

        IF ::FposDown:y = -1 .AND. ! ::FwinSysBtnClose .AND. ! ::FwinSysBtnHide .AND. ! ::FwinSysBtnMaximize .AND. ! ::FwinSysBtnResize
            ::FwinSysBtnMove := .t.
        ENDIF

        IF HTApplication():activeWindow() = NIL .OR. HTApplication():activeWindow():windowId != ::windowId
            ::addEvent( HTFocusEvent():new( HT_EVENT_TYPE_FOCUSIN ) )
        ENDIF

        EXIT

    CASE K_LBUTTONUP

        ::FposDown := NIL
        ::FposUp := HTPoint():new( eventMouse:mouseCol, eventMouse:mouseRow )

        /* Close Event */
        IF ::FposUp:y = -1 .AND. ::FwinSysBtnClose .AND. ::FposUp:x >= ::FbtnClosePos[ 1 ] .AND. ::FposUp:x <= ::FbtnClosePos[ 2 ]
            ::addEvent( HTCloseEvent():new() )
        ENDIF

        /* Hide Event */
        IF ::FposUp:y = -1 .AND. ::FwinSysBtnHide .AND. ::FposUp:x >= ::FBtnHidePos[ 1 ] .AND. ::FposUp:x <= ::FBtnHidePos[ 2 ]
            ::addEvent( HTHideEvent():new() )
        ENDIF

        /* Maximize Event */
        IF ::FposUp:y = -1 .AND. ::FwinSysBtnMaximize .AND. ::FposUp:x >= ::FbtnMaximizePos[ 1 ] .AND. ::FposUp:x <= ::FbtnMaximizePos[ 2 ]
            ::addEvent( HTMaximizeEvent():new() )
        ENDIF

        ::FwinSysBtnMove     := .f.
        ::FwinSysBtnClose    := .f.
        ::FwinSysBtnHide     := .f.
        ::FwinSysBtnMaximize := .f.

        EXIT

    CASE K_MOUSEMOVE

        IF ::FposDown != NIL

            x := mCol( .t. ) - ( ::FposDown:x + 1 )
            y := mRow( .t. )

            IF MLeftDown()
                IF ::FwinSysBtnMove
                    pos := HTPoint():new( x, y )
                    ::addEvent( HTMoveEvent():new( pos, ::pos ) )
                ENDIF
                IF ::FwinSysBtnResize
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
            ::setWindowId( wOpen( ::Fx, ::Fy, ::Fx + ::Fheight, ::Fy + ::Fwidth, .t. ) )
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
                ::FbtnMaximizePos := NIL
            ELSE
                ::FbtnMaximizePos := { n, n += len( ::charWidgetMaximize ) - 1 }
                dispOutAt( -1, n, ::charWidgetMaximize, ::color )
                ++n
            ENDIF
            wFormat()
            wFormat( 1, 1, 0, 0 )
            IF ::charWidgetResize = NIL
                ::FbtnResizePos := NIL
            ELSE
                n := len( ::charWidgetResize )
                ::FbtnResizePos := { ::Fwidth - n, ::Fwidth }
                dispOutAt( ::Fheight - 1, ::FbtnResizePos[ 1 ], ::charWidgetResize, ::color )
            ENDIF
            wFormat()
            wFormat( 1, 1, 1, 1 )
        ENDIF
    ENDIF

    ::paintMenuBar()

    IF ::Flayout != NIL
        ::displayLayout()
    ELSE
        FOR EACH child IN ::Fchildren
            IF child:isDerivedFrom( "HTWidget" )
                child:paintEvent()
            ENDIF
        NEXT
    ENDIF

RETURN

/*
    paintMenuBar
*/
METHOD PROCEDURE paintMenuBar() CLASS HTWidget
    LOCAL menuBar := ht_objectFromId( ::FmenuBar )

    AltD()

    IF menuBar != NIL
        wSelect( ::windowId, .f. )
        dispOutAt( 0, 0, padR( e" \xfe ", ::Fwidth, e"\x20" ), "00/07" )
    ENDIF

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
        ::FAsDesktopWidget := .t.
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

    ::FisVisible := .t.

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
