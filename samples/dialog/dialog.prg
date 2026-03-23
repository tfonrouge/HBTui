/** @file dialog.prg
 * Dialog Demo - Modal dialogs and message boxes
 *
 * Demonstrates:
 *   - HTMessageBox information dialog (click OK or press Enter)
 *   - HTMessageBox question dialog with result handling
 *   - Custom HTDialog with OK/Cancel buttons
 *   - HTToast feedback showing dialog results
 *
 * Keyboard:
 *   Tab/Shift+Tab - cycle buttons
 *   Enter/Space   - activate button
 *   ESC           - quit
 */

#include "hbtui.ch"
#include "inkey.ch"

#define HT_DIALOG_ACCEPTED  1

PROCEDURE Main()

    LOCAL app, win, btn

    SetMode( 20, 55 )

    app := HTApplication():new()

    win := HTMainWindow():new()
    win:setWindowTitle( " Dialog Demo " )
    win:move( 1, 1 )
    win:resize( 50, 16 )

    HTLabel():new( "Click a button to open a dialog:", win ):move( 2, 2 )

    /* --- Information button --- */
    btn := HTPushButton():new( "Information", win )
    btn:move( 2, 4 )
    btn:onClicked := {|| ;
        HTMessageBox():information( "Info", "This is an info message" ), ;
        HTToast():show( "Info dialog closed", 2000, HT_CLR_TOAST_INFO ) ;
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

    HTLabel():new( "Results shown as toast notifications", win ):move( 2, 9 )

    win:show()
    app:exec()

RETURN

STATIC PROCEDURE ShowQuestion()

    LOCAL nResult

    nResult := HTMessageBox():question( "Confirm", "Do you want to proceed?" )

    IF nResult == HT_DIALOG_ACCEPTED
        HTToast():show( "User answered YES", 3000, HT_CLR_TOAST_SUCCESS )
    ELSE
        HTToast():show( "User answered NO", 3000, HT_CLR_TOAST_WARNING )
    ENDIF

RETURN

STATIC PROCEDURE ShowCustomDialog()

    LOCAL dlg, oLbl, nResult

    dlg := HTDialog():new()
    dlg:setWindowTitle( " Custom Dialog " )
    dlg:move( 10, 4 )
    dlg:resize( 30, 8 )

    oLbl := HTLabel():new( "Choose an action:", dlg )
    oLbl:setGeometry( 2, 2, 20, 1 )
    dlg:addButtonBar( "OK", "Cancel" )

    nResult := dlg:exec()

    IF nResult == HT_DIALOG_ACCEPTED
        HTToast():show( "Custom dialog: OK", 3000, HT_CLR_TOAST_SUCCESS )
    ELSE
        HTToast():show( "Custom dialog: Cancelled", 3000, HT_CLR_TOAST_WARNING )
    ENDIF

RETURN
