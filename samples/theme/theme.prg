/*
 * HTTheme Demo - Live theme switching with F-keys
 *
 * Demonstrates:
 *   - Four built-in themes: Default, Dark, HighContrast, Monochrome
 *   - Real-time switching via function keys (onKey bindings)
 *   - Label, ListBox, PushButton, CheckBox rendered under each theme
 *   - StatusBar showing the current theme name
 *
 * Keyboard:
 *   F1             - Default (light) theme
 *   F2             - Dark theme
 *   F3             - High Contrast theme
 *   F4             - Monochrome theme
 *   Tab/Shift+Tab  - cycle focus
 *   Space          - press buttons / toggle checkbox
 *   ESC            - quit
 */

#include "hbtui.ch"
#include "inkey.ch"

STATIC oStatusBar
STATIC oWindow

PROCEDURE Main()

    LOCAL app, win
    LOCAL lst, btn, chk, frm

    SetMode( 25, 60 )

    app := HTApplication():new()

    win := HTMainWindow():new()
    win:setWindowTitle( " Theme Switcher " )
    win:move( 1, 1 )
    win:resize( 55, 21 )
    oWindow := win

    /* --- Frame --- */
    frm := HTFrame():new( "Sample Controls", win )
    frm:move( 1, 1 )

    /* --- Label --- */
    HTLabel():new( "Select a theme with F1-F4:", win ):move( 2, 2 )

    /* --- Checkboxes --- */
    chk := HTCheckBox():new( "Option A", win )
    chk:move( 2, 4 )

    chk := HTCheckBox():new( "Option B", win )
    chk:move( 2, 5 )

    /* --- ListBox --- */
    HTLabel():new( "Items:", win ):move( 25, 2 )

    lst := HTListBox():new( win )
    lst:move( 25, 3 )
    lst:addItem( "Harbour" )
    lst:addItem( "HBTui" )
    lst:addItem( "TBrowse" )
    lst:addItem( "CT Windows" )
    lst:addItem( "GTxwc" )
    lst:addItem( "hbmk2" )
    lst:addItem( "hbclass" )

    /* --- Separator --- */
    HTSeparator():new( win ):move( 1, 10 )

    /* --- Theme buttons --- */
    HTLabel():new( "Or click a button:", win ):move( 2, 12 )

    btn := HTPushButton():new( "Default", win )
    btn:move( 2, 14 )
    btn:onClicked := {|| SwitchTheme( "Default" ) }

    btn := HTPushButton():new( "Dark", win )
    btn:move( 14, 14 )
    btn:onClicked := {|| SwitchTheme( "Dark" ) }

    btn := HTPushButton():new( "HiContrast", win )
    btn:move( 23, 14 )
    btn:onClicked := {|| SwitchTheme( "HighContrast" ) }

    btn := HTPushButton():new( "Mono", win )
    btn:move( 38, 14 )
    btn:onClicked := {|| SwitchTheme( "Mono" ) }

    /* --- Status Bar --- */
    oStatusBar := HTStatusBar():new( win )
    oStatusBar:move( 1, 17 )
    oStatusBar:addSection( "Theme: Default" )
    oStatusBar:addSection( "F1-F4 to switch" )

    /* --- F-key bindings for theme switching --- */
    win:onKey( K_F1, {|| SwitchTheme( "Default" ) } )
    win:onKey( K_F2, {|| SwitchTheme( "Dark" ) } )
    win:onKey( K_F3, {|| SwitchTheme( "HighContrast" ) } )
    win:onKey( K_F4, {|| SwitchTheme( "Mono" ) } )

    win:show()
    app:exec()

RETURN

STATIC PROCEDURE SwitchTheme( cName )

    LOCAL parent

    SWITCH cName
    CASE "Default"
        HTTheme():loadDefault()
        EXIT
    CASE "Dark"
        HTTheme():loadDark()
        EXIT
    CASE "HighContrast"
        HTTheme():loadHighContrast()
        EXIT
    CASE "Mono"
        HTTheme():loadMono()
        EXIT
    ENDSWITCH

    IF oStatusBar != NIL
        oStatusBar:setSection( 1, "Theme: " + cName )
    ENDIF

    IF oWindow != NIL
        oWindow:repaint()
    ENDIF

    parent := oStatusBar:parent()
    IF parent != NIL
        parent:repaintChild( oStatusBar )
    ENDIF

RETURN
