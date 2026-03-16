/*
 * HTDialog - Modal dialog window
 *
 * Runs a nested event loop. exec() blocks until the dialog
 * is closed via accept() or reject(). Returns a result code.
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

    METHOD keyEvent( keyEvent )

ENDCLASS

/*
    new
*/
METHOD new( parent, cTitle ) CLASS HTDialog

    ::super:new( parent, HT_DIALOG )

    IF cTitle != NIL
        ::setWindowTitle( cTitle )
    ENDIF

    ::Fheight := 10
    ::Fwidth := 40

RETURN self

/*
    exec - modal event loop
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

    /* close the dialog window */
    IF ::FwindowId != NIL
        wClose( ::FwindowId )
        ::FwindowId := NIL
    ENDIF

    ::FisVisible := .F.

RETURN ::FresultCode

/*
    accept
*/
METHOD PROCEDURE accept() CLASS HTDialog
    ::FresultCode := HT_DIALOG_ACCEPTED
    ::Frunning := .F.
RETURN

/*
    reject
*/
METHOD PROCEDURE reject() CLASS HTDialog
    ::FresultCode := HT_DIALOG_REJECTED
    ::Frunning := .F.
RETURN

/*
    keyEvent
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
