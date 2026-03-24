/** @class HTApplication
 * Singleton event loop controller. Manages the desktop, top-level windows,
 * event queue with priority levels, and the main Inkey-based event dispatch loop.
 * @extends HTObject
 */

#include "hbtui.ch"
#include "inkey.ch"

STATIC s_lDebug := .F.
STATIC s_aFormatStack := {}

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
    METHOD getTopLevelWindowFromWindowId( windowId )
    METHOD queueEvent( event, priority )
    METHOD quit() INLINE ::Fexecute := .F.
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

    ::FtopLevelWindows[ windowId ] := widget

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
    LOCAL window
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

            /* poll for input via the unified event loop */
            event := HTEventLoop():poll( 0.1 )

            IF event != NIL
                IF event:className() == "HTMOUSEEVENT"
                    IF event:nKey != K_MOUSEMOVE
                        /* mouse click: route to window under cursor;
                           fall back to active window if clicked window is
                           unregistered (e.g., menu dropdown CT window) */
                        window := ::getTopLevelWindowFromWindowId( ht_windowAtMousePos() )
                        IF Empty( window )
                            window := ::activeWindow()
                        ENDIF
                    ELSE
                        /* mouse move: route to active window */
                        window := ::activeWindow()
                    ENDIF
                    IF ! Empty( window )
                        /* recapture coords relative to the target window using
                           screen-absolute positions (immune to wFormat margin state) */
                        wSelect( window:windowId, .F. )
                        event:mouseRow := event:mouseAbsRow - wRow()
                        event:mouseCol := event:mouseAbsCol - wCol()
                        window:addEvent( event )
                    ENDIF
                ELSE
                    /* keyboard events go to active window */
                    ::queueEvent( event )
                ENDIF
            ENDIF

            /* process queued events by priority
             * NOTE: aDel() + shift is O(n) per dequeue, but acceptable here —
             * HBTUI_UI_STACK_EVENT_SIZE is 128, and TUI event rates are low. */
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

        ht_debugLog( "HTApplication:exec() called while already running — ignored" )

    ENDIF

RETURN result

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

/*
 * wFormat viewport stack — push/pop pattern for nested viewports.
 *
 * CT's wFormat() is additive but wFormat() no-args resets ALL margins to (0,0,0,0),
 * destroying any parent viewport. These functions provide proper push/pop semantics:
 *   ht_wFormatPush(t,l,b,r) — adds margins and saves them on a stack
 *   ht_wFormatPop()         — undoes the last push, restoring parent margins
 *
 * Used by paintChild() for nested widget viewports.
 */

/** Pushes viewport margins onto the stack and applies them (additive).
 * @param nTop Top margin to add
 * @param nLeft Left margin to add
 * @param nBottom Bottom margin to add
 * @param nRight Right margin to add
 */
FUNCTION ht_wFormatPush( nTop, nLeft, nBottom, nRight )
    AAdd( s_aFormatStack, { nTop, nLeft, nBottom, nRight } )
    wFormat( nTop, nLeft, nBottom, nRight )
RETURN NIL

/** Pops the last pushed margins, restoring the parent viewport.
 * Logs a warning on stack underflow (mismatched push/pop).
 */
FUNCTION ht_wFormatPop()

    LOCAL aMargins

    IF Len( s_aFormatStack ) > 0
        aMargins := ATail( s_aFormatStack )
        ASize( s_aFormatStack, Len( s_aFormatStack ) - 1 )
        wFormat( -aMargins[ 1 ], -aMargins[ 2 ], -aMargins[ 3 ], -aMargins[ 4 ] )
    ELSE
        ht_debugLog( "ht_wFormatPop() underflow — mismatched push/pop" )
    ENDIF

RETURN NIL
