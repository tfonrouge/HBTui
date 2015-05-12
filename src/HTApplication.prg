/*
 *
 */

#include "hbtui.ch"
#include "inkey.ch"

SINGLETON CLASS HTApplication FROM HTObject
PROTECTED:

    DATA Fexecute INIT .f.
    DATA FeventStack        INIT { {}, {}, {} }
    DATA FeventStackLen     INIT { 0, 0, 0 }

PUBLIC:

    CONSTRUCTOR new()

    METHOD activeWindow()
    METHOD addTopLevelWindow( windowId, widget )
    METHOD exec()
    METHOD getEvent()
    METHOD getTopLevelWindowFromWindowId( windowId )
    METHOD queueEvent( event, priority )

    PROPERTY allWidgets
    PROPERTY desktop
    PROPERTY topLevelWindows INIT { => }

ENDCLASS

/*
    new
*/
METHOD new() CLASS HTApplication
    LOCAL desktop

    IF ::Fdesktop = NIL
        desktop := HTDesktop():new()
        desktop:setAsDesktopWidget()
        ::Fdesktop := desktop
    ENDIF

RETURN Self

/*
    activeWindow
*/
METHOD FUNCTION activeWindow() CLASS HTApplication
RETURN ::getTopLevelWindowFromWindowId( wSelect() )

/*
    addTopLevelWindow
*/
METHOD PROCEDURE addTopLevelWindow( windowId, widget ) CLASS HTApplication
    LOCAL objectId

    IF hb_hHasKey( ::FtopLevelWindows, windowId )
        ::ERROR_DUPLICATE_TOP_LEVEL_WINDOW()
    ELSE
        objectId := ht_objectId( widget )
        ::FtopLevelWindows[ windowId ] := objectId
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

        //set( _SET_EVENTMASK, INKEY_ALL + HB_INKEY_RAW + HB_INKEY_EXT + HB_INKEY_GTEVENT )
        set( _SET_EVENTMASK, INKEY_ALL )
        setBlink( .f. )

        result := 0

        /* paint desktop */
        ::Fdesktop:show()

        ::Fexecute := .t.

        WHILE ::Fexecute

            ::getEvent()

            FOR priority := HT_EVENT_PRIORITY_HIGH TO HT_EVENT_PRIORITY_LOW
                WHILE ::FeventStackLen[ priority ] > 0

                    event := ::FeventStack[ priority, 1 ]
                    aDel( ::FeventStack[ priority ], 1 )
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
  getEvent
*/
METHOD PROCEDURE getEvent() CLASS HTApplication
    LOCAL nKey
    LOCAL mrow := mRow( .t. )
    LOCAL mcol := mCol( .t. )
    LOCAL window

    STATIC mCoords

    IF mCoords = NIL
        mCoords := { mrow, mcol }
    ENDIF

    IF mCoords[ 1 ] != mrow .OR. mCoords[ 2 ] != mcol
        HTApplication():activeWindow():addEvent( HTMouseEvent():new( K_MOUSEMOVE ) )
        mCoords[ 1 ] := mrow
        mCoords[ 2 ] := mcol
        RETURN
    ENDIF

    nKey := Inkey(  )

    IF nKey != 0
        IF !Empty( window := ::getTopLevelWindowFromWindowId( hb_windowAtMousePos() ) )
            IF nKey >= K_MINMOUSE .AND. nKey <= K_MAXMOUSE
                window:addEvent( HTMouseEvent():new( nKey ) )
            ELSE
                window:addEvent( HTKeyEvent():new( nKey ) )
            ENDIF
        ENDIF
    ENDIF

RETURN

/*
    getTopLevelWindowFromWindowId
*/
METHOD FUNCTION getTopLevelWindowFromWindowId( windowId ) CLASS HTApplication
    LOCAL nPos

    nPos := hb_hPos( ::FtopLevelWindows, windowId )

    IF nPos > 0
        RETURN ht_objectFromId( hb_hValueAt( ::FtopLevelWindows, nPos ) )
    ENDIF

RETURN NIL

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
        IF len( ::FeventStack[ priority ] ) < ::FeventStackLen[ priority ]
            ASize( ::FeventStack[ priority ], ::FeventStackLen[ priority ] )
        ENDIF
        ::FeventStack[ priority, ::FeventStackLen[ priority ] ] := event
    ENDIF

RETURN
