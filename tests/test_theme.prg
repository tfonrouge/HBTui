/**
 * test_theme.prg - Tests for the HTTheme singleton color manager.
 *
 * Verifies: singleton behavior, all 50 color slots populated per theme,
 * loadDefault/loadDark/loadHighContrast/loadMono, invalid index fallback.
 *
 * Build: hbmk2 test_theme.prg hbmk.hbm
 */

#include "hbtui.ch"

STATIC nPass := 0
STATIC nFail := 0

PROCEDURE Main()

    LOCAL nTotal
    LOCAL oTheme

    /* force singleton initialization */
    oTheme := HTTheme()

    /* verify the singleton actually initialized */
    IF oTheme == NIL
        QOut( "FATAL: HTTheme() returned NIL" )
        ErrorLevel( 1 )
        RETURN
    ENDIF

    TestSingleton()
    TestDefaultTheme()
    TestDarkTheme()
    TestHighContrastTheme()
    TestMonoTheme()
    TestInvalidIndex()

    nTotal := nPass + nFail
    QOut( "" )
    QOut( "Results: " + hb_ntos( nPass ) + " passed, " + hb_ntos( nFail ) + " failed out of " + hb_ntos( nTotal ) )
    ErrorLevel( IIF( nFail > 0, 1, 0 ) )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE Assert( cName, lCond )

    IF lCond
        nPass++
    ELSE
        nFail++
        QOut( "FAIL: " + cName )
    ENDIF

RETURN

/*----------------------------------------------------------------*/

/** Verify singleton: two calls return same object */
STATIC PROCEDURE TestSingleton()

    LOCAL o1 := HTTheme()
    LOCAL o2 := HTTheme()

    Assert( "HTTheme singleton identity", o1 == o2 )
    Assert( "HTTheme not NIL", o1 != NIL )

RETURN

/*----------------------------------------------------------------*/

/** Helper: check that all HT_CLR_MAX slots are non-NIL strings */
STATIC PROCEDURE VerifyAllSlots( cThemeName )

    LOCAL oTheme := HTTheme()
    LOCAL i
    LOCAL cColor

    FOR i := 1 TO HT_CLR_MAX
        cColor := oTheme:getColor( i )
        Assert( cThemeName + " slot " + hb_ntos( i ) + " not NIL", cColor != NIL )
        Assert( cThemeName + " slot " + hb_ntos( i ) + " is string", hb_isString( cColor ) )
        Assert( cThemeName + " slot " + hb_ntos( i ) + " non-empty", Len( cColor ) > 0 )
    NEXT

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestDefaultTheme()

    LOCAL oTheme := HTTheme()

    oTheme:loadDefault()

    /* spot-check a few well-known values */
    Assert( "Default:WINDOW", oTheme:getColor( HT_CLR_WINDOW ) == "11/09" )
    Assert( "Default:DESKTOP", oTheme:getColor( HT_CLR_DESKTOP ) == "03/01" )
    Assert( "Default:BUTTON_NORMAL", oTheme:getColor( HT_CLR_BUTTON_NORMAL ) == "00/07" )
    Assert( "Default:STATUSBAR", oTheme:getColor( HT_CLR_STATUSBAR ) == "00/07" )

    /* all 50 slots populated */
    VerifyAllSlots( "Default" )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestDarkTheme()

    LOCAL oTheme := HTTheme()

    oTheme:loadDark()

    /* spot-check */
    Assert( "Dark:WINDOW", oTheme:getColor( HT_CLR_WINDOW ) == "15/00" )
    Assert( "Dark:DESKTOP", oTheme:getColor( HT_CLR_DESKTOP ) == "08/00" )
    Assert( "Dark:BUTTON_FOCUSED", oTheme:getColor( HT_CLR_BUTTON_FOCUSED ) == "14/01" )

    /* all 50 slots populated */
    VerifyAllSlots( "Dark" )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestHighContrastTheme()

    LOCAL oTheme := HTTheme()

    oTheme:loadHighContrast()

    /* spot-check */
    Assert( "HiContrast:WINDOW", oTheme:getColor( HT_CLR_WINDOW ) == "15/00" )
    Assert( "HiContrast:CHECK_FOCUSED", oTheme:getColor( HT_CLR_CHECK_FOCUSED ) == "00/15" )

    /* all 50 slots populated */
    VerifyAllSlots( "HighContrast" )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestMonoTheme()

    LOCAL oTheme := HTTheme()

    oTheme:loadMono()

    /* spot-check */
    Assert( "Mono:WINDOW", oTheme:getColor( HT_CLR_WINDOW ) == "07/00" )
    Assert( "Mono:LABEL", oTheme:getColor( HT_CLR_LABEL ) == "07/00" )
    Assert( "Mono:LIST_SELECTED", oTheme:getColor( HT_CLR_LIST_SELECTED ) == "00/07" )

    /* all 50 slots populated */
    VerifyAllSlots( "Mono" )

    /* restore default for any subsequent tests */
    oTheme:loadDefault()

RETURN

/*----------------------------------------------------------------*/

/** getColor() with invalid indices should return fallback "N/W" */
STATIC PROCEDURE TestInvalidIndex()

    LOCAL oTheme := HTTheme()

    Assert( "Invalid index 0", oTheme:getColor( 0 ) == "N/W" )
    Assert( "Invalid index -1", oTheme:getColor( -1 ) == "N/W" )
    Assert( "Invalid index 999", oTheme:getColor( 999 ) == "N/W" )
    Assert( "Invalid index HT_CLR_MAX+1", oTheme:getColor( HT_CLR_MAX + 1 ) == "N/W" )

RETURN
