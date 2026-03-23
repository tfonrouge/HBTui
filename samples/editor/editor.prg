/** @file editor.prg
 * Text Editing Demo - Single-line and multi-line editors
 *
 * Demonstrates:
 *   - HTLineEdit for single-line input with clipboard
 *   - HTTextEdit for multi-line editing
 *   - HTSeparator between sections
 *
 * Keyboard:
 *   Tab/Shift+Tab  - cycle focus
 *   Ctrl+C/V/X     - clipboard operations
 *   Ins             - toggle insert/overwrite
 *   ESC             - quit
 */

#include "hbtui.ch"
#include "inkey.ch"

PROCEDURE Main()

    LOCAL app, win
    LOCAL edt, sep, txt
    LOCAL oStatusBar

    SetMode( 25, 65 )

    app := HTApplication():new()

    win := HTMainWindow():new()
    win:setWindowTitle( " Editor Demo " )
    win:move( 1, 1 )
    win:resize( 63, 23 )

    /* --- Single-line input --- */
    edt := HTLineEdit():new( win )
    edt:move( 1, 1 )
    edt:resize( 61, 1 )
    edt:text := "Single-line input (Ctrl+C/V/X clipboard)"

    /* --- Separator --- */
    sep := HTSeparator():new( win )
    sep:move( 1, 3 )
    sep:resize( 61, 1 )

    /* --- Multi-line editor --- */
    txt := HTTextEdit():new( win )
    txt:move( 1, 5 )
    txt:resize( 61, 15 )
    txt:text := "Multi-line text editor." + hb_eol() + ;
                "" + hb_eol() + ;
                "Type here to edit text. Use arrow keys to navigate," + hb_eol() + ;
                "Home/End for line start/end, PgUp/PgDn to scroll." + hb_eol() + ;
                "" + hb_eol() + ;
                "Select: Shift+Arrows, Shift+Home/End" + hb_eol() + ;
                "Clipboard: Ctrl+C (copy), Ctrl+X (cut), Ctrl+V (paste)" + hb_eol() + ;
                "Press Ins to toggle insert/overwrite mode." + hb_eol() + ;
                "" + hb_eol() + ;
                "This is a full-featured text editing widget."

    /* --- Status Bar --- */
    oStatusBar := HTStatusBar():new( win )
    oStatusBar:addSection( "Shift+Arrows: select | Ctrl+C/X/V: copy/cut/paste | Ins: mode" )

    win:show()
    app:exec()

RETURN
