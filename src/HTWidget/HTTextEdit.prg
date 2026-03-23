/** @class HTTextEdit
 * Modern multi-line text editor widget with cursor navigation, insert/delete,
 * clipboard support, and viewport scrolling.
 * @extends HTWidget
 *
 * @property text      Full text content (get/set as single string with hb_eol() line breaks)
 * @property readOnly  .T. to disable editing
 * @property onChanged Callback {|cText| ...} fired on content modification
 *
 * @example
 *   oEdit := HTTextEdit():new( oParent )
 *   oEdit:move( 1, 1 )
 *   oEdit:resize( 60, 20 )
 *   oEdit:text := "Line 1" + hb_eol() + "Line 2"
 *   oEdit:onChanged := {|cText| UpdateStatus( "Modified" ) }
 *
 * @see HTLineEdit, HTEditor
 */

#include "hbtui.ch"
#include "inkey.ch"
#include "hbgtinfo.ch"

CLASS HTTextEdit FROM HTWidget

PROTECTED:

    DATA FaLines     INIT { "" }       /* array of line strings */
    DATA FnCurRow    INIT 1            /* cursor row (1-based, in line array) */
    DATA FnCurCol    INIT 1            /* cursor column (1-based, in current line) */
    DATA FnTopRow    INIT 1            /* first visible line (scroll offset) */
    DATA FnLeftCol   INIT 1            /* first visible column (horizontal scroll) */
    DATA FreadOnly   INIT .F.
    DATA FnSelAnchorRow INIT 0        /* selection anchor row (0 = no selection) */
    DATA FnSelAnchorCol INIT 0        /* selection anchor column */

    METHOD hasSelection()
    METHOD getSelectedText()
    METHOD deleteSelection()
    METHOD clearSelection() INLINE ::FnSelAnchorRow := 0, ::FnSelAnchorCol := 0
    METHOD selectionRange()           /* returns { startRow, startCol, endRow, endCol } or NIL */

PUBLIC:

    CONSTRUCTOR new( parent )

    METHOD paintEvent( event )
    METHOD keyEvent( keyEvent )
    METHOD mouseEvent( eventMouse )

    METHOD getText()
    METHOD setText( cText )

    PROPERTY text READ getText WRITE setText
    METHOD readOnly()   INLINE ::FreadOnly
    METHOD _readOnly( b ) INLINE ::FreadOnly := b
    PROPERTY onChanged READWRITE         /* {|cText| ... } */

ENDCLASS

/** Creates a new multi-line text editor. */
METHOD new( parent ) CLASS HTTextEdit

    ::super:new( parent )
    ::setFocusPolicy( HT_FOCUS_STRONG )
    ::FisVisible := .T.
    ::Fheight := 10
    ::Fwidth := 40

RETURN self

/** Returns all lines joined as a single string.
 * @return String with hb_eol() line separators
 */
METHOD FUNCTION getText() CLASS HTTextEdit

    LOCAL i, cResult := ""

    FOR i := 1 TO Len( ::FaLines )
        IF i > 1
            cResult += hb_eol()
        ENDIF
        cResult += ::FaLines[ i ]
    NEXT

RETURN cResult

/** Sets the text content, splitting into lines.
 * @param cText String with line breaks
 */
METHOD PROCEDURE setText( cText ) CLASS HTTextEdit

    IF cText == NIL
        cText := ""
    ENDIF

    ::FaLines := hb_ATokens( cText, .T. )

    IF Len( ::FaLines ) = 0
        ::FaLines := { "" }
    ENDIF

    ::FnCurRow  := 1
    ::FnCurCol  := 1
    ::FnTopRow  := 1
    ::FnLeftCol := 1

RETURN

/** Returns .T. if there is an active multi-line selection. */
METHOD FUNCTION hasSelection() CLASS HTTextEdit
RETURN ::FnSelAnchorRow > 0 .AND. ;
    ( ::FnSelAnchorRow != ::FnCurRow .OR. ::FnSelAnchorCol != ::FnCurCol )

/** Returns the normalized selection range { startRow, startCol, endRow, endCol } or NIL. */
METHOD FUNCTION selectionRange() CLASS HTTextEdit

    LOCAL nR1, nC1, nR2, nC2

    IF ! ::hasSelection()
        RETURN NIL
    ENDIF

    nR1 := ::FnSelAnchorRow
    nC1 := ::FnSelAnchorCol
    nR2 := ::FnCurRow
    nC2 := ::FnCurCol

    IF nR1 > nR2 .OR. ( nR1 = nR2 .AND. nC1 > nC2 )
        RETURN { nR2, nC2, nR1, nC1 }
    ENDIF

RETURN { nR1, nC1, nR2, nC2 }

/** Returns the text within the current selection. */
METHOD FUNCTION getSelectedText() CLASS HTTextEdit

    LOCAL aRange, nR1, nC1, nR2, nC2, cResult, i

    aRange := ::selectionRange()
    IF aRange = NIL
        RETURN ""
    ENDIF

    nR1 := aRange[ 1 ]; nC1 := aRange[ 2 ]
    nR2 := aRange[ 3 ]; nC2 := aRange[ 4 ]

    IF nR1 = nR2
        RETURN SubStr( ::FaLines[ nR1 ], nC1, nC2 - nC1 )
    ENDIF

    cResult := SubStr( ::FaLines[ nR1 ], nC1 )
    FOR i := nR1 + 1 TO nR2 - 1
        cResult += hb_eol() + ::FaLines[ i ]
    NEXT
    cResult += hb_eol() + Left( ::FaLines[ nR2 ], nC2 - 1 )

RETURN cResult

/** Deletes the text within the current selection and repositions the cursor. */
METHOD PROCEDURE deleteSelection() CLASS HTTextEdit

    LOCAL aRange, nR1, nC1, nR2, nC2

    aRange := ::selectionRange()
    IF aRange = NIL
        RETURN
    ENDIF

    nR1 := aRange[ 1 ]; nC1 := aRange[ 2 ]
    nR2 := aRange[ 3 ]; nC2 := aRange[ 4 ]

    IF nR1 = nR2
        ::FaLines[ nR1 ] := Left( ::FaLines[ nR1 ], nC1 - 1 ) + SubStr( ::FaLines[ nR1 ], nC2 )
    ELSE
        ::FaLines[ nR1 ] := Left( ::FaLines[ nR1 ], nC1 - 1 ) + SubStr( ::FaLines[ nR2 ], nC2 )
        IF nR2 > nR1 + 1
            ADel( ::FaLines, nR1 + 1, nR2 - nR1 - 1 )
            ASize( ::FaLines, Len( ::FaLines ) - ( nR2 - nR1 - 1 ) )
        ENDIF
        hb_aDel( ::FaLines, nR1 + 1, .T. )
    ENDIF

    ::FnCurRow := nR1
    ::FnCurCol := nC1
    ::clearSelection()

RETURN

/** Renders visible lines with cursor positioning.
 * @param event HTPaintEvent (unused)
 */
METHOD PROCEDURE paintEvent( event ) CLASS HTTextEdit

    LOCAL i, nRow, cLine, cColor, cSelColor, cDisplay
    LOCAL nMaxRow := MaxRow()
    LOCAL nMaxCol := MaxCol()
    LOCAL nVisRows := nMaxRow + 1
    LOCAL nVisCols := nMaxCol + 1
    LOCAL nCursorRow, nCursorCol
    LOCAL aRange, nSelR1, nSelC1, nSelR2, nSelC2
    LOCAL nSelStart, nSelEnd

    HB_SYMBOL_UNUSED( event )

    cColor := IIF( ::hasFocus(), HTTheme():getColor( HT_CLR_LINEEDIT_FOCUSED ), HTTheme():getColor( HT_CLR_LINEEDIT_NORMAL ) )
    cSelColor := HTTheme():getColor( HT_CLR_LINEEDIT_SELECTED )

    /* get selection range */
    aRange := ::selectionRange()
    IF aRange != NIL
        nSelR1 := aRange[ 1 ]; nSelC1 := aRange[ 2 ]
        nSelR2 := aRange[ 3 ]; nSelC2 := aRange[ 4 ]
    ENDIF

    /* ensure cursor is visible */
    IF ::FnCurRow < ::FnTopRow
        ::FnTopRow := ::FnCurRow
    ENDIF
    IF ::FnCurRow > ::FnTopRow + nVisRows - 1
        ::FnTopRow := ::FnCurRow - nVisRows + 1
    ENDIF
    IF ::FnCurCol < ::FnLeftCol
        ::FnLeftCol := ::FnCurCol
    ENDIF
    IF ::FnCurCol > ::FnLeftCol + nVisCols - 1
        ::FnLeftCol := ::FnCurCol - nVisCols + 1
    ENDIF

    /* paint visible lines */
    nRow := 0
    FOR i := ::FnTopRow TO Min( ::FnTopRow + nVisRows - 1, Len( ::FaLines ) )
        cLine := ::FaLines[ i ]
        cDisplay := PadR( SubStr( cLine, ::FnLeftCol ), nVisCols )

        IF aRange != NIL .AND. i >= nSelR1 .AND. i <= nSelR2
            /* this line has selection — render in segments */
            nSelStart := IIF( i = nSelR1, Max( nSelC1 - ::FnLeftCol, 0 ), 0 )
            nSelEnd   := IIF( i = nSelR2, Min( nSelC2 - ::FnLeftCol, nVisCols ), nVisCols )
            IF nSelStart < nSelEnd
                /* before selection */
                IF nSelStart > 0
                    DispOutAt( nRow, 0, Left( cDisplay, nSelStart ), cColor )
                ENDIF
                /* selected portion */
                DispOutAt( nRow, nSelStart, SubStr( cDisplay, nSelStart + 1, nSelEnd - nSelStart ), cSelColor )
                /* after selection */
                IF nSelEnd < nVisCols
                    DispOutAt( nRow, nSelEnd, SubStr( cDisplay, nSelEnd + 1 ), cColor )
                ENDIF
            ELSE
                DispOutAt( nRow, 0, cDisplay, cColor )
            ENDIF
        ELSE
            DispOutAt( nRow, 0, cDisplay, cColor )
        ENDIF
        nRow++
    NEXT

    /* clear remaining rows */
    DO WHILE nRow <= nMaxRow
        DispOutAt( nRow, 0, Space( nVisCols ), cColor )
        nRow++
    ENDDO

    /* position cursor */
    IF ::hasFocus()
        nCursorRow := ::FnCurRow - ::FnTopRow
        nCursorCol := ::FnCurCol - ::FnLeftCol
        IF nCursorRow >= 0 .AND. nCursorRow <= nMaxRow .AND. nCursorCol >= 0 .AND. nCursorCol <= nMaxCol
            SetPos( nCursorRow, nCursorCol )
        ENDIF
    ENDIF

RETURN

/** Handles keyboard input for navigation, editing, and clipboard.
 * @param keyEvent HTKeyEvent
 */
METHOD PROCEDURE keyEvent( keyEvent ) CLASS HTTextEdit

    LOCAL parent
    LOCAL cChar, cLine, cPaste, aPasteLines, i, cSel
    LOCAL lChanged := .F.
    LOCAL nLineCount := Len( ::FaLines )
    LOCAL nShifts := hb_gtInfo( HB_GTI_KBDSHIFTS )
    LOCAL lCtrl  := hb_bitAnd( nShifts, HB_GTI_KBD_CTRL ) != 0
    LOCAL lShift := hb_bitAnd( nShifts, HB_GTI_KBD_SHIFT ) != 0

    /* --- Clipboard (handle before SWITCH to avoid key code collisions) --- */
    IF lCtrl
        IF keyEvent:key = K_PGDN   /* K_CTRL_C = K_PGDN = 3 */
            /* copy selection (or current line if no selection) */
            IF ::hasSelection()
                hb_gtInfo( HB_GTI_CLIPBOARDDATA, ::getSelectedText() )
            ELSE
                hb_gtInfo( HB_GTI_CLIPBOARDDATA, ::FaLines[ ::FnCurRow ] )
            ENDIF
            keyEvent:accept()
            RETURN
        ELSEIF keyEvent:key = K_DOWN .AND. ! ::FreadOnly   /* K_CTRL_X = K_DOWN = 24 */
            /* cut selection (or current line if no selection) */
            IF ::hasSelection()
                hb_gtInfo( HB_GTI_CLIPBOARDDATA, ::getSelectedText() )
                ::deleteSelection()
            ELSE
                hb_gtInfo( HB_GTI_CLIPBOARDDATA, ::FaLines[ ::FnCurRow ] )
                IF Len( ::FaLines ) > 1
                    hb_aDel( ::FaLines, ::FnCurRow, .T. )
                    IF ::FnCurRow > Len( ::FaLines )
                        ::FnCurRow := Len( ::FaLines )
                    ENDIF
                ELSE
                    ::FaLines[ 1 ] := ""
                ENDIF
                ::FnCurCol := Min( ::FnCurCol, Len( ::FaLines[ ::FnCurRow ] ) + 1 )
            ENDIF
            lChanged := .T.
            keyEvent:accept()
            parent := ::parent()
            IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
                parent:repaintChild( self )
            ENDIF
            IF ::FonChanged != NIL
                Eval( ::FonChanged, ::getText() )
            ENDIF
            RETURN
        ENDIF
    ENDIF

    /* --- Selection: start anchor on first Shift+arrow if no selection --- */
    IF lShift .AND. ::FnSelAnchorRow = 0
        ::FnSelAnchorRow := ::FnCurRow
        ::FnSelAnchorCol := ::FnCurCol
    ELSEIF ! lShift .AND. ::FnSelAnchorRow > 0
        /* non-shift navigation clears selection */
        ::clearSelection()
    ENDIF

    SWITCH keyEvent:key

    /* --- Navigation --- */
    CASE K_UP
        IF ::FnCurRow > 1
            ::FnCurRow--
            ::FnCurCol := Min( ::FnCurCol, Len( ::FaLines[ ::FnCurRow ] ) + 1 )
        ENDIF
        EXIT
    CASE K_DOWN
        IF ::FnCurRow < nLineCount
            ::FnCurRow++
            ::FnCurCol := Min( ::FnCurCol, Len( ::FaLines[ ::FnCurRow ] ) + 1 )
        ENDIF
        EXIT
    CASE K_LEFT
        IF ::FnCurCol > 1
            ::FnCurCol--
        ELSEIF ::FnCurRow > 1
            ::FnCurRow--
            ::FnCurCol := Len( ::FaLines[ ::FnCurRow ] ) + 1
        ENDIF
        EXIT
    CASE K_RIGHT
        IF ::FnCurCol <= Len( ::FaLines[ ::FnCurRow ] )
            ::FnCurCol++
        ELSEIF ::FnCurRow < nLineCount
            ::FnCurRow++
            ::FnCurCol := 1
        ENDIF
        EXIT
    CASE K_HOME
        ::FnCurCol := 1
        EXIT
    CASE K_END
        ::FnCurCol := Len( ::FaLines[ ::FnCurRow ] ) + 1
        EXIT
    CASE K_PGUP
        ::FnCurRow := Max( 1, ::FnCurRow - ( MaxRow() + 1 ) )
        ::FnCurCol := Min( ::FnCurCol, Len( ::FaLines[ ::FnCurRow ] ) + 1 )
        EXIT
    CASE K_PGDN
        ::FnCurRow := Min( nLineCount, ::FnCurRow + ( MaxRow() + 1 ) )
        ::FnCurCol := Min( ::FnCurCol, Len( ::FaLines[ ::FnCurRow ] ) + 1 )
        EXIT
    CASE K_CTRL_HOME
        ::FnCurRow := 1
        ::FnCurCol := 1
        EXIT
    CASE K_CTRL_END
        ::FnCurRow := nLineCount
        ::FnCurCol := Len( ::FaLines[ ::FnCurRow ] ) + 1
        EXIT

    /* --- Editing --- */
    CASE K_ENTER
        IF ! ::FreadOnly
            IF ::hasSelection()
                ::deleteSelection()
            ENDIF
            cLine := ::FaLines[ ::FnCurRow ]
            ::FaLines[ ::FnCurRow ] := Left( cLine, ::FnCurCol - 1 )
            hb_aIns( ::FaLines, ::FnCurRow + 1, SubStr( cLine, ::FnCurCol ), .T. )
            ::FnCurRow++
            ::FnCurCol := 1
            lChanged := .T.
        ENDIF
        EXIT
    CASE K_BS
        IF ! ::FreadOnly
            IF ::hasSelection()
                ::deleteSelection()
                lChanged := .T.
                EXIT
            ENDIF
            IF ::FnCurCol > 1
                cLine := ::FaLines[ ::FnCurRow ]
                ::FaLines[ ::FnCurRow ] := Left( cLine, ::FnCurCol - 2 ) + SubStr( cLine, ::FnCurCol )
                ::FnCurCol--
                lChanged := .T.
            ELSEIF ::FnCurRow > 1
                /* merge with previous line */
                ::FnCurCol := Len( ::FaLines[ ::FnCurRow - 1 ] ) + 1
                ::FaLines[ ::FnCurRow - 1 ] += ::FaLines[ ::FnCurRow ]
                hb_aDel( ::FaLines, ::FnCurRow, .T. )
                ::FnCurRow--
                lChanged := .T.
            ENDIF
        ENDIF
        EXIT
    CASE K_DEL
        IF ! ::FreadOnly
            IF ::hasSelection()
                ::deleteSelection()
                lChanged := .T.
                EXIT
            ENDIF
            cLine := ::FaLines[ ::FnCurRow ]
            IF ::FnCurCol <= Len( cLine )
                ::FaLines[ ::FnCurRow ] := Left( cLine, ::FnCurCol - 1 ) + SubStr( cLine, ::FnCurCol + 1 )
                lChanged := .T.
            ELSEIF ::FnCurRow < Len( ::FaLines )
                /* merge with next line */
                ::FaLines[ ::FnCurRow ] += ::FaLines[ ::FnCurRow + 1 ]
                hb_aDel( ::FaLines, ::FnCurRow + 1, .T. )
                lChanged := .T.
            ENDIF
        ENDIF
        EXIT
    CASE K_CTRL_Y
        IF ! ::FreadOnly
            /* delete entire line */
            IF Len( ::FaLines ) > 1
                hb_aDel( ::FaLines, ::FnCurRow, .T. )
                IF ::FnCurRow > Len( ::FaLines )
                    ::FnCurRow := Len( ::FaLines )
                ENDIF
            ELSE
                ::FaLines[ 1 ] := ""
            ENDIF
            ::FnCurCol := Min( ::FnCurCol, Len( ::FaLines[ ::FnCurRow ] ) + 1 )
            lChanged := .T.
        ENDIF
        EXIT

    /* --- Clipboard (Ctrl+V / paste) --- */
    CASE K_CTRL_V
        IF ! ::FreadOnly
            IF ::hasSelection()
                ::deleteSelection()
            ENDIF
            cPaste := hb_gtInfo( HB_GTI_CLIPBOARDDATA )
            IF hb_isString( cPaste ) .AND. Len( cPaste ) > 0
                aPasteLines := hb_ATokens( cPaste, .T. )
                IF Len( aPasteLines ) = 1
                    /* single line paste: insert at cursor */
                    cLine := ::FaLines[ ::FnCurRow ]
                    ::FaLines[ ::FnCurRow ] := Left( cLine, ::FnCurCol - 1 ) + aPasteLines[ 1 ] + SubStr( cLine, ::FnCurCol )
                    ::FnCurCol += Len( aPasteLines[ 1 ] )
                ELSE
                    /* multi-line paste */
                    cLine := ::FaLines[ ::FnCurRow ]
                    ::FaLines[ ::FnCurRow ] := Left( cLine, ::FnCurCol - 1 ) + aPasteLines[ 1 ]
                    FOR i := 2 TO Len( aPasteLines ) - 1
                        hb_aIns( ::FaLines, ::FnCurRow + i - 1, aPasteLines[ i ], .T. )
                    NEXT
                    hb_aIns( ::FaLines, ::FnCurRow + Len( aPasteLines ) - 1, ;
                        ATail( aPasteLines ) + SubStr( cLine, ::FnCurCol ), .T. )
                    ::FnCurRow += Len( aPasteLines ) - 1
                    ::FnCurCol := Len( ATail( aPasteLines ) ) + 1
                ENDIF
                lChanged := .T.
            ENDIF
        ENDIF
        EXIT

    OTHERWISE
        /* printable character */
        IF ! ::FreadOnly
            cChar := hb_keyChar( keyEvent:key )
            IF Len( cChar ) = 1 .AND. Asc( cChar ) >= 32
                IF ::hasSelection()
                    ::deleteSelection()
                ENDIF
                cLine := ::FaLines[ ::FnCurRow ]
                ::FaLines[ ::FnCurRow ] := Left( cLine, ::FnCurCol - 1 ) + cChar + SubStr( cLine, ::FnCurCol )
                ::FnCurCol++
                lChanged := .T.
            ELSE
                RETURN
            ENDIF
        ELSE
            RETURN
        ENDIF
    ENDSWITCH

    keyEvent:accept()

    IF lChanged .AND. ::FonChanged != NIL
        Eval( ::FonChanged, ::getText() )
    ENDIF

    parent := ::parent()
    IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
        parent:repaintChild( self )
    ENDIF

RETURN

/** Handles mouse click to reposition cursor.
 * @param eventMouse HTMouseEvent
 */
METHOD PROCEDURE mouseEvent( eventMouse ) CLASS HTTextEdit

    LOCAL nClickRow, nClickCol, nLine
    LOCAL parent

    IF eventMouse:nKey = K_LBUTTONDOWN
        nClickRow := eventMouse:mouseRow
        nClickCol := eventMouse:mouseCol

        IF nClickRow >= 0 .AND. nClickCol >= 0
            nLine := ::FnTopRow + nClickRow
            IF nLine >= 1 .AND. nLine <= Len( ::FaLines )
                ::FnCurRow := nLine
                ::FnCurCol := Min( ::FnLeftCol + nClickCol, Len( ::FaLines[ ::FnCurRow ] ) + 1 )
                parent := ::parent()
                IF parent != NIL .AND. parent:isDerivedFrom( "HTWidget" )
                    parent:repaintChild( self )
                ENDIF
            ENDIF
        ENDIF
    ENDIF

RETURN
