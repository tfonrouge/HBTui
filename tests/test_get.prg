/**
 * test_get.prg - Headless tests for HTGet (TGet-backed input widget).
 *
 * Tests property defaults, setup(), getValue/setValue, label/picture/width
 * calculations, and getDisplayValue() formatting.
 * Does not test keyboard editing or TGet rendering (those require a real GT).
 *
 * Build: hbmk2 test_get.prg hbmk.hbm
 */

#include "hbtui.ch"

STATIC nPass := 0
STATIC nFail := 0

PROCEDURE Main()

    LOCAL nTotal

    TestGetDefaults()
    TestGetSetup()
    TestGetValue()
    TestGetLabel()
    TestGetPicture()
    TestGetReadOnly()

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
        OutErr( "FAIL: " + cName + hb_eol() )
    ENDIF

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestGetDefaults()

    LOCAL o

    o := HTGet():new()
    Assert( "HTGet:label default empty",    o:label == "" )
    Assert( "HTGet:picture default empty",  o:picture == "" )
    Assert( "HTGet:readOnly default .F.",   ! o:readOnly )
    Assert( "HTGet:hide default .F.",       ! o:hide )
    Assert( "HTGet:helpLine default empty", o:helpLine == "" )
    Assert( "HTGet:labelWidth default 0",   o:labelWidth == 0 )
    Assert( "HTGet:valid default NIL",      o:valid == NIL )
    Assert( "HTGet:when default NIL",       o:when == NIL )
    Assert( "HTGet:onChange default NIL",   o:onChange == NIL )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestGetSetup()

    LOCAL o
    LOCAL cName := "Alice"
    LOCAL bVar  := {|x| IIF( x == NIL, cName, cName := x )}

    o := HTGet():new()
    o:setup( bVar, "Name", "", NIL, NIL, "Enter name", NIL, .F., .F., 30 )

    Assert( "HTGet:setup label",       o:label == "Name" )
    Assert( "HTGet:setup helpLine",    o:helpLine == "Enter name" )
    Assert( "HTGet:setup readOnly .F.", ! o:readOnly )

    /* label "Name" = 4 chars + 1 separator = labelWidth 5 */
    Assert( "HTGet:setup labelWidth",  o:labelWidth == 5 )

    /* inputWidth = total(30) - labelWidth(5) = 25 */
    Assert( "HTGet:setup inputWidth",  o:inputWidth == 25 )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestGetValue()

    LOCAL o
    LOCAL cCity := "Paris"
    LOCAL bVar  := {|x| IIF( x == NIL, cCity, cCity := x )}

    o := HTGet():new()
    o:setup( bVar, "", "", NIL, NIL, "", NIL, .F., .F., 20 )

    Assert( "HTGet:getValue initial",        o:getValue() == "Paris" )

    o:setValue( "London" )
    Assert( "HTGet:setValue updates var",    o:getValue() == "London" )
    Assert( "HTGet:local var updated",       cCity == "London" )

    o:setValue( "" )
    Assert( "HTGet:setValue empty string",   o:getValue() == "" )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestGetLabel()

    LOCAL o
    LOCAL cVal := "x"
    LOCAL bVar := {|x| IIF( x == NIL, cVal, cVal := x )}

    o := HTGet():new()
    o:setup( bVar, "City", "", NIL, NIL, "", NIL, .F., .F., 30 )

    /* "City" = 4 chars + 1 = 5 */
    Assert( "HTGet:setLabel initial",        o:label == "City" )
    Assert( "HTGet:labelWidth auto 5",       o:labelWidth == 5 )

    o:setLabel( "Zip" )
    /* "Zip" = 3 chars + 1 = 4 */
    Assert( "HTGet:setLabel updates label",  o:label == "Zip" )
    Assert( "HTGet:labelWidth recalc 4",     o:labelWidth == 4 )
    Assert( "HTGet:inputWidth recalc 26",    o:inputWidth == 26 )

    o:setLabel( "" )
    Assert( "HTGet:setLabel empty labelWidth 0",  o:labelWidth == 0 )
    Assert( "HTGet:setLabel empty inputWidth 30", o:inputWidth == 30 )

    /* manual override */
    o:setLabelWidth( 8 )
    Assert( "HTGet:setLabelWidth 8",         o:labelWidth == 8 )
    Assert( "HTGet:inputWidth after manual", o:inputWidth == 22 )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestGetPicture()

    LOCAL o
    LOCAL cVal := "hello"
    LOCAL bVar := {|x| IIF( x == NIL, cVal, cVal := x )}

    o := HTGet():new()
    o:setup( bVar, "", "", NIL, NIL, "", NIL, .F., .F., 20 )

    /* no picture: getDisplayValue returns raw value */
    Assert( "HTGet:getDisplayValue no picture", o:getDisplayValue() == "hello" )

    /* @! converts to uppercase */
    o:setPicture( "@!" )
    Assert( "HTGet:setPicture updates picture", o:picture == "@!" )
    Assert( "HTGet:getDisplayValue @!",         o:getDisplayValue() == "HELLO" )

    /* clear picture */
    o:setPicture( "" )
    Assert( "HTGet:getDisplayValue after clear pic", o:getDisplayValue() == "hello" )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestGetReadOnly()

    LOCAL o
    LOCAL cVal := "data"
    LOCAL bVar := {|x| IIF( x == NIL, cVal, cVal := x )}

    o := HTGet():new()
    o:setup( bVar, "", "", NIL, NIL, "", NIL, .F., .F., 20 )

    Assert( "HTGet:readOnly default .F.", ! o:readOnly )

    o:setReadOnly( .T. )
    Assert( "HTGet:setReadOnly .T.",      o:readOnly )

    o:setReadOnly( .F. )
    Assert( "HTGet:setReadOnly .F.",      ! o:readOnly )

RETURN
