/*
 * Harbour 3.2.0dev (r1412151448)
 * LLVM/Clang C 6.0 (clang-600.0.56) (64-bit)
 * Generated C source from "src/HBTui_Widget.prg"
 */

#include "hbvmpub.h"
#include "hbpcode.h"
#include "hbinit.h"
#include "hbxvm.h"


HB_FUNC( HBTUI_WIDGET );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( HBTUI_OBJECT );
HB_FUNC_STATIC( HBTUI_WIDGET_DISPLAYCHILDREN );
HB_FUNC_STATIC( HBTUI_WIDGET_DISPLAYLAYOUT );
HB_FUNC_STATIC( HBTUI_WIDGET_DRAWWINDOW );
HB_FUNC_STATIC( HBTUI_WIDGET_GETWID );
HB_FUNC_STATIC( HBTUI_WIDGET_SETWID );
HB_FUNC_STATIC( HBTUI_WIDGET_ADDEVENT );
HB_FUNC_STATIC( HBTUI_WIDGET_SETFOCUS );
HB_FUNC_STATIC( HBTUI_WIDGET_SHOW );
HB_FUNC_STATIC( HBTUI_WIDGET_CLOSEEVENT );
HB_FUNC_STATIC( HBTUI_WIDGET_FOCUSINEVENT );
HB_FUNC_STATIC( HBTUI_WIDGET_FOCUSOUTEVENT );
HB_FUNC_STATIC( HBTUI_WIDGET_KEYEVENT );
HB_FUNC_STATIC( HBTUI_WIDGET_MOUSEEVENT );
HB_FUNC_STATIC( HBTUI_WIDGET_MOVEEVENT );
HB_FUNC_STATIC( HBTUI_WIDGET_PAINTEVENT );
HB_FUNC_STATIC( HBTUI_WIDGET_SETLAYOUT );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( OUTSTD );
HB_FUNC_EXTERN( HBTUI_UI_UNREFCOUNTCOPY );
HB_FUNC_EXTERN( HBTUI_APP );
HB_FUNC_EXTERN( WCLOSE );
HB_FUNC_EXTERN( ALTD );
HB_FUNC_EXTERN( MAXROW );
HB_FUNC_EXTERN( MAXCOL );
HB_FUNC_EXTERN( WOPEN );
HB_FUNC_EXTERN( WBOX );
HB_FUNC_EXTERN( DEVPOS );
HB_FUNC_EXTERN( DEVOUT );
HB_FUNC_EXTERN( HBTUI_UI_SETFOCUSEDWINDOW );
HB_FUNC_EXTERN( WSELECT );
HB_FUNC_EXTERN( HBTUI_EVENTFOCUS );
HB_FUNC_EXTERN( HBTUI_EVENTCLOSE );
HB_FUNC_EXTERN( MLEFTDOWN );
HB_FUNC_EXTERN( MROW );
HB_FUNC_EXTERN( MCOL );
HB_FUNC_EXTERN( HBTUI_EVENTMOVE );
HB_FUNC_EXTERN( WMOVE );
HB_FUNC_EXTERN( HBTUI_UI_ADDMAINWIDGET );
HB_FUNC_EXTERN( HBTUI_EVENTPAINT );
HB_FUNC_EXTERN( __DBGENTRY );
HB_FUNC_INITSTATICS();
HB_FUNC_INITLINES();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_HBTUI_WIDGET )
{ "HBTUI_WIDGET", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_WIDGET )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "HBTUI_OBJECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBTUI_OBJECT )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBTUI_WIDGET_DISPLAYCHILDREN", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_WIDGET_DISPLAYCHILDREN )}, NULL },
{ "HBTUI_WIDGET_DISPLAYLAYOUT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_WIDGET_DISPLAYLAYOUT )}, NULL },
{ "HBTUI_WIDGET_DRAWWINDOW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_WIDGET_DRAWWINDOW )}, NULL },
{ "HBTUI_WIDGET_GETWID", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_WIDGET_GETWID )}, NULL },
{ "HBTUI_WIDGET_SETWID", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_WIDGET_SETWID )}, NULL },
{ "HBTUI_WIDGET_ADDEVENT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_WIDGET_ADDEVENT )}, NULL },
{ "HBTUI_WIDGET_SETFOCUS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_WIDGET_SETFOCUS )}, NULL },
{ "HBTUI_WIDGET_SHOW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_WIDGET_SHOW )}, NULL },
{ "HBTUI_WIDGET_CLOSEEVENT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_WIDGET_CLOSEEVENT )}, NULL },
{ "HBTUI_WIDGET_FOCUSINEVENT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_WIDGET_FOCUSINEVENT )}, NULL },
{ "HBTUI_WIDGET_FOCUSOUTEVENT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_WIDGET_FOCUSOUTEVENT )}, NULL },
{ "HBTUI_WIDGET_KEYEVENT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_WIDGET_KEYEVENT )}, NULL },
{ "HBTUI_WIDGET_MOUSEEVENT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_WIDGET_MOUSEEVENT )}, NULL },
{ "HBTUI_WIDGET_MOVEEVENT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_WIDGET_MOVEEVENT )}, NULL },
{ "HBTUI_WIDGET_PAINTEVENT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_WIDGET_PAINTEVENT )}, NULL },
{ "HBTUI_WIDGET_SETLAYOUT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_WIDGET_SETLAYOUT )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FCHARWIDGETCLOSE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FCHARWIDGETHIDE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FCHARWIDGETMAXIMIZE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_FHEIGHT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FHEIGHT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETHEIGHT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FLAYOUT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETLAYOUT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETWID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETWID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_FWIDTH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FWIDTH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETWIDTH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_FX", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FX", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETX", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_FY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OUTSTD", {HB_FS_PUBLIC}, {HB_FUNCNAME( OUTSTD )}, NULL },
{ "CLASSNAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_HBTOBJECT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBTUI_UI_UNREFCOUNTCOPY", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBTUI_UI_UNREFCOUNTCOPY )}, NULL },
{ "_EVENTSTACK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBTUI_APP", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBTUI_APP )}, NULL },
{ "WCLOSE", {HB_FS_PUBLIC}, {HB_FUNCNAME( WCLOSE )}, NULL },
{ "FWID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DISPLAYLAYOUT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FCHILDREN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ISDERIVEDFROM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "PAINTEVENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ALTD", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALTD )}, NULL },
{ "MAXROW", {HB_FS_PUBLIC}, {HB_FUNCNAME( MAXROW )}, NULL },
{ "MAXCOL", {HB_FS_PUBLIC}, {HB_FUNCNAME( MAXCOL )}, NULL },
{ "WOPEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( WOPEN )}, NULL },
{ "WBOX", {HB_FS_PUBLIC}, {HB_FUNCNAME( WBOX )}, NULL },
{ "DEVPOS", {HB_FS_PUBLIC}, {HB_FUNCNAME( DEVPOS )}, NULL },
{ "DEVOUT", {HB_FS_PUBLIC}, {HB_FUNCNAME( DEVOUT )}, NULL },
{ "CHARWIDGETCLOSE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CHARWIDGETHIDE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CHARWIDGETMAXIMIZE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBTUI_UI_SETFOCUSEDWINDOW", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBTUI_UI_SETFOCUSEDWINDOW )}, NULL },
{ "ISACCEPTED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "WSELECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( WSELECT )}, NULL },
{ "WID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DISPLAYCHILDREN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FPARENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "PARENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NKEY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_FWINSYSBTNCLOSE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MOUSEROW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MOUSECOL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FWINSYSBTNCLOSE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FWINSYSBTNHIDE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FWINSYSBTNMAXIMIZE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_FWINSYSACTMOVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FOCUSWINDOW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDEVENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBTUI_EVENTFOCUS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBTUI_EVENTFOCUS )}, NULL },
{ "_FMOVEORIGIN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBTUI_EVENTCLOSE", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBTUI_EVENTCLOSE )}, NULL },
{ "_FWINSYSBTNHIDE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_FWINSYSBTNMAXIMIZE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MLEFTDOWN", {HB_FS_PUBLIC}, {HB_FUNCNAME( MLEFTDOWN )}, NULL },
{ "FWINSYSACTMOVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FMOVEORIGIN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MROW", {HB_FS_PUBLIC}, {HB_FUNCNAME( MROW )}, NULL },
{ "MCOL", {HB_FS_PUBLIC}, {HB_FUNCNAME( MCOL )}, NULL },
{ "HBTUI_EVENTMOVE", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBTUI_EVENTMOVE )}, NULL },
{ "WMOVE", {HB_FS_PUBLIC}, {HB_FUNCNAME( WMOVE )}, NULL },
{ "MOUSEABSROW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MOUSEABSCOL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DRAWWINDOW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DRAWCONTROL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FOCUSOUTEVENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FOCUSINEVENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_FLAYOUT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_FWID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBTUI_UI_ADDMAINWIDGET", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBTUI_UI_ADDMAINWIDGET )}, NULL },
{ "HBTUI_EVENTPAINT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBTUI_EVENTPAINT )}, NULL },
{ "__DBGENTRY", {HB_FS_PUBLIC}, {HB_FUNCNAME( __DBGENTRY )}, NULL },
{ "(_INITSTATICS00001)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL },
{ "(_INITLINES)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITLINES}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_HBTUI_WIDGET, "src/HBTui_Widget.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_HBTUI_WIDGET
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_HBTUI_WIDGET )
   #include "hbiniseg.h"
#endif

HB_FUNC( HBTUI_WIDGET )
{
   HB_BOOL fValue;
   do {
	hb_xvmVFrame( 3, 0 );
	hb_xvmSFrame( symbols + 110 );
	hb_xvmModuleName( "src/HBTui_Widget.prg:HBTUI_WIDGET" );
	hb_xvmSetLine( 8 );
	hb_xvmStaticName( 0, 1, "S_OCLASS" );
	hb_xvmSetLine( 8 );
	hb_xvmLocalName( 1, "NSCOPE" );
	hb_xvmLocalName( 2, "OCLASS" );
	hb_xvmLocalName( 3, "OINSTANCE" );
	hb_xvmPushStatic( 1 );
	hb_xvmPushNil();
	if( hb_xvmExactlyEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00002;
	hb_xvmPushFuncSymbol( symbols + 1 );
	hb_xvmPushStaticByRef( 1 );
	if( hb_xvmFunction( 1 ) ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00002;
	hb_xvmSeqAlways();
	do {
	hb_xvmLocalSetInt( 1, 1 );
	hb_xvmPushSymbol( symbols + 2 );
	hb_xvmPushFuncSymbol( symbols + 3 );
	if( hb_xvmFunction( 0 ) ) break;
	hb_xvmPushStringConst( "HBTui_Widget", 12 );
	hb_xvmPushSymbol( symbols + 4 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushSymbol( symbols + 0 );
	if( hb_xvmSend( 3 ) ) break;
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 9 );
	hb_xvmLocalSetInt( 1, 2 );
	hb_xvmSetLine( 11 );
	hb_xvmPushSymbol( symbols + 5 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushNil();
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	hb_xvmPushStringConst( "FWid", 4 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 12 );
	hb_xvmPushSymbol( symbols + 5 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushLogical( HB_FALSE );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	hb_xvmPushStringConst( "FWinSysActMove", 14 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 13 );
	hb_xvmPushSymbol( symbols + 5 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushLogical( HB_FALSE );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	hb_xvmPushStringConst( "FWinSysBtnClose", 15 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 14 );
	hb_xvmPushSymbol( symbols + 5 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushLogical( HB_FALSE );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	hb_xvmPushStringConst( "FWinSysBtnHide", 14 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 15 );
	hb_xvmPushSymbol( symbols + 5 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushLogical( HB_FALSE );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	hb_xvmPushStringConst( "FWinSysBtnMaximize", 18 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 16 );
	hb_xvmPushSymbol( symbols + 5 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushNil();
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	hb_xvmPushStringConst( "FMoveOrigin", 11 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 18 );
	hb_xvmPushSymbol( symbols + 6 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "DisplayChildren", 15 );
	hb_xvmPushSymbol( symbols + 7 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 19 );
	hb_xvmPushSymbol( symbols + 6 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "displayLayout", 13 );
	hb_xvmPushSymbol( symbols + 8 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 20 );
	hb_xvmPushSymbol( symbols + 6 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "DrawWindow", 10 );
	hb_xvmPushSymbol( symbols + 9 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 21 );
	hb_xvmPushSymbol( symbols + 6 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "GetWId", 6 );
	hb_xvmPushSymbol( symbols + 10 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 22 );
	hb_xvmPushSymbol( symbols + 6 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "SetWId", 6 );
	hb_xvmPushSymbol( symbols + 11 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 24 );
	hb_xvmLocalSetInt( 1, 1 );
	hb_xvmSetLine( 26 );
	hb_xvmPushSymbol( symbols + 6 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "AddEvent", 8 );
	hb_xvmPushSymbol( symbols + 12 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 27 );
	hb_xvmPushSymbol( symbols + 6 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "SetFocus", 8 );
	hb_xvmPushSymbol( symbols + 13 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 28 );
	hb_xvmPushSymbol( symbols + 6 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "Show", 4 );
	hb_xvmPushSymbol( symbols + 14 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 30 );
	hb_xvmPushSymbol( symbols + 6 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "CloseEvent", 10 );
	hb_xvmPushSymbol( symbols + 15 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 31 );
	hb_xvmPushSymbol( symbols + 6 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "FocusInEvent", 12 );
	hb_xvmPushSymbol( symbols + 16 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 32 );
	hb_xvmPushSymbol( symbols + 6 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "FocusOutEvent", 13 );
	hb_xvmPushSymbol( symbols + 17 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 33 );
	hb_xvmPushSymbol( symbols + 6 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "KeyEvent", 8 );
	hb_xvmPushSymbol( symbols + 18 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 34 );
	hb_xvmPushSymbol( symbols + 6 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "MouseEvent", 10 );
	hb_xvmPushSymbol( symbols + 19 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 35 );
	hb_xvmPushSymbol( symbols + 6 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "MoveEvent", 9 );
	hb_xvmPushSymbol( symbols + 20 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 36 );
	hb_xvmPushSymbol( symbols + 6 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "PaintEvent", 10 );
	hb_xvmPushSymbol( symbols + 21 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 38 );
	hb_xvmPushSymbol( symbols + 6 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "setLayout", 9 );
	hb_xvmPushSymbol( symbols + 22 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 40 );
	hb_xvmPushSymbol( symbols + 5 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushStringConst( "\xFE", 1 );
	hb_xvmPushInteger( 2 );
	hb_xvmPushStringConst( "FcharWidgetClose", 16 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "charWidgetClose", 15 );
	{
		static const HB_BYTE codeblock[ 55 ] = {
			1, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 87, 
			105, 100, 103, 101, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			87, 73, 68, 71, 69, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 48, 
			24, 0, 95, 1, 112, 0, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 41 );
	hb_xvmPushSymbol( symbols + 5 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushStringConst( "\x19", 1 );
	hb_xvmPushInteger( 2 );
	hb_xvmPushStringConst( "FcharWidgetHide", 15 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "charWidgetHide", 14 );
	{
		static const HB_BYTE codeblock[ 55 ] = {
			1, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 87, 
			105, 100, 103, 101, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			87, 73, 68, 71, 69, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 48, 
			25, 0, 95, 1, 112, 0, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 42 );
	hb_xvmPushSymbol( symbols + 5 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushStringConst( "\x12", 1 );
	hb_xvmPushInteger( 2 );
	hb_xvmPushStringConst( "FcharWidgetMaximize", 19 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "charWidgetMaximize", 18 );
	{
		static const HB_BYTE codeblock[ 55 ] = {
			1, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 87, 
			105, 100, 103, 101, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			87, 73, 68, 71, 69, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 48, 
			26, 0, 95, 1, 112, 0, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 43 );
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "Setheight", 9 );
	{
		static const HB_BYTE codeblock[ 66 ] = {
			2, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 87, 
			105, 100, 103, 101, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			87, 73, 68, 71, 69, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 37, 
			2, 0, 86, 65, 76, 85, 69, 0, 48, 27, 0, 95, 1, 95, 2, 112, 
			1, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushInteger( 2 );
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 43 );
	hb_xvmPushSymbol( symbols + 5 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushNil();
	hb_xvmPushInteger( 2 );
	hb_xvmPushStringConst( "Fheight", 7 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "height", 6 );
	{
		static const HB_BYTE codeblock[ 55 ] = {
			1, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 87, 
			105, 100, 103, 101, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			87, 73, 68, 71, 69, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 48, 
			28, 0, 95, 1, 112, 0, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 43 );
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "_height", 7 );
	{
		static const HB_BYTE codeblock[ 68 ] = {
			2, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 87, 
			105, 100, 103, 101, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			87, 73, 68, 71, 69, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 37, 
			2, 0, 88, 78, 69, 87, 86, 65, 76, 0, 48, 29, 0, 95, 1, 95, 
			2, 112, 1, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 44 );
	hb_xvmPushSymbol( symbols + 5 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushNil();
	hb_xvmPushInteger( 2 );
	hb_xvmPushStringConst( "Flayout", 7 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "layout", 6 );
	{
		static const HB_BYTE codeblock[ 55 ] = {
			1, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 87, 
			105, 100, 103, 101, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			87, 73, 68, 71, 69, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 48, 
			30, 0, 95, 1, 112, 0, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 44 );
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "_layout", 7 );
	{
		static const HB_BYTE codeblock[ 68 ] = {
			2, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 87, 
			105, 100, 103, 101, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			87, 73, 68, 71, 69, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 37, 
			2, 0, 88, 78, 69, 87, 86, 65, 76, 0, 48, 31, 0, 95, 1, 95, 
			2, 112, 1, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 45 );
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "WId", 3 );
	{
		static const HB_BYTE codeblock[ 55 ] = {
			1, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 87, 
			105, 100, 103, 101, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			87, 73, 68, 71, 69, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 48, 
			32, 0, 95, 1, 112, 0, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 45 );
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "_WId", 4 );
	{
		static const HB_BYTE codeblock[ 68 ] = {
			2, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 87, 
			105, 100, 103, 101, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			87, 73, 68, 71, 69, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 37, 
			2, 0, 88, 78, 69, 87, 86, 65, 76, 0, 48, 33, 0, 95, 1, 95, 
			2, 112, 1, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 46 );
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "Setwidth", 8 );
	{
		static const HB_BYTE codeblock[ 66 ] = {
			2, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 87, 
			105, 100, 103, 101, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			87, 73, 68, 71, 69, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 37, 
			2, 0, 86, 65, 76, 85, 69, 0, 48, 34, 0, 95, 1, 95, 2, 112, 
			1, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushInteger( 2 );
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 46 );
	hb_xvmPushSymbol( symbols + 5 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushNil();
	hb_xvmPushInteger( 2 );
	hb_xvmPushStringConst( "Fwidth", 6 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "width", 5 );
	{
		static const HB_BYTE codeblock[ 55 ] = {
			1, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 87, 
			105, 100, 103, 101, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			87, 73, 68, 71, 69, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 48, 
			35, 0, 95, 1, 112, 0, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 46 );
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "_width", 6 );
	{
		static const HB_BYTE codeblock[ 68 ] = {
			2, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 87, 
			105, 100, 103, 101, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			87, 73, 68, 71, 69, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 37, 
			2, 0, 88, 78, 69, 87, 86, 65, 76, 0, 48, 36, 0, 95, 1, 95, 
			2, 112, 1, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 47 );
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "Setx", 4 );
	{
		static const HB_BYTE codeblock[ 66 ] = {
			2, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 87, 
			105, 100, 103, 101, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			87, 73, 68, 71, 69, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 37, 
			2, 0, 86, 65, 76, 85, 69, 0, 48, 37, 0, 95, 1, 95, 2, 112, 
			1, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushInteger( 2 );
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 47 );
	hb_xvmPushSymbol( symbols + 5 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushNil();
	hb_xvmPushInteger( 2 );
	hb_xvmPushStringConst( "Fx", 2 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "x", 1 );
	{
		static const HB_BYTE codeblock[ 55 ] = {
			1, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 87, 
			105, 100, 103, 101, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			87, 73, 68, 71, 69, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 48, 
			38, 0, 95, 1, 112, 0, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 47 );
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "_x", 2 );
	{
		static const HB_BYTE codeblock[ 68 ] = {
			2, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 87, 
			105, 100, 103, 101, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			87, 73, 68, 71, 69, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 37, 
			2, 0, 88, 78, 69, 87, 86, 65, 76, 0, 48, 39, 0, 95, 1, 95, 
			2, 112, 1, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 48 );
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "Sety", 4 );
	{
		static const HB_BYTE codeblock[ 66 ] = {
			2, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 87, 
			105, 100, 103, 101, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			87, 73, 68, 71, 69, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 37, 
			2, 0, 86, 65, 76, 85, 69, 0, 48, 40, 0, 95, 1, 95, 2, 112, 
			1, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushInteger( 2 );
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 48 );
	hb_xvmPushSymbol( symbols + 5 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushNil();
	hb_xvmPushInteger( 2 );
	hb_xvmPushStringConst( "Fy", 2 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "y", 1 );
	{
		static const HB_BYTE codeblock[ 55 ] = {
			1, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 87, 
			105, 100, 103, 101, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			87, 73, 68, 71, 69, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 48, 
			41, 0, 95, 1, 112, 0, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 48 );
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "_y", 2 );
	{
		static const HB_BYTE codeblock[ 68 ] = {
			2, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 87, 
			105, 100, 103, 101, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			87, 73, 68, 71, 69, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 37, 
			2, 0, 88, 78, 69, 87, 86, 65, 76, 0, 48, 42, 0, 95, 1, 95, 
			2, 112, 1, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 50 );
	hb_xvmPushSymbol( symbols + 43 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_stackPop();
	} while( 0 );
	if( hb_xvmAlwaysBegin() ) break;
	do {
	hb_xvmPushFuncSymbol( symbols + 44 );
	hb_xvmPushStaticByRef( 1 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmDo( 2 ) ) break;
	} while( 0 );
	if( hb_xvmAlwaysEnd() ) break;
	hb_xvmPushSymbol( symbols + 45 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPopLocal( 3 );
	hb_xvmPushFuncSymbol( symbols + 46 );
	hb_xvmPushLocal( 3 );
	hb_xvmPushStringConst( "InitClass", 9 );
	if( hb_xvmFunction( 2 ) ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmPushSymbol( symbols + 47 );
	hb_xvmPushLocal( 3 );
	hb_xvmPushVParams();
	if( hb_xvmMacroSend( 1 ) ) break;
	hb_stackPop();
lab00001: ;
	hb_xvmPushLocal( 3 );
	hb_xvmRetValue();
	/* *** END PROC *** */
	break;
lab00002: ;
	hb_xvmPushSymbol( symbols + 45 );
	hb_xvmPushStatic( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmRetValue();
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_WIDGET_ADDEVENT )
{
   do {
	hb_xvmFrame( 1, 1 );
	hb_xvmModuleName( "src/HBTui_Widget.prg:HBTUI_WIDGET_ADDEVENT" );
	hb_xvmLocalName( 1, "EVENT" );
	hb_xvmSetLine( 55 );
	hb_xvmLocalName( 2, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 56 );
	hb_xvmPushFuncSymbol( symbols + 48 );
	hb_xvmPushStringConst( "on AddEvent: ", 13 );
	hb_xvmPushSymbol( symbols + 49 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmPlus() ) break;
	hb_xvmPushStringConst( "\x0A", 1 );
	if( hb_xvmPlus() ) break;
	if( hb_xvmDo( 1 ) ) break;
	hb_xvmSetLine( 57 );
	hb_xvmPushSymbol( symbols + 50 );
	hb_xvmPushLocal( 1 );
	hb_xvmPushFuncSymbol( symbols + 51 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmFunction( 1 ) ) break;
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 58 );
	hb_xvmPushSymbol( symbols + 52 );
	hb_xvmPushFuncSymbol( symbols + 53 );
	if( hb_xvmFunction( 0 ) ) break;
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 59 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_WIDGET_CLOSEEVENT )
{
   do {
	hb_xvmFrame( 1, 1 );
	hb_xvmModuleName( "src/HBTui_Widget.prg:HBTUI_WIDGET_CLOSEEVENT" );
	hb_xvmLocalName( 1, "CLOSEEVENT" );
	hb_xvmSetLine( 64 );
	hb_xvmLocalName( 2, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 66 );
	hb_xvmPushFuncSymbol( symbols + 54 );
	hb_xvmPushSymbol( symbols + 55 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmDo( 1 ) ) break;
	hb_xvmSetLine( 67 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_WIDGET_DISPLAYCHILDREN )
{
   HB_BOOL fValue;
   do {
	hb_xvmFrame( 2, 0 );
	hb_xvmModuleName( "src/HBTui_Widget.prg:HBTUI_WIDGET_DISPLAYCHILDREN" );
	hb_xvmSetLine( 72 );
	hb_xvmLocalName( 1, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 1 );
	hb_xvmSetLine( 73 );
	hb_xvmLocalName( 2, "CHILD" );
	hb_xvmSetLine( 75 );
	hb_xvmPushSymbol( symbols + 30 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushNil();
	if( hb_xvmNotEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmSetLine( 76 );
	hb_xvmPushSymbol( symbols + 56 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_stackPop();
	goto lab00005;
lab00001: ;
	hb_xvmSetLine( 78 );
	hb_xvmPushSymbol( symbols + 57 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushLocalByRef( 2 );
	if( hb_xvmEnumStart( 1, 1 ) ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00004;
lab00002: ;
	hb_xvmSetLine( 79 );
	hb_xvmPushSymbol( symbols + 58 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "HBTui_Widget", 12 );
	if( hb_xvmSend( 1 ) ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00003;
	hb_xvmSetLine( 80 );
	hb_xvmPushSymbol( symbols + 59 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_stackPop();
lab00003: ;
	hb_xvmSetLine( 82 );
	if( hb_xvmEnumNext() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( fValue )
		goto lab00002;
lab00004: ;
	hb_xvmEnumEnd();
lab00005: ;
	hb_xvmSetLine( 85 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_WIDGET_DISPLAYLAYOUT )
{
   HB_BOOL fValue;
   do {
	hb_xvmFrame( 2, 0 );
	hb_xvmModuleName( "src/HBTui_Widget.prg:HBTUI_WIDGET_DISPLAYLAYOUT" );
	hb_xvmSetLine( 90 );
	hb_xvmLocalName( 1, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 1 );
	hb_xvmSetLine( 91 );
	hb_xvmLocalName( 2, "ITM" );
	hb_xvmSetLine( 93 );
	hb_xvmPushFuncSymbol( symbols + 60 );
	if( hb_xvmDo( 0 ) ) break;
	hb_xvmSetLine( 94 );
	hb_xvmPushSymbol( symbols + 30 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushLocalByRef( 2 );
	if( hb_xvmEnumStart( 1, 1 ) ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00002;
lab00001: ;
	hb_xvmSetLine( 95 );
	if( hb_xvmEnumNext() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( fValue )
		goto lab00001;
lab00002: ;
	hb_xvmEnumEnd();
	hb_xvmSetLine( 97 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_WIDGET_DRAWWINDOW )
{
   HB_BOOL fValue;
   do {
	hb_xvmFrame( 1, 0 );
	hb_xvmModuleName( "src/HBTui_Widget.prg:HBTUI_WIDGET_DRAWWINDOW" );
	hb_xvmSetLine( 102 );
	hb_xvmLocalName( 1, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 1 );
	hb_xvmSetLine( 103 );
	hb_xvmPushSymbol( symbols + 55 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushNil();
	if( hb_xvmEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00003;
	hb_xvmSetLine( 104 );
	hb_xvmPushSymbol( symbols + 27 );
	hb_xvmPushLocal( 1 );
	hb_xvmPushInteger( 10 );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 105 );
	hb_xvmPushSymbol( symbols + 34 );
	hb_xvmPushLocal( 1 );
	hb_xvmPushInteger( 20 );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 106 );
	hb_xvmPushSymbol( symbols + 38 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushNil();
	if( hb_xvmEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmSetLine( 107 );
	hb_xvmPushSymbol( symbols + 37 );
	hb_xvmPushLocal( 1 );
	hb_xvmPushFuncSymbol( symbols + 61 );
	if( hb_xvmFunction( 0 ) ) break;
	if( hb_xvmDivideByInt( 2 ) ) break;
	hb_xvmPushSymbol( symbols + 28 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmDivideByInt( 2 ) ) break;
	if( hb_xvmMinus() ) break;
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
lab00001: ;
	hb_xvmSetLine( 109 );
	hb_xvmPushSymbol( symbols + 41 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushNil();
	if( hb_xvmEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00002;
	hb_xvmSetLine( 110 );
	hb_xvmPushSymbol( symbols + 40 );
	hb_xvmPushLocal( 1 );
	hb_xvmPushFuncSymbol( symbols + 62 );
	if( hb_xvmFunction( 0 ) ) break;
	if( hb_xvmDivideByInt( 2 ) ) break;
	hb_xvmPushSymbol( symbols + 35 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmDivideByInt( 2 ) ) break;
	if( hb_xvmMinus() ) break;
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
lab00002: ;
	hb_xvmSetLine( 112 );
	hb_xvmPushSymbol( symbols + 33 );
	hb_xvmPushLocal( 1 );
	hb_xvmPushFuncSymbol( symbols + 63 );
	hb_xvmPushSymbol( symbols + 38 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushSymbol( symbols + 41 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushSymbol( symbols + 38 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushSymbol( symbols + 28 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmPlus() ) break;
	hb_xvmPushSymbol( symbols + 41 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushSymbol( symbols + 35 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmPlus() ) break;
	hb_xvmPushLogical( HB_TRUE );
	if( hb_xvmFunction( 5 ) ) break;
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 113 );
	hb_xvmPushFuncSymbol( symbols + 64 );
	if( hb_xvmDo( 0 ) ) break;
	hb_xvmSetLine( 115 );
	hb_xvmPushFuncSymbol( symbols + 65 );
	hb_xvmPushInteger( -1 );
	hb_xvmPushInteger( 0 );
	if( hb_xvmDo( 2 ) ) break;
	hb_xvmPushFuncSymbol( symbols + 66 );
	hb_xvmPushSymbol( symbols + 67 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushSymbol( symbols + 68 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmPlus() ) break;
	hb_xvmPushSymbol( symbols + 69 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmPlus() ) break;
	if( hb_xvmDo( 1 ) ) break;
	hb_xvmSetLine( 116 );
	hb_xvmPushFuncSymbol( symbols + 70 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmDo( 1 ) ) break;
lab00003: ;
	hb_xvmSetLine( 118 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_WIDGET_FOCUSINEVENT )
{
   HB_BOOL fValue;
   do {
	hb_xvmFrame( 1, 1 );
	hb_xvmModuleName( "src/HBTui_Widget.prg:HBTUI_WIDGET_FOCUSINEVENT" );
	hb_xvmLocalName( 1, "EVENTFOCUS" );
	hb_xvmSetLine( 123 );
	hb_xvmLocalName( 2, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 124 );
	hb_xvmPushSymbol( symbols + 71 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmSetLine( 125 );
	hb_xvmPushFuncSymbol( symbols + 72 );
	hb_xvmPushSymbol( symbols + 73 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmDo( 1 ) ) break;
	hb_xvmSetLine( 126 );
	hb_xvmPushFuncSymbol( symbols + 70 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmDo( 1 ) ) break;
	hb_xvmSetLine( 127 );
	hb_xvmPushSymbol( symbols + 74 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_stackPop();
lab00001: ;
	hb_xvmSetLine( 129 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_WIDGET_FOCUSOUTEVENT )
{
   do {
	hb_xvmFrame( 1, 1 );
	hb_xvmModuleName( "src/HBTui_Widget.prg:HBTUI_WIDGET_FOCUSOUTEVENT" );
	hb_xvmLocalName( 1, "EVENTFOCUS" );
	hb_xvmSetLine( 134 );
	hb_xvmLocalName( 2, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 135 );
	hb_xvmPushSymbol( symbols + 71 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 138 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_WIDGET_GETWID )
{
   HB_BOOL fValue;
   do {
	hb_xvmFrame( 1, 0 );
	hb_xvmModuleName( "src/HBTui_Widget.prg:HBTUI_WIDGET_GETWID" );
	hb_xvmSetLine( 143 );
	hb_xvmLocalName( 1, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 1 );
	hb_xvmSetLine( 144 );
	hb_xvmPushSymbol( symbols + 55 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushNil();
	if( hb_xvmEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmPushSymbol( symbols + 75 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushNil();
	if( hb_xvmNotEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmSetLine( 145 );
	hb_xvmPushSymbol( symbols + 73 );
	hb_xvmPushSymbol( symbols + 76 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmRetValue();
	/* *** END PROC *** */
	break;
lab00001: ;
	hb_xvmSetLine( 147 );
	hb_xvmPushSymbol( symbols + 55 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmRetValue();
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_WIDGET_KEYEVENT )
{
   do {
	hb_xvmFrame( 1, 1 );
	hb_xvmModuleName( "src/HBTui_Widget.prg:HBTUI_WIDGET_KEYEVENT" );
	hb_xvmLocalName( 1, "KEYEVENT" );
	hb_xvmSetLine( 152 );
	hb_xvmLocalName( 2, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 154 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_WIDGET_MOUSEEVENT )
{
   HB_BOOL fValue;
   do {
	hb_xvmFrame( 1, 1 );
	hb_xvmModuleName( "src/HBTui_Widget.prg:HBTUI_WIDGET_MOUSEEVENT" );
	hb_xvmLocalName( 1, "EVENTMOUSE" );
	hb_xvmSetLine( 159 );
	hb_xvmLocalName( 2, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 161 );
	hb_xvmPushSymbol( symbols + 77 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmEqualIntIs( 1002, &fValue ) ) break;
	if( !fValue )
		goto lab00004;
	hb_xvmSetLine( 163 );
	hb_xvmPushSymbol( symbols + 78 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushSymbol( symbols + 79 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmEqualInt( -1 ) ) break;
	hb_xvmDuplicate();
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_stackPop();
	hb_xvmPushSymbol( symbols + 80 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmEqualInt( 0 ) ) break;
lab00001: ;
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 165 );
	hb_xvmPushSymbol( symbols + 81 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( fValue )
		goto lab00002;
	hb_xvmPushSymbol( symbols + 82 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( fValue )
		goto lab00002;
	hb_xvmPushSymbol( symbols + 83 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( fValue )
		goto lab00002;
	hb_xvmPushSymbol( symbols + 79 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmEqualIntIs( -1, &fValue ) ) break;
	if( !fValue )
		goto lab00002;
	hb_xvmSetLine( 166 );
	hb_xvmPushSymbol( symbols + 84 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushLogical( HB_TRUE );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
lab00002: ;
	hb_xvmSetLine( 169 );
	hb_xvmPushSymbol( symbols + 85 );
	hb_xvmPushFuncSymbol( symbols + 53 );
	if( hb_xvmFunction( 0 ) ) break;
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushNil();
	if( hb_xvmEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( fValue )
		goto lab00003;
	hb_xvmPushSymbol( symbols + 73 );
	hb_xvmPushSymbol( symbols + 85 );
	hb_xvmPushFuncSymbol( symbols + 53 );
	if( hb_xvmFunction( 0 ) ) break;
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushSymbol( symbols + 73 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmNotEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00004;
lab00003: ;
	hb_xvmSetLine( 170 );
	hb_xvmPushSymbol( symbols + 86 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushSymbol( symbols + 2 );
	hb_xvmPushFuncSymbol( symbols + 87 );
	if( hb_xvmFunction( 0 ) ) break;
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
lab00004: ;
	hb_xvmSetLine( 175 );
	hb_xvmPushSymbol( symbols + 77 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmEqualIntIs( 1003, &fValue ) ) break;
	if( !fValue )
		goto lab00006;
	hb_xvmSetLine( 177 );
	hb_xvmPushSymbol( symbols + 88 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 180 );
	hb_xvmPushSymbol( symbols + 79 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmEqualIntIs( -1, &fValue ) ) break;
	if( !fValue )
		goto lab00005;
	hb_xvmPushSymbol( symbols + 80 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmEqualIntIs( 0, &fValue ) ) break;
	if( !fValue )
		goto lab00005;
	hb_xvmPushSymbol( symbols + 81 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00005;
	hb_xvmSetLine( 181 );
	hb_xvmPushSymbol( symbols + 86 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushSymbol( symbols + 2 );
	hb_xvmPushFuncSymbol( symbols + 89 );
	if( hb_xvmFunction( 0 ) ) break;
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
lab00005: ;
	hb_xvmSetLine( 184 );
	hb_xvmPushSymbol( symbols + 84 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 185 );
	hb_xvmPushSymbol( symbols + 78 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 186 );
	hb_xvmPushSymbol( symbols + 90 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 187 );
	hb_xvmPushSymbol( symbols + 91 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	goto lab00008;
lab00006: ;
	hb_xvmSetLine( 189 );
	hb_xvmPushFuncSymbol( symbols + 92 );
	if( hb_xvmFunction( 0 ) ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00008;
	hb_xvmPushSymbol( symbols + 77 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmEqualIntIs( 1001, &fValue ) ) break;
	if( !fValue )
		goto lab00008;
	hb_xvmPushSymbol( symbols + 93 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00008;
	hb_xvmSetLine( 190 );
	hb_xvmPushSymbol( symbols + 94 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushNil();
	if( hb_xvmEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00007;
	hb_xvmSetLine( 191 );
	hb_xvmPushSymbol( symbols + 88 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushFuncSymbol( symbols + 95 );
	if( hb_xvmFunction( 0 ) ) break;
	hb_xvmPushFuncSymbol( symbols + 96 );
	if( hb_xvmFunction( 0 ) ) break;
	hb_xvmArrayGen( 2 );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
lab00007: ;
	hb_xvmSetLine( 193 );
	hb_xvmPushSymbol( symbols + 86 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushSymbol( symbols + 2 );
	hb_xvmPushFuncSymbol( symbols + 97 );
	if( hb_xvmFunction( 0 ) ) break;
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
lab00008: ;
	hb_xvmSetLine( 196 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_WIDGET_MOVEEVENT )
{
   do {
	hb_xvmFrame( 1, 1 );
	hb_xvmModuleName( "src/HBTui_Widget.prg:HBTUI_WIDGET_MOVEEVENT" );
	hb_xvmLocalName( 1, "MOVEEVENT" );
	hb_xvmSetLine( 201 );
	hb_xvmLocalName( 2, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 204 );
	hb_xvmPushFuncSymbol( symbols + 98 );
	hb_xvmPushSymbol( symbols + 99 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushSymbol( symbols + 100 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushSymbol( symbols + 94 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmArrayItemPush( 2 ) ) break;
	if( hb_xvmMinus() ) break;
	if( hb_xvmDo( 2 ) ) break;
	hb_xvmSetLine( 206 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_WIDGET_PAINTEVENT )
{
   HB_BOOL fValue;
   do {
	hb_xvmFrame( 1, 1 );
	hb_xvmModuleName( "src/HBTui_Widget.prg:HBTUI_WIDGET_PAINTEVENT" );
	hb_xvmLocalName( 1, "EVENT" );
	hb_xvmSetLine( 211 );
	hb_xvmLocalName( 2, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 215 );
	hb_xvmPushSymbol( symbols + 75 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushNil();
	if( hb_xvmEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmSetLine( 217 );
	hb_xvmPushSymbol( symbols + 101 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_stackPop();
	goto lab00002;
lab00001: ;
	hb_xvmSetLine( 221 );
	hb_xvmPushSymbol( symbols + 102 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_stackPop();
lab00002: ;
	hb_xvmSetLine( 225 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_WIDGET_SETFOCUS )
{
   HB_BOOL fValue;
   do {
	hb_xvmFrame( 2, 0 );
	hb_xvmModuleName( "src/HBTui_Widget.prg:HBTUI_WIDGET_SETFOCUS" );
	hb_xvmSetLine( 230 );
	hb_xvmLocalName( 1, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 1 );
	hb_xvmSetLine( 231 );
	hb_xvmLocalName( 2, "FOCUSWINDOW" );
	hb_xvmPushSymbol( symbols + 85 );
	hb_xvmPushFuncSymbol( symbols + 53 );
	if( hb_xvmFunction( 0 ) ) break;
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 233 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmExactlyEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( fValue )
		goto lab00002;
	hb_xvmSetLine( 234 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	if( hb_xvmNotEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmSetLine( 235 );
	hb_xvmPushSymbol( symbols + 103 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
lab00001: ;
	hb_xvmSetLine( 237 );
	hb_xvmPushSymbol( symbols + 104 );
	hb_xvmPushLocal( 1 );
	hb_xvmPushNil();
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
lab00002: ;
	hb_xvmSetLine( 240 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_WIDGET_SETLAYOUT )
{
   HB_BOOL fValue;
   do {
	hb_xvmFrame( 1, 1 );
	hb_xvmModuleName( "src/HBTui_Widget.prg:HBTUI_WIDGET_SETLAYOUT" );
	hb_xvmLocalName( 1, "LAYOUT" );
	hb_xvmSetLine( 245 );
	hb_xvmLocalName( 2, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 246 );
	hb_xvmPushSymbol( symbols + 30 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushNil();
	if( hb_xvmEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmSetLine( 247 );
	hb_xvmPushSymbol( symbols + 105 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
lab00001: ;
	hb_xvmSetLine( 249 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_WIDGET_SETWID )
{
   HB_BOOL fValue;
   do {
	hb_xvmFrame( 1, 1 );
	hb_xvmModuleName( "src/HBTui_Widget.prg:HBTUI_WIDGET_SETWID" );
	hb_xvmLocalName( 1, "WID" );
	hb_xvmSetLine( 254 );
	hb_xvmLocalName( 2, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 255 );
	hb_xvmPushSymbol( symbols + 55 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushNil();
	if( hb_xvmEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmSetLine( 256 );
	hb_xvmPushSymbol( symbols + 106 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 257 );
	hb_xvmPushFuncSymbol( symbols + 107 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmDo( 1 ) ) break;
lab00001: ;
	hb_xvmSetLine( 259 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_WIDGET_SHOW )
{
   do {
	hb_xvmFrame( 1, 0 );
	hb_xvmModuleName( "src/HBTui_Widget.prg:HBTUI_WIDGET_SHOW" );
	hb_xvmSetLine( 264 );
	hb_xvmLocalName( 1, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 1 );
	hb_xvmSetLine( 265 );
	hb_xvmPushSymbol( symbols + 86 );
	hb_xvmPushLocal( 1 );
	hb_xvmPushSymbol( symbols + 2 );
	hb_xvmPushFuncSymbol( symbols + 108 );
	if( hb_xvmFunction( 0 ) ) break;
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 266 );
	hb_xvmPushSymbol( symbols + 86 );
	hb_xvmPushLocal( 1 );
	hb_xvmPushSymbol( symbols + 2 );
	hb_xvmPushFuncSymbol( symbols + 87 );
	if( hb_xvmFunction( 0 ) ) break;
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 267 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_INITSTATICS()
{
   do {
	hb_xvmStatics( symbols + 110, 1 );
	hb_xvmSFrame( symbols + 110 );
	hb_xvmModuleName( "src/HBTui_Widget.prg:(_INITSTATICS)" );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_INITLINES()
{
   do {
	hb_xvmModuleName( "src/HBTui_Widget.prg:(_INITLINES)" );
	hb_xvmPushStringConst( "src/HBTui_Widget.prg", 20 );
	hb_xvmPushInteger( 8 );
	hb_xvmPushStringConst( "\xFB}\xDD_\xFF\x85\x0F\x0D\xDB%\xEC\xC2" "o[\xF8\xC2\x84\x0B\x85" "j\x86" "2\xEF\x12" "R\x88\"\xC2.\xE1\xC2\x0B\x0F", 33 );
	hb_xvmArrayGen( 3 );
	hb_xvmArrayGen( 1 );
	hb_xvmRetValue();
	/* *** END PROC *** */
   } while( 0 );
}

