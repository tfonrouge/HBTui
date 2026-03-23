/*
 * HTGet Demo - TGet-backed editing with PICTURE formatting and validation
 *
 * Demonstrates:
 *   - String GET with @! (auto-uppercase)
 *   - Numeric GET with 999,999.99 (decimal alignment)
 *   - Date GET with @D
 *   - VALID block returning .F. keeps focus on the field
 *   - StatusBar showing help text per field
 *
 * Keyboard:
 *   Tab/Shift+Tab  - cycle between fields
 *   Ins            - toggle insert/overwrite mode
 *   Ctrl+U         - undo to original value
 *   ESC            - quit
 */

#include "hbtui.ch"
#include "inkey.ch"

STATIC oStatusBar
STATIC oWindow

/* GET field variables */
STATIC cName   := "                              "
STATIC nAmount := 0.00
STATIC dStart  := 0d20250101

PROCEDURE Main()

    LOCAL app, win
    LOCAL oGet, btn, frm

    SetMode( 20, 60 )

    app := HTApplication():new()

    win := HTMainWindow():new()
    win:setWindowTitle( " HTGet Demo " )
    win:move( 1, 1 )
    win:resize( 55, 16 )
    oWindow := win

    /* --- Frame --- */
    frm := HTFrame():new( "Data Entry", win )
    frm:move( 1, 1 )

    /* --- String GET with @! (uppercase) --- */
    oGet := HTGet():new( win )
    oGet:setup( {|x| IIF( x == NIL, cName, cName := x ) }, ;
                "Name:", "@!", ;
                {|v| IIF( ! Empty( v ), .T., ( UpdateStatus( "Name cannot be empty!" ), .F. ) ) }, ;
                NIL, "Enter full name (auto uppercase)", ;
                {|v| UpdateStatus( "Name: " + AllTrim( v ) ) }, .F., .F., 45 )
    oGet:move( 2, 2 )

    /* --- Numeric GET with decimal alignment --- */
    oGet := HTGet():new( win )
    oGet:setup( {|x| IIF( x == NIL, nAmount, nAmount := x ) }, ;
                "Amount:", "999,999.99", ;
                {|v| IIF( v > 0, .T., ( UpdateStatus( "Amount must be > 0" ), .F. ) ) }, ;
                NIL, "Enter amount (VALID > 0)", ;
                {|v| UpdateStatus( "Amount: " + LTrim( Str( v, 12, 2 ) ) ) }, .F., .F., 45 )
    oGet:move( 2, 4 )

    /* --- Date GET with @D --- */
    oGet := HTGet():new( win )
    oGet:setup( {|x| IIF( x == NIL, dStart, dStart := x ) }, ;
                "Date:", "@D", ;
                NIL, NIL, "Enter start date", ;
                {|v| UpdateStatus( "Date: " + DToC( v ) ) }, .F., .F., 45 )
    oGet:move( 2, 6 )

    /* --- Separator --- */
    HTSeparator():new( win ):move( 1, 8 )

    /* --- Buttons --- */
    btn := HTPushButton():new( "Save", win )
    btn:move( 2, 10 )
    btn:onClicked := {|| ;
        UpdateStatus( "Saved: " + AllTrim( cName ) + ;
                      " / " + LTrim( Str( nAmount, 12, 2 ) ) + ;
                      " / " + DToC( dStart ) ) ;
    }

    btn := HTPushButton():new( "Quit", win )
    btn:move( 12, 10 )
    btn:onClicked := {|| HTApplication():quit() }

    /* --- Status Bar --- */
    oStatusBar := HTStatusBar():new( win )
    oStatusBar:move( 1, 12 )
    oStatusBar:addSection( "Tab to navigate, Enter/Tab to confirm" )
    oStatusBar:addSection( "HBTui" )

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
