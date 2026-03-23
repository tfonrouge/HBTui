/** @file menu.prg
 * Menu System Demo - MenuBar with menus, actions, and keyboard shortcuts
 *
 * Demonstrates:
 *   - HTMenuBar with multiple menus
 *   - HTAction items with onTriggered callbacks
 *   - Menu separators
 *   - HTMessageBox for About dialog
 *   - StatusBar updated on menu actions
 *
 * Keyboard:
 *   F10            - activate menu bar
 *   Arrow keys     - navigate menus
 *   Enter          - select menu item
 *   ESC            - close menu / quit
 *   Tab/Shift+Tab  - cycle focus
 */

#include "hbtui.ch"
#include "inkey.ch"

STATIC oStatusBar
STATIC oWindow

PROCEDURE Main()

    LOCAL app, win
    LOCAL menuBar, menu, act
    LOCAL lbl

    SetMode( 25, 60 )

    app := HTApplication():new()

    win := HTMainWindow():new()
    win:setWindowTitle( " Menu Demo " )
    win:move( 1, 1 )
    win:resize( 58, 23 )
    oWindow := win

    /* --- Menu Bar --- */
    menuBar := win:menuBar

    /* File menu */
    menu := menuBar:addMenu( "File" )
    act := menu:addAction( "New" )
    act:onTriggered := {|| UpdateStatus( "File > New" ) }
    act := menu:addAction( "Open" )
    act:onTriggered := {|| UpdateStatus( "File > Open" ) }
    act := menu:addAction( "Save" )
    act:onTriggered := {|| UpdateStatus( "File > Save" ) }
    menu:addSeparator()
    act := menu:addAction( "Exit" )
    act:onTriggered := {|| HTApplication():quit() }

    /* Edit menu */
    menu := menuBar:addMenu( "Edit" )
    act := menu:addAction( "Cut   Ctrl+X" )
    act:onTriggered := {|| UpdateStatus( "Edit > Cut" ) }
    act := menu:addAction( "Copy  Ctrl+C" )
    act:onTriggered := {|| UpdateStatus( "Edit > Copy" ) }
    act := menu:addAction( "Paste Ctrl+V" )
    act:onTriggered := {|| UpdateStatus( "Edit > Paste" ) }

    /* Help menu */
    menu := menuBar:addMenu( "Help" )
    act := menu:addAction( "About" )
    act:onTriggered := {|| HTMessageBox():information( "About", ;
        "Menu Demo - HBTui Framework" ) }

    /* --- Center labels --- */
    lbl := HTLabel():new( "Use F10 to activate menu bar", win )
    lbl:move( 14, 10 )

    lbl := HTLabel():new( "Navigate with arrow keys, Enter to select", win )
    lbl:move( 8, 12 )

    /* --- Status Bar --- */
    oStatusBar := HTStatusBar():new( win )
    oStatusBar:addSection( "Ready" )
    oStatusBar:addSection( "F10: menu" )

    win:show()
    app:exec()

RETURN

STATIC PROCEDURE UpdateStatus( cText )

    LOCAL parent

    IF oStatusBar != NIL
        oStatusBar:setSection( 1, cText )
        parent := oStatusBar:parent()
        IF parent != NIL
            parent:repaintChild( oStatusBar )
        ENDIF
    ENDIF

RETURN
