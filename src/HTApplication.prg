/** @class HTApplication
 * Singleton event loop controller. Manages the desktop, top-level windows,
 * event queue with priority levels, and the main Inkey-based event dispatch loop.
 * @extends HTObject
 */

#include "hbtui.ch"
#include "inkey.ch"

STATIC s_lDebug := .F.

SINGLETON CLASS HTApplication FROM HTObject

PROTECTED:

    DATA Fexecute INIT .F.
    DATA FeventStack        INIT { {}, {}, {} }
    DATA FeventStackLen     INIT { 0, 0, 0 }
    DATA Fdesktop           INIT NIL  /* explicit: avoids READONLY keyword clash in PROPERTY macro */

PUBLIC:

    CONSTRUCTOR new()

    METHOD activeWindow()
    METHOD addTopLevelWindow( windowId, widget )
    METHOD removeTopLevelWindow( windowId )
    METHOD exec()
    METHOD getEvent()
    METHOD getTopLevelWindowFromWindowId( windowId )
    METHOD queueEvent( event, priority )
    METHOD setDebug( lEnable )

    METHOD desktop()   INLINE ::Fdesktop  /* explicit INLINE: avoids BLOCK getter scope issue */
    PROPERTY topLevelWindows INIT { => }
    
ENDCLASS

/** Creates the application singleton and initializes the desktop. */
METHOD new() CLASS HTApplication

    LOCAL desktop

    IF ::Fdesktop = NIL
        desktop := HTDesktop():new()
        desktop:setAsDesktopWidget()
        ::Fdesktop := desktop
    ENDIF

RETURN self

/** Returns the currently active (focused) top-level window.
 * @return HTWidget or NIL
 */
METHOD FUNCTION activeWindow() CLASS HTApplication
RETURN ::getTopLevelWindowFromWindowId( wSelect() )

/** Registers a top-level window by its CT window handle.
 * @param windowId Numeric CT window handle
 * @param widget HTWidget instance
 */
METHOD PROCEDURE addTopLevelWindow( windowId, widget ) CLASS HTApplication

    IF hb_hHasKey( ::FtopLevelWindows, windowId )
        ::ERROR_DUPLICATE_TOP_LEVEL_WINDOW()
    ELSE
        ::FtopLevelWindows[ windowId ] := widget
    ENDIF

RETURN

/** Unregisters a top-level window by its CT window handle.
 * @param windowId Numeric CT window handle
 */
METHOD PROCEDURE removeTopLevelWindow( windowId ) CLASS HTApplication
    IF hb_hHasKey( ::FtopLevelWindows, windowId )
        hb_hDel( ::FtopLevelWindows, windowId )
    ENDIF
RETURN

/** Starts the main event loop. Paints the desktop, then continuously polls
 * for input events and dispatches queued events by priority (HIGH > NORMAL > LOW).
 * @return 0 on normal exit
 */
METHOD FUNCTION exec() CLASS HTApplication

    LOCAL result
    LOCAL event
    LOCAL widget
    LOCAL priority

    IF !::Fexecute

        //set( _SET_EVENTMASK, INKEY_ALL + HB_INKEY_RAW + HB_INKEY_EXT + HB_INKEY_GTEVENT )
        Set( _SET_EVENTMASK, INKEY_ALL )
        SetBlink( .F. )

        result := 0

        /* paint desktop synchronously BEFORE processing queued events,
         * so that ctWInit() and the desktop rendering happen first,
         * before any user windows are created */
        ::Fdesktop:paintEvent( HTPaintEvent():new() )

        ::Fexecute := .T.

        WHILE ::Fexecute

            ::getEvent()

            FOR priority := HT_EVENT_PRIORITY_HIGH TO HT_EVENT_PRIORITY_LOW
                WHILE ::FeventStackLen[ priority ] > 0

                    event := ::FeventStack[ priority, 1 ]
                    aDel( ::FeventStack[ priority ], 1 )
                    --::FeventStackLen[ priority ]

                    widget := IIF( event:widget = NIL, ::activeWindow(), event:widget )

                    IF widget != NIL
                        widget:event( event )
                    ENDIF

                ENDDO
            NEXT

        ENDDO

    ELSE

        ::ALREADY_RUNNING_EXEC()

    ENDIF

RETURN result

/** Polls for keyboard and mouse input via Inkey and routes events
 * to the appropriate top-level window (mouse to window under cursor,
 * keyboard to active window).
 */
METHOD PROCEDURE getEvent() CLASS HTApplication

    LOCAL nKey
    LOCAL mrow := mRow( .T. )
    LOCAL mcol := mCol( .T. )
    LOCAL window

    STATIC mCoords

    IF mCoords = NIL
        mCoords := { mrow, mcol }
    ENDIF

    IF mCoords[ 1 ] != mrow .OR. mCoords[ 2 ] != mcol
        ::queueEvent( HTMouseEvent():new( K_MOUSEMOVE ) )
        mCoords[ 1 ] := mrow
        mCoords[ 2 ] := mcol
        RETURN
    ENDIF

    nKey := Inkey( 1 )

    IF nKey != 0
        IF nKey >= K_MINMOUSE .AND. nKey <= K_MAXMOUSE
            /* mouse events go to the window under the mouse */
            window := ::getTopLevelWindowFromWindowId( ht_windowAtMousePos() )
            IF ! Empty( window )
                window:addEvent( HTMouseEvent():new( nKey ) )
            ENDIF
        ELSE
            /* keyboard events go to the active (focused) window */
            window := ::activeWindow()
            IF ! Empty( window )
                window:addEvent( HTKeyEvent():new( nKey ) )
            ENDIF
        ENDIF
    ENDIF

RETURN

/** Looks up a top-level widget by its CT window handle.
 * @param windowId Numeric CT window handle
 * @return HTWidget or NIL if not found
 */
METHOD FUNCTION getTopLevelWindowFromWindowId( windowId ) CLASS HTApplication

    LOCAL nPos

    nPos := hb_hPos( ::FtopLevelWindows, windowId )

    IF nPos > 0
        RETURN hb_hValueAt( ::FtopLevelWindows, nPos )
    ENDIF

RETURN NIL

/** Enqueues an event at the given priority level. Auto-assigns priority
 * based on widget visibility if not specified.
 * @param event HTEvent instance
 * @param priority Optional HT_EVENT_PRIORITY_HIGH/NORMAL/LOW
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
    ELSE
        ht_debugLog( "queueEvent: event stack overflow at priority " + hb_ntos( priority ) )
    ENDIF

RETURN

/** Enables or disables debug logging to stderr.
 * @param lEnable .T. to enable, .F. to disable
 */
METHOD PROCEDURE setDebug( lEnable ) CLASS HTApplication
    s_lDebug := lEnable
RETURN

/** Global debug log function. Writes to stderr when debug is enabled.
 * Enable with HTApplication():setDebug( .T. ), capture with: ./myapp 2>debug.log
 * @param cMessage Log message string
 * @return NIL
 */
FUNCTION ht_debugLog( cMessage )
    IF s_lDebug
        OutErr( "[HBTui " + Time() + "] " + cMessage + hb_eol() )
    ENDIF
RETURN NIL
