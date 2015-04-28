/*
 *
 */

#include "hbtui.ch"
#include "inkey.ch"

SINGLETON CLASS HTApplication FROM HTObject
PROTECTED:

    DATA Fexecute INIT .F.
    DATA FeventStack        INIT { 0 => {}, 1 => {}, 2 => {} }
    DATA FeventStackLen     INIT { 0 => 0, 1 => 0, 2 => 0 }
    
    METHOD FocusEvent( event )

    PROPERTY StateOnMove INIT .F.

PUBLIC:

    CONSTRUCTOR New()

    METHOD Exec()
    METHOD FocusWindow INLINE HTUI_GetFocusedWindow()
    METHOD GetEvent()
    METHOD queueEvent( event, priority )

    PROPERTY allWidgets
    PROPERTY desktop

ENDCLASS

/*
    New
*/
METHOD New() CLASS HTApplication
    LOCAL desktop

    IF ::Fdesktop = NIL
        desktop := HTDesktop():New()
        desktop:setAsDesktopWidget()
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
    LOCAL priority

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

            FOR priority := 0 TO 2
                IF ::FeventStackLen[ priority ] > 0
            
                    OutStd( "priority", priority, e"\n" )

                    event := ::FeventStack[ priority, 1 ]
                    ADel( ::FeventStack[ priority ], 1 )
                    --::FeventStackLen[ priority ]

                    hbtobject := iif( event:hbtobject = NIL, ::FocusWindow, event:hbtobject )

                    hbtobject:event( event )

                ENDIF
            NEXT

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
        ::FocusWindow:focusOutEvent( event )
        event:hbtobject:focusInEvent( event )
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
        HTApplication():FocusWindow():AddEvent( HTMouseEvent():New( K_MOUSEMOVE ) )
        mCoords[ 1 ] := mrow
        mCoords[ 2 ] := mcol
        RETURN
    ENDIF

    nKey := Inkey( 0.2 )

    IF nKey != 0
        IF nKey >= K_MINMOUSE .AND. nKey <= K_MAXMOUSE
            HTUI_WindowAtMousePos():AddEvent( HTMouseEvent():New( nKey ) )
        ELSE
            HTUI_WindowAtMousePos():AddEvent( HTKeyEvent():New( nKey ) )
        ENDIF
    ENDIF

RETURN

/*
    queueEvent
*/
METHOD PROCEDURE queueEvent( event, priority ) CLASS HTApplication

    IF priority = NIL
        priority := 1
    ENDIF

    IF ::FeventStackLen[ priority ] < HBTUI_UI_STACK_EVENT_SIZE
        ++::FeventStackLen[ priority ]
        IF Len( ::FeventStack[ priority ] ) < ::FeventStackLen[ priority ]
            ASize( ::FeventStack[ priority ], ::FeventStackLen[ priority ] )
        ENDIF
        ::FeventStack[ priority, ::FeventStackLen[ priority ] ] := event
    ENDIF

RETURN
