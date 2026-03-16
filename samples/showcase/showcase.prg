/*
 * HBTui Showcase - Comprehensive demo of all controls
 *
 * Left panel:  Form controls (LineEdit, CheckBox, RadioButton, ComboBox)
 * Center:      TBrowse data grid
 * Right panel: ListBox, ProgressBar
 * Bottom:      Buttons, StatusBar
 * Top:         MenuBar with functional items
 *
 * Keyboard:
 *   Tab/Shift+Tab - cycle focus
 *   F10           - activate menu bar
 *   Space         - toggle checkbox / open combo / press button
 *   Enter         - activate browse row / press button
 *   Arrows        - navigate within controls
 *   ESC           - close menu / combo dropdown
 */

#include "hbtui.ch"
#include "inkey.ch"

STATIC aData
STATIC nRecNo := 1
STATIC oStatusBar
STATIC oProgressBar

PROCEDURE Main()

    LOCAL app, w1
    LOCAL menuBar, menu, act
    LOCAL edt, chk, rdo, cmb, lst, brw, btn
    LOCAL frm, sep

    SetMode( 38, 100 )

    /* sample data */
    aData := { ;
        { "HRB-001", "Harbour",      "Language",    "Active"   }, ;
        { "HRB-002", "HBTui",        "Framework",   "Active"   }, ;
        { "HRB-003", "TBrowse",      "Component",   "Stable"   }, ;
        { "HRB-004", "CT Windows",   "Library",     "Stable"   }, ;
        { "HRB-005", "GTxwc",        "Driver",      "Active"   }, ;
        { "HRB-006", "hbmk2",        "Build Tool",  "Active"   }, ;
        { "HRB-007", "hbclass",      "OOP",         "Stable"   }, ;
        { "HRB-008", "hbct",         "Contrib",     "Stable"   }, ;
        { "HRB-009", "hbwin",        "Contrib",     "Active"   }, ;
        { "HRB-010", "hbcurl",       "Contrib",     "Active"   }, ;
        { "HRB-011", "hbssl",        "Contrib",     "Beta"     }, ;
        { "HRB-012", "hbziparc",     "Contrib",     "Stable"   }  ;
    }

    app := HTApplication():new()

    w1 := HTMainWindow():new()
    w1:setWindowTitle( " HBTui Showcase " )
    w1:move( 2, 1 )
    w1:resize( 94, 33 )

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
    act := menu:addAction( "Cut" )
    act:onTriggered := {|| UpdateStatus( "Edit > Cut" ) }
    act := menu:addAction( "Copy" )
    act:onTriggered := {|| UpdateStatus( "Edit > Copy" ) }
    act := menu:addAction( "Paste" )
    act:onTriggered := {|| UpdateStatus( "Edit > Paste" ) }

    menu := menuBar:addMenu( "View" )
    act := menu:addAction( "Refresh" )
    act:onTriggered := {|| UpdateStatus( "View > Refresh" ), w1:repaint() }

    menu := menuBar:addMenu( "Help" )
    act := menu:addAction( "About" )
    act:onTriggered := {|| HTMessageBox():information( "About", "HBTui Showcase - All Controls Demo" ) }

    /* ================================================================
       LEFT PANEL - Form Controls
       ================================================================ */

    /* --- Frame: Personal Info --- */
    frm := HTFrame():new( "Personal Info", w1 )
    frm:move( 1, 1 )

    HTLabel():new( "Name:", w1 ):move( 2, 2 )
    edt := HTLineEdit():new( w1 )
    edt:move( 8, 2 )
    edt:onChanged := {|ct| UpdateStatus( "Name: " + ct ) }

    HTLabel():new( "Email:", w1 ):move( 2, 4 )
    edt := HTLineEdit():new( w1 )
    edt:move( 8, 4 )

    /* --- Separator --- */
    sep := HTSeparator():new( w1 )
    sep:move( 1, 6 )

    /* --- CheckBoxes --- */
    HTLabel():new( "Options:", w1 ):move( 1, 7 )

    chk := HTCheckBox():new( "Auto-save", w1 )
    chk:move( 1, 8 )
    chk:onToggled := {|l| UpdateStatus( "Auto-save: " + IIF( l, "ON", "OFF" ) ) }

    chk := HTCheckBox():new( "Dark mode", w1 )
    chk:move( 1, 9 )
    chk:onToggled := {|l| UpdateStatus( "Dark mode: " + IIF( l, "ON", "OFF" ) ) }

    chk := HTCheckBox():new( "Notifications", w1 )
    chk:move( 1, 10 )

    /* --- Separator --- */
    sep := HTSeparator():new( w1 )
    sep:move( 1, 11 )

    /* --- Radio Buttons --- */
    HTLabel():new( "Priority:", w1 ):move( 1, 12 )

    rdo := HTRadioButton():new( "High", w1 )
    rdo:move( 1, 13 )
    rdo:onClicked := {|| UpdateStatus( "Priority: High" ) }

    rdo := HTRadioButton():new( "Normal", w1 )
    rdo:move( 1, 14 )
    rdo:onClicked := {|| UpdateStatus( "Priority: Normal" ) }

    rdo := HTRadioButton():new( "Low", w1 )
    rdo:move( 1, 15 )
    rdo:onClicked := {|| UpdateStatus( "Priority: Low" ) }

    /* --- Separator --- */
    sep := HTSeparator():new( w1 )
    sep:move( 1, 16 )

    /* --- ComboBox --- */
    HTLabel():new( "Category:", w1 ):move( 1, 17 )

    cmb := HTComboBox():new( w1 )
    cmb:move( 1, 18 )
    cmb:addItem( "Language" )
    cmb:addItem( "Framework" )
    cmb:addItem( "Library" )
    cmb:addItem( "Component" )
    cmb:addItem( "Driver" )
    cmb:addItem( "Build Tool" )
    cmb:addItem( "Contrib" )
    cmb:onChanged := {|| UpdateStatus( "Category: " + cmb:currentText() ) }

    /* ================================================================
       CENTER - Data Browse
       ================================================================ */
    HTLabel():new( "Project Database:", w1 ):move( 24, 1 )

    brw := HTBrowse():new( w1 )
    brw:move( 24, 2 )

    brw:setGoTopBlock( {|| nRecNo := 1 } )
    brw:setGoBottomBlock( {|| nRecNo := Len( aData ) } )
    brw:setSkipBlock( {|n| ArraySkip( n ) } )

    brw:addColumn( "Code",     {|| aData[ nRecNo, 1 ] }, 10 )
    brw:addColumn( "Name",     {|| aData[ nRecNo, 2 ] }, 14 )
    brw:addColumn( "Type",     {|| aData[ nRecNo, 3 ] }, 12 )
    brw:addColumn( "Status",   {|| aData[ nRecNo, 4 ] }, 10 )

    brw:setHeadSep( e"\xC4" )
    brw:setColSep( " " + e"\xB3" + " " )

    brw:onActivated := {|r| UpdateStatus( "Activated: " + aData[ nRecNo, 2 ] + " (row " + hb_ntos(r) + ")" ) }

    /* ================================================================
       RIGHT PANEL - ListBox + Progress
       ================================================================ */
    HTLabel():new( "Recent:", w1 ):move( 72, 1 )

    lst := HTListBox():new( w1 )
    lst:move( 72, 2 )
    lst:addItem( "Compiled project" )
    lst:addItem( "Ran tests" )
    lst:addItem( "Fixed bug #42" )
    lst:addItem( "Updated docs" )
    lst:addItem( "Code review" )
    lst:addItem( "Deployed v2.0" )
    lst:addItem( "Merged PR #15" )
    lst:addItem( "Released beta" )
    lst:onChanged := {|nIdx| UpdateStatus( "Recent: " + lst:itemText( nIdx ) ) }

    /* --- Progress Bar --- */
    HTLabel():new( "Build Progress:", w1 ):move( 72, 12 )

    oProgressBar := HTProgressBar():new( w1 )
    oProgressBar:move( 72, 13 )

    /* ================================================================
       BOTTOM - Buttons
       ================================================================ */

    /* --- Separator --- */
    sep := HTSeparator():new( w1 )
    sep:move( 1, 20 )

    btn := HTPushButton():new( "Save", w1 )
    btn:move( 1, 22 )
    btn:onClicked := {|| UpdateStatus( "Saved!" ), AdvanceProgress() }

    btn := HTPushButton():new( "Reset", w1 )
    btn:move( 10, 22 )
    btn:onClicked := {|| UpdateStatus( "Reset." ), ResetProgress() }

    btn := HTPushButton():new( "Delete", w1 )
    btn:move( 20, 22 )
    btn:onClicked := {|| ;
        IIF( HTMessageBox():question( "Confirm", "Are you sure you want to delete?" ) = 1, ;
            UpdateStatus( "Deleted." ), ;
            UpdateStatus( "Cancelled." ) ) ;
    }

    btn := HTPushButton():new( "Quit", w1 )
    btn:move( 31, 22 )
    btn:onClicked := {|| HTApplication():Fexecute := .F. }

    /* ================================================================
       STATUS BAR
       ================================================================ */
    oStatusBar := HTStatusBar():new( w1 )
    oStatusBar:move( 1, 25 )
    oStatusBar:addSection( "Ready" )
    oStatusBar:addSection( "Row: 1" )
    oStatusBar:addSection( "HBTui v0.2" )

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
