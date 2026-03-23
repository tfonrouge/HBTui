/*
 * HTToast Demo - Non-blocking toast notifications
 *
 * Demonstrates:
 *   - Toast messages that auto-dismiss after a timeout
 *   - Four toast styles: Info, Success, Warning, Error
 *   - Multiple toasts stacking vertically
 *   - Theme switching preserves toast colors
 *
 * Keyboard:
 *   F1  - Info toast
 *   F2  - Success toast
 *   F3  - Warning toast
 *   F4  - Error toast
 *   F5  - Fire 3 toasts rapidly (test stacking)
 *   ESC - quit
 */

#include "hbtui.ch"
#include "inkey.ch"

PROCEDURE Main()

    LOCAL app, win
    LOCAL btn, oSB

    SetMode( 25, 70 )

    app := HTApplication():new()

    win := HTMainWindow():new()
    win:setWindowTitle( " Toast Demo " )
    win:move( 1, 1 )
    win:resize( 65, 20 )

    HTLabel():new( "Click a button or press F1-F5:", win ):move( 2, 2 )

    /* --- Toast buttons --- */
    btn := HTPushButton():new( "Info", win )
    btn:move( 2, 4 )
    btn:onClicked := {|| HTToast():show( "This is an info message", 3000, HT_CLR_TOAST_INFO ) }

    btn := HTPushButton():new( "Success", win )
    btn:move( 12, 4 )
    btn:onClicked := {|| HTToast():show( "Operation completed!", 3000, HT_CLR_TOAST_SUCCESS ) }

    btn := HTPushButton():new( "Warning", win )
    btn:move( 24, 4 )
    btn:onClicked := {|| HTToast():show( "Disk space running low", 4000, HT_CLR_TOAST_WARNING ) }

    btn := HTPushButton():new( "Error", win )
    btn:move( 36, 4 )
    btn:onClicked := {|| HTToast():show( "Connection failed!", 5000, HT_CLR_TOAST_ERROR ) }

    btn := HTPushButton():new( "Spam 3", win )
    btn:move( 2, 6 )
    btn:onClicked := {|| ;
        HTToast():show( "First toast",  3000, HT_CLR_TOAST_INFO ), ;
        HTToast():show( "Second toast", 4000, HT_CLR_TOAST_SUCCESS ), ;
        HTToast():show( "Third toast",  5000, HT_CLR_TOAST_WARNING ) ;
    }

    btn := HTPushButton():new( "Dismiss All", win )
    btn:move( 14, 6 )
    btn:onClicked := {|| HTToast():dismissAll() }

    /* --- Separator --- */
    HTSeparator():new( win ):move( 1, 8 )

    /* --- Status Bar --- */
    oSB := HTStatusBar():new( win )
    oSB:move( 1, 16 )
    oSB:addSection( "F1-F5: toasts | ESC: quit" )

    /* --- F-key bindings --- */
    win:onKey( K_F1, {|| HTToast():show( "Info: F1 pressed",    3000, HT_CLR_TOAST_INFO ) } )
    win:onKey( K_F2, {|| HTToast():show( "Success: saved!",     3000, HT_CLR_TOAST_SUCCESS ) } )
    win:onKey( K_F3, {|| HTToast():show( "Warning: check input", 4000, HT_CLR_TOAST_WARNING ) } )
    win:onKey( K_F4, {|| HTToast():show( "Error: failed!",      5000, HT_CLR_TOAST_ERROR ) } )
    win:onKey( K_F5, {|| ;
        HTToast():show( "Stack 1", 3000, HT_CLR_TOAST_INFO ), ;
        HTToast():show( "Stack 2", 4000, HT_CLR_TOAST_SUCCESS ), ;
        HTToast():show( "Stack 3", 5000, HT_CLR_TOAST_ERROR ) ;
    } )

    win:show()
    app:exec()

RETURN
