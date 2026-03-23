/** @class HTMessageBox
 * Singleton factory for simple modal message dialogs (information, warning, question).
 * All methods block until the user dismisses the dialog.
 */

#include "hbtui.ch"
#include "inkey.ch"

#define HT_DIALOG_ACCEPTED  1
#define HT_DIALOG_REJECTED  0


SINGLETON CLASS HTMessageBox

PUBLIC:

    CONSTRUCTOR new()

    METHOD information( cTitle, cMessage )
    METHOD warning( cTitle, cMessage )
    METHOD question( cTitle, cMessage )
    METHOD showDialog( cTitle, cMessage, cColor, lQuestion )

ENDCLASS

/** Creates a new instance. */
METHOD new() CLASS HTMessageBox
RETURN self

/** Shows an informational message dialog with an OK button.
 * @param cTitle Dialog title
 * @param cMessage Message text
 * @return HT_DIALOG_ACCEPTED or HT_DIALOG_REJECTED
 */
METHOD FUNCTION information( cTitle, cMessage ) CLASS HTMessageBox
RETURN ::showDialog( cTitle, cMessage, HTTheme():getColor( HT_CLR_MSGBOX_INFO ), .F. )

/** Shows a warning message dialog with an OK button.
 * @param cTitle Dialog title
 * @param cMessage Message text
 * @return HT_DIALOG_ACCEPTED or HT_DIALOG_REJECTED
 */
METHOD FUNCTION warning( cTitle, cMessage ) CLASS HTMessageBox
RETURN ::showDialog( cTitle, cMessage, HTTheme():getColor( HT_CLR_MSGBOX_WARN ), .F. )

/** Shows a question dialog with OK and Cancel buttons.
 * @param cTitle Dialog title
 * @param cMessage Message text
 * @return HT_DIALOG_ACCEPTED or HT_DIALOG_REJECTED
 */
METHOD FUNCTION question( cTitle, cMessage ) CLASS HTMessageBox
RETURN ::showDialog( cTitle, cMessage, HTTheme():getColor( HT_CLR_MSGBOX_QUEST ), .T. )

/** Internal: creates and runs a modal message dialog.
 * @param cTitle Dialog title
 * @param cMessage Message text
 * @param cColor Color string for the dialog
 * @param lQuestion .T. to show OK+Cancel, .F. for OK only
 * @return HT_DIALOG_ACCEPTED or HT_DIALOG_REJECTED
 */
METHOD FUNCTION showDialog( cTitle, cMessage, cColor, lQuestion ) CLASS HTMessageBox

    LOCAL nMsgWidth, nWinWidth, nWinHeight
    LOCAL nTop, nLeft
    LOCAL nWinId
    LOCAL event, nResult
    LOCAL nBtnCol

    IF cTitle = NIL
        cTitle := ""
    ENDIF
    IF cMessage = NIL
        cMessage := ""
    ENDIF

    nMsgWidth  := Max( Len( cMessage ), Len( cTitle ) + 4 )
    nMsgWidth  := Max( nMsgWidth, IIF( lQuestion, 20, 10 ) )
    nWinWidth  := nMsgWidth + 4
    nWinHeight := 7

    /* center on screen */
    nTop  := ( MaxRow() - nWinHeight ) / 2
    nLeft := ( MaxCol() - nWinWidth ) / 2

    nWinId := wOpen( nTop, nLeft, nTop + nWinHeight - 1, nLeft + nWinWidth - 1, .T. )
    wSetShadow( 8 )
    wBox( NIL, cColor )
    wFormat()
    wFormat( 1, 1, 1, 1 )

    /* title */
    IF ! Empty( cTitle )
        DispOutAt( 0, 1, " " + cTitle + " ", cColor )
    ENDIF

    /* message */
    DispOutAt( 1, 1, PadR( cMessage, MaxCol() ), cColor )

    /* buttons */
    IF lQuestion
        nBtnCol := ( MaxCol() - 17 ) / 2
        DispOutAt( 3, nBtnCol, "[ OK ]", "15/01" )
        DispOutAt( 3, nBtnCol + 10, "[ Cancel ]", "00/07" )
    ELSE
        nBtnCol := ( MaxCol() - 6 ) / 2
        DispOutAt( 3, nBtnCol, "[ OK ]", "15/01" )
    ENDIF

    wFormat()

    nResult := HT_DIALOG_ACCEPTED

    /* modal loop using shared event polling */
    DO WHILE .T.
        event := HTEventLoop():poll( 0.05 )

        IF event = NIL
            LOOP
        ENDIF

        IF event:className() == "HTKEYEVENT"
            IF event:key = K_ENTER .OR. event:key = K_SPACE
                nResult := HT_DIALOG_ACCEPTED
                EXIT
            ELSEIF event:key = K_ESC
                nResult := HT_DIALOG_REJECTED
                EXIT
            ENDIF
        ELSEIF event:className() == "HTMOUSEEVENT" .AND. event:nKey = K_LBUTTONDOWN
            /* check if click landed on a button (row 3 of content area) */
            wSelect( nWinId, .F. )
            wFormat()
            wFormat( 1, 1, 1, 1 )
            IF mRow() = 3
                IF lQuestion
                    IF mCol() >= nBtnCol .AND. mCol() < nBtnCol + 6
                        nResult := HT_DIALOG_ACCEPTED
                        EXIT
                    ELSEIF mCol() >= nBtnCol + 10 .AND. mCol() < nBtnCol + 20
                        nResult := HT_DIALOG_REJECTED
                        EXIT
                    ENDIF
                ELSE
                    IF mCol() >= nBtnCol .AND. mCol() < nBtnCol + 6
                        nResult := HT_DIALOG_ACCEPTED
                        EXIT
                    ENDIF
                ENDIF
            ENDIF
            wFormat()
        ENDIF
    ENDDO

    wClose( nWinId )

RETURN nResult
