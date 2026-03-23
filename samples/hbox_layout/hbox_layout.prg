/** @file hbox_layout.prg
 * HTHBoxLayout Demo - Horizontal button bar with label
 *
 * Demonstrates:
 *   - HTVBoxLayout as the outer layout (label on top, buttons below)
 *   - Nested HTHBoxLayout for side-by-side buttons
 *   - addLayout() to nest horizontal layout inside vertical
 *   - spacing and margins on both layouts
 *   - StatusBar showing which button was clicked
 *
 * Keyboard:
 *   Tab/Shift+Tab  - cycle focus
 *   Enter/Space    - press buttons
 *   ESC            - quit
 */

#include "hbtui.ch"
#include "inkey.ch"

STATIC oStatusBar

PROCEDURE Main()

    LOCAL app, win
    LOCAL vbox, hbox
    LOCAL lbl, btn

    SetMode( 20, 60 )

    app := HTApplication():new()

    win := HTMainWindow():new()
    win:setWindowTitle( " HBox Layout Demo " )
    win:move( 1, 1 )
    win:resize( 56, 16 )

    /* --- Outer vertical layout --- */
    vbox := HTVBoxLayout():new( win )
    vbox:spacing := 1
    vbox:setContentsMargins( 1, 1, 1, 1 )

    /* --- Title label --- */
    lbl := HTLabel():new( "Horizontal button bar:", win )
    vbox:addWidget( lbl )

    /* --- Stretch pushes buttons toward the middle --- */
    vbox:addStretch()

    /* --- Horizontal layout for buttons --- */
    hbox := HTHBoxLayout():new()
    hbox:spacing := 2

    btn := HTPushButton():new( "Save", win )
    btn:onClicked := {|| UpdateStatus( "Save clicked" ) }
    hbox:addWidget( btn )

    btn := HTPushButton():new( "Reset", win )
    btn:onClicked := {|| UpdateStatus( "Reset clicked" ) }
    hbox:addWidget( btn )

    btn := HTPushButton():new( "Cancel", win )
    btn:onClicked := {|| HTApplication():quit() }
    hbox:addWidget( btn )

    vbox:addLayout( hbox )

    /* --- Stretch below buttons --- */
    vbox:addStretch()

    /* --- Status Bar --- */
    oStatusBar := HTStatusBar():new( win )
    oStatusBar:addSection( "Space/Enter to press buttons" )
    oStatusBar:addSection( "ESC to quit" )
    vbox:addWidget( oStatusBar )

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
