/*
 * HBTui Showcase - Comprehensive demo of all controls and features
 *
 * Demonstrates:
 *   - HTToolBar with clickable buttons (top bar)
 *   - MenuBar with theme switching and context menu
 *   - HTGet with numeric, date, and string PICTURE fields (TGet-backed)
 *   - HTBrowse data grid with right-click context menu
 *   - HTListBox, HTComboBox, HTCheckBox, HTRadioButton, HTSpinner
 *   - HTProgressBar, HTStatusBar, HTFrame, HTSeparator
 *   - HTTabWidget with two tabs:
 *       "Editor": HTTextEdit + HTScrollBar (companion)
 *       "Tasks":  HTCheckList (Space to toggle items)
 *   - HTCheckList in right panel for Permissions
 *   - Theme switching (View menu or F1-F4)
 *   - Clipboard (Ctrl+C/V/X in LineEdit/TextEdit)
 *
 * Keyboard:
 *   Tab/Shift+Tab   - cycle focus
 *   F10             - activate menu bar
 *   F1-F4           - switch theme (Default/Dark/HiContrast/Mono)
 *   Ctrl+Tab        - next tab in HTTabWidget
 *   Ctrl+Shift+Tab  - previous tab
 *   Space           - toggle checkbox / open combo / press button
 *   Enter           - activate browse row / press button
 *   Arrows          - navigate within controls
 *   Ctrl+C/V/X      - clipboard in LineEdit / TextEdit
 *   Ins             - toggle insert/overwrite in GET and TextEdit
 *   Ctrl+U          - undo in GET fields
 *   ESC             - close menu / combo dropdown
 */

#include "hbtui.ch"
#include "inkey.ch"

STATIC aData
STATIC nRecNo := 1
STATIC oStatusBar
STATIC oProgressBar
STATIC oWindow

/* GET field variables */
STATIC cName   := "John Doe                      "
STATIC cEmail  := "john@example.com              "
STATIC nSalary := 45000.00
STATIC dHired  := 0d20240115

PROCEDURE Main()

    LOCAL app, w1
    LOCAL menuBar, menu, submenu, act
    LOCAL oGet, brw, lst, cmb, chk, rdo, btn, spn
    LOCAL frm, sep
    LOCAL oCtxMenu
    LOCAL oToolBar
    LOCAL oTab
    LOCAL oTextEdit, oScrollBar
    LOCAL oTaskList, oPermList

    SetMode( 44, 106 )

    /* sample data for browse */
    aData := { ;
        { "HRB-001", "Harbour",      "Language",  85000.00 }, ;
        { "HRB-002", "HBTui",        "Framework", 12500.00 }, ;
        { "HRB-003", "TBrowse",      "Component",  8200.00 }, ;
        { "HRB-004", "CT Windows",   "Library",    6700.00 }, ;
        { "HRB-005", "GTxwc",        "Driver",     9400.00 }, ;
        { "HRB-006", "hbmk2",        "Build Tool", 11200.00 }, ;
        { "HRB-007", "hbclass",      "OOP",        7800.00 }, ;
        { "HRB-008", "hbct",         "Contrib",    5300.00 }, ;
        { "HRB-009", "hbwin",        "Contrib",    4100.00 }, ;
        { "HRB-010", "hbcurl",       "Contrib",    3800.00 }, ;
        { "HRB-011", "hbssl",        "Contrib",    2900.00 }, ;
        { "HRB-012", "hbziparc",     "Contrib",    3200.00 }  ;
    }

    app := HTApplication():new()

    w1 := HTMainWindow():new()
    w1:setWindowTitle( " HBTui Showcase " )
    w1:move( 1, 1 )
    w1:resize( 104, 42 )
    oWindow := w1

    /* ================================================================
       TOOLBAR (row 1 - below menu bar)
       ================================================================ */
    oToolBar := HTToolBar():new( w1 )
    oToolBar:move( 1, 1 )
    oToolBar:addButton( "New",     {|| UpdateStatus( "File > New" ) } )
    oToolBar:addButton( "Open",    {|| UpdateStatus( "File > Open" ) } )
    oToolBar:addButton( "Save",    {|| UpdateStatus( "Saved!" ), AdvanceProgress() } )
    oToolBar:addButton( "Refresh", {|| oWindow:repaint(), UpdateStatus( "Refreshed" ) } )
    oToolBar:addButton( "Quit",    {|| HTApplication():Fexecute := .F. } )
    oToolBar:resize( 102, 1 )

    /* ================================================================
       MENU BAR
       ================================================================ */
    menuBar := w1:menuBar

    menu := menuBar:addMenu( "File" )
    act := menu:addAction( "New" )
    act:onTriggered := {|| UpdateStatus( "File > New" ) }
    act := menu:addAction( "Open" )
    act:onTriggered := {|| UpdateStatus( "File > Open" ) }
    menu:addSeparator()
    act := menu:addAction( "Exit" )
    act:onTriggered := {|| HTApplication():Fexecute := .F. }

    menu := menuBar:addMenu( "Edit" )
    act := menu:addAction( "Cut   Ctrl+X" )
    act:onTriggered := {|| UpdateStatus( "Edit > Cut" ) }
    act := menu:addAction( "Copy  Ctrl+C" )
    act:onTriggered := {|| UpdateStatus( "Edit > Copy" ) }
    act := menu:addAction( "Paste Ctrl+V" )
    act:onTriggered := {|| UpdateStatus( "Edit > Paste" ) }

    menu := menuBar:addMenu( "View" )
    act := menu:addAction( "Refresh" )
    act:onTriggered := {|| UpdateStatus( "Refreshed" ), oWindow:repaint() }
    menu:addSeparator()

    /* theme switching submenu */
    submenu := menu:addMenu( "Themes" )
    act := submenu:addAction( "Default (Light)  F1" )
    act:onTriggered := {|| SwitchTheme( "Default" ) }
    act := submenu:addAction( "Dark             F2" )
    act:onTriggered := {|| SwitchTheme( "Dark" ) }
    act := submenu:addAction( "High Contrast    F3" )
    act:onTriggered := {|| SwitchTheme( "HighContrast" ) }
    act := submenu:addAction( "Monochrome       F4" )
    act:onTriggered := {|| SwitchTheme( "Mono" ) }

    menu := menuBar:addMenu( "Help" )
    act := menu:addAction( "About" )
    act:onTriggered := {|| HTMessageBox():information( "About", "HBTui Showcase v0.3 - All Controls Demo" ) }

    /* F-key theme shortcuts */
    w1:onKey( K_F1, {|| SwitchTheme( "Default" ) } )
    w1:onKey( K_F2, {|| SwitchTheme( "Dark" ) } )
    w1:onKey( K_F3, {|| SwitchTheme( "HighContrast" ) } )
    w1:onKey( K_F4, {|| SwitchTheme( "Mono" ) } )

    /* ================================================================
       LEFT PANEL - Form with TGet-backed fields (cols 1-37)
       ================================================================ */

    frm := HTFrame():new( "Employee Form", w1 )
    frm:move( 1, 2 )

    /* String GET with @! uppercase */
    oGet := HTGet():new( w1 )
    oGet:setup( {|x| IIF( x == NIL, cName, cName := x ) }, ;
                "Name:", "@!", NIL, NIL, "Employee name (auto uppercase)", ;
                {|v| UpdateStatus( "Name: " + AllTrim( v ) ) }, .F., .F., 35 )
    oGet:move( 2, 3 )

    /* String GET for email */
    oGet := HTGet():new( w1 )
    oGet:setup( {|x| IIF( x == NIL, cEmail, cEmail := x ) }, ;
                "Email:", "@S25", NIL, NIL, "Email address", NIL, .F., .F., 35 )
    oGet:move( 2, 5 )

    /* Numeric GET with decimal */
    oGet := HTGet():new( w1 )
    oGet:setup( {|x| IIF( x == NIL, nSalary, nSalary := x ) }, ;
                "Salary:", "999,999.99", ;
                {|v| IIF( v > 0, .T., ( UpdateStatus( "Salary must be > 0" ), .F. ) ) }, ;
                NIL, "Annual salary (VALID > 0)", ;
                {|v| UpdateStatus( "Salary: " + LTrim( Str( v, 12, 2 ) ) ) }, .F., .F., 35 )
    oGet:move( 2, 7 )

    /* Date GET */
    oGet := HTGet():new( w1 )
    oGet:setup( {|x| IIF( x == NIL, dHired, dHired := x ) }, ;
                "Hired:", "@D", NIL, NIL, "Hire date", ;
                {|v| UpdateStatus( "Hired: " + DToC( v ) ) }, .F., .F., 35 )
    oGet:move( 2, 9 )

    /* --- Options --- */
    sep := HTSeparator():new( w1 )
    sep:move( 1, 11 )

    HTLabel():new( "Options:", w1 ):move( 1, 12 )

    chk := HTCheckBox():new( "Auto-save", w1 )
    chk:move( 1, 13 )
    chk:onToggled := {|l| UpdateStatus( "Auto-save: " + IIF( l, "ON", "OFF" ) ) }

    chk := HTCheckBox():new( "Dark mode", w1 )
    chk:move( 1, 14 )
    chk:onToggled := {|l| ;
        IIF( l, HTTheme():loadDark(), HTTheme():loadDefault() ), ;
        oWindow:repaint(), ;
        UpdateStatus( "Dark mode: " + IIF( l, "ON", "OFF" ) ) ;
    }

    chk := HTCheckBox():new( "Notifications", w1 )
    chk:move( 1, 15 )

    sep := HTSeparator():new( w1 )
    sep:move( 1, 16 )

    /* --- Priority Radio Buttons --- */
    HTLabel():new( "Priority:", w1 ):move( 1, 17 )

    rdo := HTRadioButton():new( "High", w1 )
    rdo:move( 1, 18 )

    rdo := HTRadioButton():new( "Normal", w1 )
    rdo:move( 1, 19 )

    rdo := HTRadioButton():new( "Low", w1 )
    rdo:move( 1, 20 )

    sep := HTSeparator():new( w1 )
    sep:move( 1, 21 )

    /* --- Category ComboBox --- */
    HTLabel():new( "Category:", w1 ):move( 1, 22 )

    cmb := HTComboBox():new( w1 )
    cmb:move( 1, 23 )
    cmb:addItem( "Language" )
    cmb:addItem( "Framework" )
    cmb:addItem( "Library" )
    cmb:addItem( "Component" )
    cmb:addItem( "Driver" )
    cmb:addItem( "Build Tool" )
    cmb:addItem( "Contrib" )
    cmb:onChanged := {|| UpdateStatus( "Category: " + cmb:currentText() ) }

    /* --- Rating Spinner --- */
    spn := HTSpinner():new( w1 )
    spn:setup( "Rating", 0, 10, 1, 5 )
    spn:move( 1, 25 )
    spn:onChanged := {|n| UpdateStatus( "Rating: " + hb_ntos( n ) ) }

    /* ================================================================
       CENTER TOP - Data Browse with context menu (cols 38-79)
       ================================================================ */
    HTLabel():new( "Project Database:", w1 ):move( 38, 2 )

    brw := HTBrowse():new( w1 )
    brw:move( 38, 3 )
    brw:resize( 42, 9 )

    brw:setGoTopBlock( {|| nRecNo := 1 } )
    brw:setGoBottomBlock( {|| nRecNo := Len( aData ) } )
    brw:setSkipBlock( {|n| ArraySkip( n ) } )

    brw:addColumn( "Code",   {|| aData[ nRecNo, 1 ] }, 7 )
    brw:addColumn( "Name",   {|| aData[ nRecNo, 2 ] }, 12 )
    brw:addColumn( "Type",   {|| aData[ nRecNo, 3 ] }, 10 )
    brw:addColumn( "Budget", {|| aData[ nRecNo, 4 ] }, 9, "999,999.99" )

    brw:setHeadSep( e"\xC4" )
    brw:setColSep( e"\xB3" )

    brw:onActivated := {|r| UpdateStatus( "Activated: " + aData[ nRecNo, 2 ] + " (row " + hb_ntos( r ) + ")" ) }

    /* context menu for browse */
    oCtxMenu := HTContextMenu():new()
    oCtxMenu:addAction( "View Details" ):onTriggered := {|| UpdateStatus( "View: " + aData[ nRecNo, 2 ] ) }
    oCtxMenu:addAction( "Edit Record"  ):onTriggered := {|| UpdateStatus( "Edit: " + aData[ nRecNo, 2 ] ) }
    oCtxMenu:addSeparator()
    oCtxMenu:addAction( "Delete" ):onTriggered := {|| ;
        IIF( HTMessageBox():question( "Confirm", "Delete " + aData[ nRecNo, 2 ] + "?" ) = 1, ;
            UpdateStatus( "Deleted: " + aData[ nRecNo, 2 ] ), ;
            UpdateStatus( "Cancelled." ) ) ;
    }
    brw:contextMenu := oCtxMenu

    /* ================================================================
       CENTER BOTTOM - Tab widget: Editor tab + Tasks tab (cols 38-79)
       ================================================================ */
    HTLabel():new( "Editor / Tasks:", w1 ):move( 38, 13 )

    oTab := HTTabWidget():new( w1 )
    oTab:move( 38, 14 )
    oTab:resize( 42, 14 )
    oTab:onTabChanged := {|n| UpdateStatus( "Tab: " + IIF( n = 1, "Editor", "Tasks" ) ) }

    oTab:addTab( "Editor" )
    oTab:addTab( "Tasks" )

    /* Tab 1: HTTextEdit + HTScrollBar */
    oTextEdit := HTTextEdit():new()
    oTextEdit:move( 0, 0 )
    oTextEdit:resize( 40, 12 )
    oTextEdit:text := "HBTui multi-line text editor." + hb_eol() + ;
                      "Supports cursor navigation, insert/delete," + hb_eol() + ;
                      "Ctrl+C/X/V clipboard, Home/End, PgUp/PgDn." + hb_eol() + ;
                      "" + hb_eol() + ;
                      "Click here or Tab to the tab widget," + hb_eol() + ;
                      "then click this area to focus the editor." + hb_eol() + ;
                      "Use arrow keys, type to edit," + hb_eol() + ;
                      "Del/Backspace to delete characters."
    oTextEdit:onChanged := {|| UpdateStatus( "Text modified" ) }
    oTab:addWidgetToTab( 1, oTextEdit )

    oScrollBar := HTScrollBar():new()
    oScrollBar:move( 41, 0 )
    oScrollBar:resize( 1, 12 )
    oScrollBar:minimum := 0
    oScrollBar:maximum := 100
    oScrollBar:value := 0
    oTab:addWidgetToTab( 1, oScrollBar )

    /* Tab 2: HTCheckList */
    oTaskList := HTCheckList():new()
    oTaskList:move( 0, 0 )
    oTaskList:resize( 42, 12 )
    oTaskList:addItem( "Add toolbar support",    .T. )
    oTaskList:addItem( "Add context menu",       .T. )
    oTaskList:addItem( "Add tab widget",         .T. )
    oTaskList:addItem( "Add text editor",        .T. )
    oTaskList:addItem( "Add scrollbar widget",   .T. )
    oTaskList:addItem( "Add checklist widget",   .T. )
    oTaskList:addItem( "Add theme system",       .T. )
    oTaskList:addItem( "Add test suite",         .F. )
    oTaskList:addItem( "Write documentation",    .F. )
    oTaskList:addItem( "Publish v0.3 release",   .F. )
    oTaskList:onChanged := {|n, l| ;
        UpdateStatus( "Task " + hb_ntos( n ) + ": " + IIF( l, "done", "pending" ) ) ;
    }
    oTab:addWidgetToTab( 2, oTaskList )

    /* ================================================================
       RIGHT PANEL - ListBox + Progress + CheckList (cols 80-103)
       ================================================================ */
    HTLabel():new( "Recent Activity:", w1 ):move( 80, 2 )

    lst := HTListBox():new( w1 )
    lst:move( 80, 3 )
    lst:resize( 24, 8 )
    lst:addItem( "Compiled project" )
    lst:addItem( "Ran tests" )
    lst:addItem( "Fixed bug #42" )
    lst:addItem( "Updated docs" )
    lst:addItem( "Code review" )
    lst:addItem( "Deployed v2.0" )
    lst:addItem( "Merged PR #15" )
    lst:addItem( "Released beta" )
    lst:addItem( "Fixed bug #43" )
    lst:addItem( "Updated deps" )
    lst:addItem( "Perf tuning" )
    lst:addItem( "Security audit" )
    lst:onChanged := {|nIdx| UpdateStatus( "Recent: " + lst:itemText( nIdx ) ) }

    /* --- Build Progress --- */
    HTLabel():new( "Build Progress:", w1 ):move( 80, 12 )

    oProgressBar := HTProgressBar():new( w1 )
    oProgressBar:move( 80, 13 )
    oProgressBar:resize( 24, 1 )

    /* --- Permissions CheckList --- */
    HTLabel():new( "Permissions:", w1 ):move( 80, 15 )

    oPermList := HTCheckList():new( w1 )
    oPermList:move( 80, 16 )
    oPermList:resize( 24, 11 )
    oPermList:addItem( "Read files",    .T. )
    oPermList:addItem( "Write files",   .T. )
    oPermList:addItem( "Execute",       .F. )
    oPermList:addItem( "Network",       .F. )
    oPermList:addItem( "Send email",    .T. )
    oPermList:addItem( "Notifications", .T. )
    oPermList:addItem( "Admin access",  .F. )
    oPermList:addItem( "Debug mode",    .F. )
    oPermList:onChanged := {|n, l| ;
        UpdateStatus( "Permission " + hb_ntos( n ) + ": " + IIF( l, "granted", "denied" ) ) ;
    }

    /* ================================================================
       BOTTOM - Buttons
       ================================================================ */
    sep := HTSeparator():new( w1 )
    sep:move( 1, 28 )

    btn := HTPushButton():new( "Save", w1 )
    btn:move( 1, 30 )
    btn:onClicked := {|| UpdateStatus( "Saved!" ), AdvanceProgress() }

    btn := HTPushButton():new( "Reset", w1 )
    btn:move( 10, 30 )
    btn:onClicked := {|| UpdateStatus( "Reset." ), ResetProgress() }

    btn := HTPushButton():new( "Delete", w1 )
    btn:move( 20, 30 )
    btn:onClicked := {|| ;
        IIF( HTMessageBox():question( "Confirm", "Are you sure you want to delete?" ) = 1, ;
            UpdateStatus( "Deleted." ), ;
            UpdateStatus( "Cancelled." ) ) ;
    }

    btn := HTPushButton():new( "Quit", w1 )
    btn:move( 31, 30 )
    btn:onClicked := {|| HTApplication():Fexecute := .F. }

    /* ================================================================
       STATUS BAR
       ================================================================ */
    oStatusBar := HTStatusBar():new( w1 )
    oStatusBar:move( 1, 32 )
    oStatusBar:addSection( "Ready" )
    oStatusBar:addSection( "F1-F4: themes" )
    oStatusBar:addSection( "HBTui v0.3" )

    /* ================================================================
       SHOW
       ================================================================ */
    w1:show()
    app:exec()

RETURN

/* ----------------------------------------------------------------
   Helper functions
   ---------------------------------------------------------------- */

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

STATIC PROCEDURE SwitchTheme( cName )

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

    IF oWindow != NIL
        oWindow:repaint()
    ENDIF

    UpdateStatus( "Theme: " + cName )

RETURN

STATIC PROCEDURE AdvanceProgress()

    LOCAL nVal, parent

    IF oProgressBar != NIL
        nVal := oProgressBar:value + 10
        IF nVal > 100
            nVal := 100
        ENDIF
        oProgressBar:setValue( nVal )
        parent := oProgressBar:parent()
        IF parent != NIL
            parent:repaintChild( oProgressBar )
        ENDIF
    ENDIF

RETURN

STATIC PROCEDURE ResetProgress()

    LOCAL parent

    IF oProgressBar != NIL
        oProgressBar:setValue( 0 )
        parent := oProgressBar:parent()
        IF parent != NIL
            parent:repaintChild( oProgressBar )
        ENDIF
    ENDIF

RETURN

STATIC FUNCTION ArraySkip( nRequest )

    LOCAL nActual

    nActual := IIF( nRequest > 0, ;
        Min( nRequest, Len( aData ) - nRecNo ), ;
        Max( nRequest, 1 - nRecNo ) )

    nRecNo += nActual

RETURN nActual
