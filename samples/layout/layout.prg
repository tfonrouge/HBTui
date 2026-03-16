/*
 * HTVBoxLayout Demo - Vertical layout with spacing, margins, and stretch
 *
 * Demonstrates:
 *   - VBoxLayout with spacing between items
 *   - setContentsMargins() for padding inside the window
 *   - addStretch() to push buttons to the bottom
 *   - Multiple labels and input fields stacked vertically
 *
 * Keyboard:
 *   Tab/Shift+Tab  - cycle focus
 *   Space          - press buttons / toggle checkbox
 *   ESC            - quit
 */

#include "hbtui.ch"
#include "inkey.ch"

STATIC oStatusBar
STATIC cFirstName  := "                              "
STATIC cLastName   := "                              "
STATIC cCity       := "                              "

PROCEDURE Main()

    LOCAL app, win
    LOCAL layout
    LOCAL oGet, lbl, chk, btn, sep

    SetMode( 28, 55 )

    app := HTApplication():new()

    win := HTMainWindow():new()
    win:setWindowTitle( " VBoxLayout Demo " )
    win:move( 1, 1 )
    win:resize( 50, 24 )

    /* --- Create vertical layout --- */
    layout := HTVBoxLayout():new( win )
    layout:spacing := 1
    layout:setContentsMargins( 1, 1, 1, 1 )

    /* --- Title label --- */
    lbl := HTLabel():new( "Registration Form", win )
    layout:addWidget( lbl )

    /* --- Separator --- */
    sep := HTSeparator():new( win )
    layout:addWidget( sep )

    /* --- First Name GET --- */
    oGet := HTGet():new( win )
    oGet:setup( {|x| IIF( x == NIL, cFirstName, cFirstName := x ) }, ;
                "First:", "@!", NIL, NIL, "First name", NIL, .F., .F., 45 )
    layout:addWidget( oGet )

    /* --- Last Name GET --- */
    oGet := HTGet():new( win )
    oGet:setup( {|x| IIF( x == NIL, cLastName, cLastName := x ) }, ;
                "Last:", "@!", NIL, NIL, "Last name", NIL, .F., .F., 45 )
    layout:addWidget( oGet )

    /* --- City GET --- */
    oGet := HTGet():new( win )
    oGet:setup( {|x| IIF( x == NIL, cCity, cCity := x ) }, ;
                "City:", "", NIL, NIL, "City", NIL, .F., .F., 45 )
    layout:addWidget( oGet )

    /* --- Checkbox --- */
    chk := HTCheckBox():new( "Subscribe to newsletter", win )
    layout:addWidget( chk )

    /* --- Stretch pushes buttons to the bottom --- */
    layout:addStretch()

    /* --- Separator before buttons --- */
    sep := HTSeparator():new( win )
    layout:addWidget( sep )

    /* --- Buttons row (manually positioned within layout row) --- */
    btn := HTPushButton():new( "Submit", win )
    btn:onClicked := {|| HTMessageBox():information( "OK", ;
        "Submitted: " + AllTrim( cFirstName ) + " " + AllTrim( cLastName ) ) }
    layout:addWidget( btn )

    /* --- Status Bar --- */
    oStatusBar := HTStatusBar():new( win )
    oStatusBar:addSection( "Tab to navigate, Space to toggle" )
    oStatusBar:addSection( "Layout Demo" )
    layout:addWidget( oStatusBar )

    win:show()
    app:exec()

RETURN
