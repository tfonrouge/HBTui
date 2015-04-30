/*
 *
 */

#include "hbtui.ch"
#include "inkey.ch"

SINGLETON CLASS HTApplication FROM HTObject
PROTECTED:

    DATA Fexecute INIT .F.
    DATA FeventStack        INIT { {}, {}, {} }
    DATA FeventStackLen     INIT { 0, 0, 0 }

    PROPERTY StateOnMove INIT .F.

PUBLIC:

    CONSTRUCTOR New()

    METHOD activeWindow()
    METHOD addTopLevelWindow( windowId, widget )
    METHOD exec()
    METHOD GetEvent()
    METHOD getTopLevelWindowFromWindowId( windowId )
    METHOD queueEvent( event, priority )

    PROPERTY allWidgets
    PROPERTY desktop
    PROPERTY topLevelWindows INIT { => }

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
    activeWindow
*/
METHOD FUNCTION activeWindow() CLASS HTApplication
RETURN ::getTopLevelWindowFromWindowId( WSelect() )

/*
    addTopLevelWindow
*/
METHOD PROCEDURE addTopLevelWindow( windowId, widget ) CLASS HTApplication
    LOCAL arrayId

    IF hb_hHasKey( ::FtopLevelWindows, windowId )
        ::ERROR_DUPLICATE_TOP_LEVEL_WINDOW()
    ELSE
        arrayId := __vmItemId( widget )
        ::FtopLevelWindows[ windowId ] := arrayId
    ENDIF
RETURN

/*
  exec
*/
METHOD FUNCTION exec() CLASS HTApplication
    LOCAL result
    LOCAL event
    LOCAL widget
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

            FOR priority := HT_EVENT_PRIORITY_HIGH TO HT_EVENT_PRIORITY_LOW
                WHILE ::FeventStackLen[ priority ] > 0

                    event := ::FeventStack[ priority, 1 ]
                    ADel( ::FeventStack[ priority ], 1 )
                    --::FeventStackLen[ priority ]

                    widget := iif( event:widget = NIL, ::activeWindow(), event:widget )

                    widget:event( event )

                ENDDO
            NEXT

        ENDDO

    ELSE

        ::ALREADY_RUNNING_EXEC()

    ENDIF

RETURN result

/*
  GetEvent
*/
METHOD PROCEDURE GetEvent() CLASS HTApplication
    LOCAL nKey
    LOCAL mrow := mRow( .T. )
    LOCAL mcol := mCol( .T. )
    LOCAL window

    STATIC mCoords

    IF mCoords = NIL
        mCoords := { mrow, mcol }
    ENDIF

    IF mCoords[ 1 ] != mrow .OR. mCoords[ 2 ] != mcol
        HTApplication():activeWindow():addEvent( HTMouseEvent():New( K_MOUSEMOVE ) )
        mCoords[ 1 ] := mrow
        mCoords[ 2 ] := mcol
        RETURN
    ENDIF

    nKey := Inkey(  )

    IF nKey != 0
        window := ::getTopLevelWindowFromWindowId( hb_windowAtMousePos() )
        IF nKey >= K_MINMOUSE .AND. nKey <= K_MAXMOUSE
            window:addEvent( HTMouseEvent():New( nKey ) )
        ELSE
            window:addEvent( HTKeyEvent():New( nKey ) )
        ENDIF
    ENDIF

RETURN

/*
    getTopLevelWindowFromWindowId
*/
METHOD FUNCTION getTopLevelWindowFromWindowId( windowId ) CLASS HTApplication
    LOCAL window
    LOCAL arrayId

    IF hb_hHasKey( ::FtopLevelWindows, windowId )
        arrayId := ::FtopLevelWindows[ windowId ]
        window := hb_arrayFromId( arrayId )
    ENDIF

RETURN window

/*
    queueEvent
*/
METHOD PROCEDURE queueEvent( event, priority ) CLASS HTApplication

    IF priority = NIL
        IF event:widget != NIL .AND. event:widget:isVisible
            priority := HT_EVENT_PRIORITY_NORMAL    /* default priority if not given */
        ELSE
            priority := HT_EVENT_PRIORITY_LOW    /* LOW priority if widget not visible yet */
        ENDIF
    ENDIF

    IF ::FeventStackLen[ priority ] < HBTUI_UI_STACK_EVENT_SIZE
        ++::FeventStackLen[ priority ]
        IF Len( ::FeventStack[ priority ] ) < ::FeventStackLen[ priority ]
            ASize( ::FeventStack[ priority ], ::FeventStackLen[ priority ] )
        ENDIF
        ::FeventStack[ priority, ::FeventStackLen[ priority ] ] := event
    ENDIF

RETURN
