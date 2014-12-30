/*
 *
 */

#include "hbtui.ch"
#include "inkey.ch"

SINGLETON CLASS HBTui_App FROM HBTui_Object
PROTECTED:

    DATA Fexecute INIT .F.
    
    METHOD FocusEvent( event )
    METHOD SetEventStack( event )

    PROPERTY StateOnMove INIT .F.

PUBLIC:

    METHOD Exec()
    METHOD FocusWindow INLINE HBTui_UI_GetFocusedWindow()
    METHOD GetEvent()

    PROPERTY allWidgets
    PROPERTY eventStack WRITE SetEventStack
    PROPERTY eventStackLen INIT 0

ENDCLASS

/*
  Exec
*/
METHOD FUNCTION Exec() CLASS HBTui_App
    LOCAL result
    LOCAL event
    LOCAL hbtobject

//    AltD()

    IF !::Fexecute

        //Set( _SET_EVENTMASK, INKEY_ALL + HB_INKEY_RAW + HB_INKEY_EXT + HB_INKEY_GTEVENT )
        Set( _SET_EVENTMASK, INKEY_ALL )

        result := 0

        ::Fexecute := .T.

        WHILE ::Fexecute

            ::GetEvent()

            IF ::eventStackLen > 0
            
                event := ::FeventStack[ 1 ]
                ADel( ::FeventStack, 1 )
                --::FeventStackLen

                hbtobject := iif( event:hbtobject = NIL, ::FocusWindow, event:hbtobject )

                SWITCH event:EventType
                CASE HBTUI_UI_EVENT_TYPE_CLOSE
                    hbtobject:CloseEvent( event )
                    EXIT
                CASE HBTUI_UI_EVENT_TYPE_FOCUS
                    ::FocusEvent( event )
                    EXIT
                CASE HBTUI_UI_EVENT_TYPE_KEYBOARD
                    hbtobject:KeyEvent( event )
                    EXIT
                CASE HBTUI_UI_EVENT_TYPE_MOUSE
                    hbtobject:MouseEvent( event )
                    EXIT
                CASE HBTUI_UI_EVENT_TYPE_MOVE
                    hbtobject:MoveEvent( event )
                    EXIT
                CASE HBTUI_UI_EVENT_TYPE_PAINT
                    hbtobject:PaintEvent( event )
                    EXIT
                ENDSWITCH

            ENDIF

        ENDDO

    ELSE

        ::ALREADY_RUNNING_EXEC()

    ENDIF

RETURN result

/*
    FocusEvent
*/
METHOD PROCEDURE FocusEvent( event ) CLASS HBTui_App
    IF .T. //!::FocusWindow == event:hbtobject
        ::FocusWindow:FocusOutEvent( event )
        event:hbtobject:FocusInEvent( event )
    ENDIF
RETURN

/*
  GetEvent
*/
METHOD PROCEDURE GetEvent() CLASS HBTui_App
    LOCAL nKey
    LOCAL mrow := MRow( .T. )
    LOCAL mcol := MCol( .T. )

    STATIC mCoords

    IF mCoords = NIL
        mCoords := { mrow, mcol }
    ENDIF

    IF mCoords[ 1 ] != mrow .OR. mCoords[ 2 ] != mcol
        HBTui_App():FocusWindow():AddEvent( HBTui_EventMouse():New( K_MOUSEMOVE ) )
        mCoords[ 1 ] := mrow
        mCoords[ 2 ] := mcol
        RETURN
    ENDIF

    IF ::eventStackLen > 0
        nKey := Inkey()
    ELSE
        nKey := Inkey( 0.2 )
    ENDIF

    IF nKey != 0
        IF nKey >= K_MINMOUSE .AND. nKey <= K_MAXMOUSE
            HBTui_UI_WindowAtMousePos():AddEvent( HBTui_EventMouse():New( nKey ) )
        ELSE
            HBTui_UI_WindowAtMousePos():AddEvent( HBTui_EventKey():New( nKey ) )
        ENDIF
    ENDIF

RETURN

/*
    SetEventStack
*/
METHOD PROCEDURE SetEventStack( event ) CLASS HBTui_App
    IF ::FeventStack = NIL
        ::FeventStack := {}
    ENDIF
    IF ::FeventStackLen < HBTUI_UI_STACK_EVENT_SIZE
        ++::FeventStackLen
        IF Len( ::FeventStack ) < ::FeventStackLen
            ASize( ::FeventStack, ::FeventStackLen )
        ENDIF
        ::FeventStack[ ::FeventStackLen ] := event
    ENDIF
RETURN
