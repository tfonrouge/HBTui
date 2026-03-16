/**
 * test_basic.prg - Basic instantiation and property tests for HBTui core classes.
 *
 * Tests: HTPoint, HTSize, HTEvent, HTKeyEvent, HTMouseEvent,
 *        HTFocusEvent, HTPaintEvent, HTCloseEvent
 *
 * Build: hbmk2 test_basic.prg hbmk.hbm
 */

#include "hbtui.ch"
#include "inkey.ch"

STATIC nPass := 0
STATIC nFail := 0

PROCEDURE Main()

    LOCAL nTotal

    /* value types */
    TestPoint()
    TestSize()

    /* event classes */
    TestEventBase()
    TestKeyEvent()
    TestMouseEvent()
    TestFocusEvent()
    TestPaintEvent()
    TestCloseEvent()

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

STATIC PROCEDURE TestPoint()

    LOCAL o
    LOCAL oNull

    /* constructor with values */
    o := HTPoint():new( 5, 10 )
    Assert( "HTPoint:x", o:x == 5 )
    Assert( "HTPoint:y", o:y == 10 )
    Assert( "HTPoint:IsNull false", ! o:IsNull() )

    /* setX / setY mutators */
    o:setX( 20 )
    o:setY( 30 )
    Assert( "HTPoint:setX", o:x == 20 )
    Assert( "HTPoint:setY", o:y == 30 )

    /* null point */
    oNull := HTPoint():new( 0, 0 )
    Assert( "HTPoint:IsNull true", oNull:IsNull() )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestSize()

    LOCAL o
    LOCAL oNull

    /* constructor with values */
    o := HTSize():new( 80, 25 )
    Assert( "HTSize:width", o:width == 80 )
    Assert( "HTSize:height", o:height == 25 )
    Assert( "HTSize:isNull false", ! o:isNull() )

    /* setWidth / setHeight mutators */
    o:setWidth( 120 )
    o:setHeight( 40 )
    Assert( "HTSize:setWidth", o:width == 120 )
    Assert( "HTSize:setHeight", o:height == 40 )

    /* null size */
    oNull := HTSize():new( 0, 0 )
    Assert( "HTSize:isNull true", oNull:isNull() )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestEventBase()

    LOCAL o

    o := HTEvent()
    Assert( "HTEvent:type init", o:type == HT_EVENT_TYPE_NULL )
    Assert( "HTEvent:isAccepted init", o:isAccepted )

    /* ignore / accept */
    o:ignore()
    Assert( "HTEvent:ignore", ! o:isAccepted )
    o:accept()
    Assert( "HTEvent:accept", o:isAccepted )

    /* setAccepted */
    o:setAccepted( .F. )
    Assert( "HTEvent:setAccepted(.F.)", ! o:isAccepted )
    o:setAccepted( .T. )
    Assert( "HTEvent:setAccepted(.T.)", o:isAccepted )

    /* widget is NIL by default */
    Assert( "HTEvent:widget init", o:widget == NIL )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestKeyEvent()

    LOCAL o

    o := HTKeyEvent():new( K_ENTER )
    Assert( "HTKeyEvent:type", o:type == HT_EVENT_TYPE_KEYBOARD )
    Assert( "HTKeyEvent:key", o:key == K_ENTER )
    Assert( "HTKeyEvent:isAccepted", o:isAccepted )
    Assert( "HTKeyEvent:timestamp not NIL", o:timestamp != NIL )

    /* text for a printable key */
    o := HTKeyEvent():new( Asc( "A" ) )
    Assert( "HTKeyEvent:text for 'A'", o:text == "A" )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestMouseEvent()

    LOCAL o

    o := HTMouseEvent():new( K_LBUTTONDOWN )
    Assert( "HTMouseEvent:type", o:type == HT_EVENT_TYPE_MOUSE )
    Assert( "HTMouseEvent:nKey", o:nKey == K_LBUTTONDOWN )
    Assert( "HTMouseEvent:isAccepted", o:isAccepted )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestFocusEvent()

    LOCAL oIn
    LOCAL oOut

    /* focus-in event */
    oIn := HTFocusEvent():new( HT_EVENT_TYPE_FOCUSIN )
    Assert( "HTFocusEvent:type focusin", oIn:type == HT_EVENT_TYPE_FOCUSIN )
    Assert( "HTFocusEvent:gotFocus", oIn:gotFocus )
    Assert( "HTFocusEvent:lostFocus false", ! oIn:lostFocus )

    /* focus-out event */
    oOut := HTFocusEvent():new( HT_EVENT_TYPE_FOCUSOUT )
    Assert( "HTFocusEvent:type focusout", oOut:type == HT_EVENT_TYPE_FOCUSOUT )
    Assert( "HTFocusEvent:gotFocus false", ! oOut:gotFocus )
    Assert( "HTFocusEvent:lostFocus", oOut:lostFocus )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestPaintEvent()

    LOCAL o

    o := HTPaintEvent():new()
    Assert( "HTPaintEvent:type", o:type == HT_EVENT_TYPE_PAINT )
    Assert( "HTPaintEvent:isAccepted", o:isAccepted )

RETURN

/*----------------------------------------------------------------*/

STATIC PROCEDURE TestCloseEvent()

    LOCAL o

    o := HTCloseEvent():new()
    Assert( "HTCloseEvent:type", o:type == HT_EVENT_TYPE_CLOSE )
    Assert( "HTCloseEvent:isAccepted", o:isAccepted )

RETURN
