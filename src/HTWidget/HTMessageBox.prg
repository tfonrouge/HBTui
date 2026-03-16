/*
 * HTMessageBox - Simple message dialog
 *
 * Static methods for common dialogs:
 *   HTMessageBox():information( cTitle, cMessage )
 *   HTMessageBox():warning( cTitle, cMessage )
 *   HTMessageBox():question( cTitle, cMessage ) → HT_DIALOG_ACCEPTED / HT_DIALOG_REJECTED
 */

#include "hbtui.ch"
#include "inkey.ch"

#define HT_DIALOG_ACCEPTED  1
#define HT_DIALOG_REJECTED  0

#define _MSG_COLOR_INFO   "15/01"
#define _MSG_COLOR_WARN   "14/04"
#define _MSG_COLOR_QUEST  "15/05"

SINGLETON CLASS HTMessageBox

PUBLIC:

    CONSTRUCTOR new()

    METHOD information( cTitle, cMessage )
    METHOD warning( cTitle, cMessage )
    METHOD question( cTitle, cMessage )

ENDCLASS

/*
    new
*/
METHOD new() CLASS HTMessageBox
RETURN self

/*
    information
*/
METHOD FUNCTION information( cTitle, cMessage ) CLASS HTMessageBox
RETURN ::showDialog( cTitle, cMessage, _MSG_COLOR_INFO, .F. )

/*
    warning
*/
METHOD FUNCTION warning( cTitle, cMessage ) CLASS HTMessageBox
RETURN ::showDialog( cTitle, cMessage, _MSG_COLOR_WARN, .F. )

/*
    question - shows OK and Cancel buttons, returns result code
*/
METHOD FUNCTION question( cTitle, cMessage ) CLASS HTMessageBox
RETURN ::showDialog( cTitle, cMessage, _MSG_COLOR_QUEST, .T. )

/*
    showDialog (internal)
*/
METHOD FUNCTION showDialog( cTitle, cMessage, cColor, lQuestion ) CLASS HTMessageBox

    LOCAL nMsgWidth, nMsgHeight, nWinWidth, nWinHeight
    LOCAL nTop, nLeft
    LOCAL nWinId
    LOCAL nKey, nResult
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

    /* simple modal key loop */
    DO WHILE .T.
        nKey := Inkey( 0 )
        IF nKey = K_ENTER .OR. nKey = K_SPACE
            nResult := HT_DIALOG_ACCEPTED
            EXIT
        ELSEIF nKey = K_ESC
            nResult := HT_DIALOG_REJECTED
            EXIT
        ENDIF
    ENDDO

    wClose( nWinId )

RETURN nResult
