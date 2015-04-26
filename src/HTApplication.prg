/*
 *
 */

#include "hbtui.ch"
#include "inkey.ch"

SINGLETON CLASS HTApplication FROM HTObject
PROTECTED:

    DATA Fexecute INIT .F.
    
    METHOD FocusEvent( event )
    METHOD SetEventStack( event )

    PROPERTY StateOnMove INIT .F.

PUBLIC:

    CONSTRUCTOR New()

    METHOD Exec()
    METHOD FocusWindow INLINE HTUI_GetFocusedWindow()
    METHOD GetEvent()

    PROPERTY allWidgets
    PROPERTY desktop
    PROPERTY eventStack WRITE SetEventStack
    PROPERTY eventStackLen INIT 0

ENDCLASS

/*
    New
*/
METHOD New() CLASS HTApplication
    LOCAL desktop

    IF ::Fdesktop = NIL
        desktop := HTWidget():New()
        desktop:SetAsDesktopWidget()
        ::Fdesktop := desktop
    ENDIF

RETURN Self

/*
  Exec
*/
METHOD FUNCTION Exec() CLASS HTApplication
    LOCAL result
    LOCAL event
    LOCAL hbtobject

//    AltD()

    IF !::Fexecute

        //Set( _SET_EVENTMASK, INKEY_ALL + HB_INKEY_RAW + HB_INKEY_EXT + HB_INKEY_GTEVENT )
        Set( _SET_EVENTMASK, INKEY_ALL )
        SetBlink( .F. )

        result := 0

        /* paint desktop */
        ::Fdesktop:Show()

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
METHOD PROCEDURE FocusEvent( event ) CLASS HTApplication
    IF .T. //!::FocusWindow == event:hbtobject
        ::FocusWindow:FocusOutEvent( event )
        event:hbtobject:FocusInEvent( event )
    ENDIF
RETURN

/*
  GetEvent
*/
METHOD PROCEDURE GetEvent() CLASS HTApplication
    LOCAL nKey
    LOCAL mrow := MRow( .T. )
    LOCAL mcol := MCol( .T. )

    STATIC mCoords

    IF mCoords = NIL
        mCoords := { mrow, mcol }
    ENDIF

    IF mCoords[ 1 ] != mrow .OR. mCoords[ 2 ] != mcol
        HTApplication():FocusWindow():AddEvent( HTEventMouse():New( K_MOUSEMOVE ) )
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
            HTUI_WindowAtMousePos():AddEvent( HTEventMouse():New( nKey ) )
        ELSE
            HTUI_WindowAtMousePos():AddEvent( HTEventKey():New( nKey ) )
        ENDIF
    ENDIF

RETURN

/*
    SetEventStack
*/
METHOD PROCEDURE SetEventStack( event ) CLASS HTApplication
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
