/** @class HTDialog
 * Modal dialog window with a nested event loop.
 * exec() blocks until closed via accept() or reject(), returning a result code.
 * @extends HTWidget
 *
 * @example
 *   oDlg := HTDialog():new( oParent, "Confirm" )
 *   oDlg:resize( 20, 10 )
 *   /* add child widgets to oDlg... */
 *   IF oDlg:exec() = HT_DIALOG_ACCEPTED
 *      /* user pressed Enter/accepted */
 *   ENDIF
 *
 * @see HTMessageBox, HTMainWindow
 */

#include "hbtui.ch"
#include "inkey.ch"

#define HT_DIALOG_ACCEPTED  1
#define HT_DIALOG_REJECTED  0

CLASS HTDialog FROM HTWidget

PROTECTED:

    DATA FresultCode     INIT HT_DIALOG_REJECTED
    DATA Frunning        INIT .F.

PUBLIC:

    CONSTRUCTOR new( parent, cTitle )

    METHOD exec()
    METHOD accept()
    METHOD reject()
    METHOD resultCode()  INLINE ::FresultCode
    METHOD addButtonBar( ... )

    METHOD move( ... )
    METHOD resize( ... )
    METHOD keyEvent( keyEvent )

ENDCLASS

/** Creates a new modal dialog.
 * @param parent Parent widget
 * @param cTitle Optional window title
 */
METHOD new( parent, cTitle ) CLASS HTDialog

    ::super:new( parent, HT_DIALOG )

    IF cTitle != NIL
        ::setWindowTitle( cTitle )
    ENDIF

    ::Fheight := 10
    ::Fwidth := 40

RETURN self

/** Runs the modal event loop. Blocks until accept() or reject() is called.
 * @return HT_DIALOG_ACCEPTED or HT_DIALOG_REJECTED
 */
METHOD FUNCTION exec() CLASS HTDialog

    LOCAL nKey
    LOCAL event
    LOCAL aFocusable

    ::FisVisible := .T.
    ::Frunning := .T.

    /* paint the dialog */
    ::paintEvent( HTPaintEvent():new() )

    /* auto-focus first focusable child */
    IF ::FfocusWidget = NIL
        aFocusable := ::focusableChildren()
        IF Len( aFocusable ) > 0
            ::FfocusWidget := aFocusable[ 1 ]
        ENDIF
    ENDIF

    /* modal event loop */
    DO WHILE ::Frunning

        nKey := Inkey( 0.1 )

        IF nKey != 0
            IF nKey >= K_MINMOUSE .AND. nKey <= K_MAXMOUSE
                event := HTMouseEvent():new( nKey )
                event:setWidget( self )
                ::event( event )
            ELSE
                event := HTKeyEvent():new( nKey )
                event:setWidget( self )
                ::event( event )
            ENDIF
        ENDIF

    ENDDO

    /* close the dialog window and unregister from top-level windows */
    IF ::FwindowId != NIL
        HTApplication():removeTopLevelWindow( ::FwindowId )
        wClose( ::FwindowId )
        ::FwindowId := NIL
    ENDIF

    ::FisVisible := .F.

RETURN ::FresultCode

/** Closes the dialog with an accepted result code. */
METHOD PROCEDURE accept() CLASS HTDialog
    ::FresultCode := HT_DIALOG_ACCEPTED
    ::Frunning := .F.
RETURN

/** Closes the dialog with a rejected result code. */
METHOD PROCEDURE reject() CLASS HTDialog
    ::FresultCode := HT_DIALOG_REJECTED
    ::Frunning := .F.
RETURN

/** Adds a standard button bar at the bottom of the dialog.
 * With no arguments, creates OK + Cancel. Pass button labels as arguments.
 * First button triggers accept(), last button (if > 1) triggers reject().
 * @param ... Optional button labels (strings). Default: "OK", "Cancel"
 * @return Array of HTPushButton instances for customization
 */
METHOD FUNCTION addButtonBar( ... ) CLASS HTDialog

    LOCAL aLabels := {}
    LOCAL aButtons := {}
    LOCAL i, nBtnX, oBtn, nBtnWidth
    LOCAL nBarRow

    /* collect labels from varargs, or use defaults */
    IF pCount() = 0
        aLabels := { "OK", "Cancel" }
    ELSE
        FOR i := 1 TO pCount()
            IF hb_isString( hb_pValue( i ) )
                AAdd( aLabels, hb_pValue( i ) )
            ENDIF
        NEXT
    ENDIF

    IF Len( aLabels ) = 0
        RETURN aButtons
    ENDIF

    /* position: 2 rows from bottom of content area */
    nBarRow := ::Fheight - 4

    /* right-align buttons */
    nBtnX := ::Fwidth - 3
    FOR i := Len( aLabels ) TO 1 STEP -1
        nBtnWidth := Max( Len( aLabels[ i ] ) + 4, 8 )
        nBtnX -= nBtnWidth + 1
        oBtn := HTPushButton():new( aLabels[ i ], self )
        oBtn:setGeometry( Max( 1, nBtnX ), nBarRow, nBtnWidth, 1 )
        AAdd( aButtons, oBtn )
    NEXT

    /* wire first button to accept, last to reject (if more than one) */
    IF Len( aButtons ) >= 1
        aButtons[ 1 ]:onClicked := {|| ::accept() }
    ENDIF
    IF Len( aButtons ) >= 2
        ATail( aButtons ):onClicked := {|| ::reject() }
    ENDIF

RETURN aButtons

/** Synchronous move — sets position immediately (no event queuing).
 * Dialog needs geometry set before exec() calls paintEvent().
 * @param ... HTPoint or (x, y) numeric pair
 */
METHOD PROCEDURE move( ... ) CLASS HTDialog
    IF pCount() = 2 .AND. hb_isNumeric( hb_pValue( 1 ) ) .AND. hb_isNumeric( hb_pValue( 2 ) )
        ::Fx := hb_pValue( 1 )
        ::Fy := hb_pValue( 2 )
    ELSEIF pCount() = 1 .AND. hb_isObject( hb_pValue( 1 ) )
        ::Fx := hb_pValue( 1 ):x
        ::Fy := hb_pValue( 1 ):y
    ENDIF
RETURN

/** Synchronous resize — sets dimensions immediately (no event queuing).
 * @param ... HTSize or (width, height) numeric pair
 */
METHOD PROCEDURE resize( ... ) CLASS HTDialog
    IF pCount() = 2 .AND. hb_isNumeric( hb_pValue( 1 ) ) .AND. hb_isNumeric( hb_pValue( 2 ) )
        ::Fwidth  := hb_pValue( 1 )
        ::Fheight := hb_pValue( 2 )
    ELSEIF pCount() = 1 .AND. hb_isObject( hb_pValue( 1 ) )
        ::Fwidth  := hb_pValue( 1 ):width
        ::Fheight := hb_pValue( 1 ):height
    ENDIF
RETURN

/** Handles key events: ESC rejects the dialog, others delegate to parent.
 * @param keyEvent HTKeyEvent instance
 */
METHOD PROCEDURE keyEvent( keyEvent ) CLASS HTDialog

    /* ESC closes the dialog */
    IF keyEvent:key = K_ESC
        ::reject()
        keyEvent:accept()
        RETURN
    ENDIF

    /* delegate to parent class for Tab/focus/child dispatch */
    ::super:keyEvent( keyEvent )

RETURN
