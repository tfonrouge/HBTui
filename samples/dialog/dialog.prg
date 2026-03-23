/** @file dialog.prg
 * Dialog Demo - Modal dialogs and message boxes
 *
 * Demonstrates:
 *   - HTMessageBox information dialog
 *   - HTMessageBox question dialog with result handling
 *   - Custom HTDialog with buttons and result
 *   - HTStatusBar showing dialog results
 *
 * Keyboard:
 *   Tab/Shift+Tab - cycle buttons
 *   Enter         - activate button
 *   ESC           - quit
 */

#include "hbtui.ch"
#include "inkey.ch"

#define HT_DIALOG_ACCEPTED  1
#define HT_DIALOG_REJECTED  0

STATIC oStatusBar
STATIC oWindow

PROCEDURE Main()

    LOCAL app, win, btn, oSB

    SetMode( 25, 60 )

    app := HTApplication():new()

    win := HTMainWindow():new()
    win:setWindowTitle( " Dialog Demo " )
    win:move( 1, 1 )
    win:resize( 55, 20 )
    oWindow := win

    HTLabel():new( "Click a button to open a dialog:", win ):move( 2, 2 )

    /* --- Information button --- */
    btn := HTPushButton():new( "Information", win )
    btn:move( 2, 4 )
    btn:onClicked := {|| ;
        HTMessageBox():information( "Info", "This is an info message" ), ;
        UpdateStatus( "Information dialog closed" ) ;
    }

    /* --- Question button --- */
    btn := HTPushButton():new( "Question", win )
    btn:move( 18, 4 )
    btn:onClicked := {|| ShowQuestion() }

    /* --- Custom dialog button --- */
    btn := HTPushButton():new( "Custom Dialog", win )
    btn:move( 32, 4 )
    btn:onClicked := {|| ShowCustomDialog() }

    /* --- Separator --- */
    HTSeparator():new( win ):move( 1, 7 )

    /* --- Status Bar --- */
    oSB := HTStatusBar():new( win )
    oSB:move( 1, 16 )
    oSB:addSection( "Click a button to open a dialog" )
    oStatusBar := oSB

    win:show()
    app:exec()

RETURN

STATIC PROCEDURE ShowQuestion()

    LOCAL nResult

    nResult := HTMessageBox():question( "Confirm", "Do you want to proceed?" )

    IF nResult == HT_DIALOG_ACCEPTED
        UpdateStatus( "Question: user answered YES" )
    ELSE
        UpdateStatus( "Question: user answered NO" )
    ENDIF

RETURN

STATIC PROCEDURE ShowCustomDialog()

    LOCAL dlg, btn, nResult

    dlg := HTDialog():new( oWindow )
    dlg:setWindowTitle( " Custom Dialog " )
    dlg:move( 15, 5 )
    dlg:resize( 30, 8 )

    HTLabel():new( "Choose an action:", dlg ):move( 2, 2 )

    btn := HTPushButton():new( "OK", dlg )
    btn:move( 5, 4 )
    btn:onClicked := {|| dlg:accept() }

    btn := HTPushButton():new( "Cancel", dlg )
    btn:move( 15, 4 )
    btn:onClicked := {|| dlg:reject() }

    nResult := dlg:exec()

    IF nResult == HT_DIALOG_ACCEPTED
        UpdateStatus( "Custom dialog: OK pressed" )
    ELSE
        UpdateStatus( "Custom dialog: Cancelled" )
    ENDIF

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
