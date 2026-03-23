/** @file grid_layout.prg
 * HTGridLayout Demo - Form layout using a 2D grid
 *
 * Demonstrates:
 *   - HTGridLayout with row/column placement
 *   - Labels and input fields in a form arrangement
 *   - Buttons aligned in the grid
 *   - Spacing between grid cells
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
    LOCAL grid
    LOCAL lbl, edt, btn

    SetMode( 25, 60 )

    app := HTApplication():new()

    win := HTMainWindow():new()
    win:setWindowTitle( " Grid Layout Demo " )
    win:move( 1, 1 )
    win:resize( 58, 23 )

    /* --- Create grid layout --- */
    grid := HTGridLayout():new( win )
    grid:spacing := 1
    grid:setContentsMargins( 2, 2, 2, 2 )

    /* Row 0: Name */
    lbl := HTLabel():new( "Name:", win )
    grid:addWidget( lbl, 0, 0 )

    edt := HTLineEdit():new( win )
    edt:text := "John Doe"
    grid:addWidget( edt, 0, 1 )

    /* Row 1: Email */
    lbl := HTLabel():new( "Email:", win )
    grid:addWidget( lbl, 1, 0 )

    edt := HTLineEdit():new( win )
    edt:text := "john@example.com"
    grid:addWidget( edt, 1, 1 )

    /* Row 2: Notes label */
    lbl := HTLabel():new( "Notes:", win )
    grid:addWidget( lbl, 2, 0 )

    lbl := HTLabel():new( "(see editor sample)", win )
    grid:addWidget( lbl, 2, 1 )

    /* Row 3: Buttons */
    btn := HTPushButton():new( "Save", win )
    btn:onClicked := {|| UpdateStatus( "Saved!" ) }
    grid:addWidget( btn, 3, 0 )

    btn := HTPushButton():new( "Cancel", win )
    btn:onClicked := {|| HTApplication():quit() }
    grid:addWidget( btn, 3, 1 )

    /* --- Status Bar --- */
    oStatusBar := HTStatusBar():new( win )
    oStatusBar:addSection( "Tab to navigate" )
    oStatusBar:addSection( "Grid Layout" )

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
