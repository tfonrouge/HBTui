/*
 * Harbour 3.2.0dev (r1412151448)
 * LLVM/Clang C 6.0 (clang-600.0.56) (64-bit)
 * Generated C source from "src/HBTui_App.prg"
 */

#include "hbvmpub.h"
#include "hbpcode.h"
#include "hbinit.h"
#include "hbxvm.h"


HB_FUNC( HBTUI_APP );
HB_FUNC_EXTERN( HB_THREADONCE );
HB_FUNC_STATIC( __S_HBTUI_APP );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( HBTUI_OBJECT );
HB_FUNC_STATIC( HBTUI_APP_FOCUSEVENT );
HB_FUNC_STATIC( HBTUI_APP_SETEVENTSTACK );
HB_FUNC_STATIC( HBTUI_APP_EXEC );
HB_FUNC_EXTERN( HBTUI_UI_GETFOCUSEDWINDOW );
HB_FUNC_STATIC( HBTUI_APP_GETEVENT );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( ALTD );
HB_FUNC_EXTERN( SET );
HB_FUNC_EXTERN( ADEL );
HB_FUNC_EXTERN( MROW );
HB_FUNC_EXTERN( MCOL );
HB_FUNC_EXTERN( HBTUI_EVENTMOUSE );
HB_FUNC_EXTERN( INKEY );
HB_FUNC_EXTERN( HBTUI_UI_WINDOWATMOUSEPOS );
HB_FUNC_EXTERN( HBTUI_EVENTKEY );
HB_FUNC_EXTERN( LEN );
HB_FUNC_EXTERN( ASIZE );
HB_FUNC_EXTERN( __DBGENTRY );
HB_FUNC_INITSTATICS();
HB_FUNC_INITLINES();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_HBTUI_APP )
{ "HBTUI_APP", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_APP )}, NULL },
{ "HB_THREADONCE", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_THREADONCE )}, NULL },
{ "__S_HBTUI_APP", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( __S_HBTUI_APP )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "HBTUI_OBJECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBTUI_OBJECT )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBTUI_APP_FOCUSEVENT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_APP_FOCUSEVENT )}, NULL },
{ "HBTUI_APP_SETEVENTSTACK", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_APP_SETEVENTSTACK )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FSTATEONMOVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBTUI_APP_EXEC", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_APP_EXEC )}, NULL },
{ "HBTUI_UI_GETFOCUSEDWINDOW", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBTUI_UI_GETFOCUSEDWINDOW )}, NULL },
{ "HBTUI_APP_GETEVENT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_APP_GETEVENT )}, NULL },
{ "FALLWIDGETS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FEVENTSTACK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETEVENTSTACK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FEVENTSTACKLEN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ALTD", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALTD )}, NULL },
{ "FEXECUTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SET", {HB_FS_PUBLIC}, {HB_FUNCNAME( SET )}, NULL },
{ "_FEXECUTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETEVENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EVENTSTACKLEN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( ADEL )}, NULL },
{ "_FEVENTSTACKLEN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBTOBJECT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FOCUSWINDOW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CLOSEEVENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FOCUSEVENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "KEYEVENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MOUSEEVENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MOVEEVENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "PAINTEVENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EVENTTYPE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ALREADY_RUNNING_EXEC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FOCUSOUTEVENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FOCUSINEVENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MROW", {HB_FS_PUBLIC}, {HB_FUNCNAME( MROW )}, NULL },
{ "MCOL", {HB_FS_PUBLIC}, {HB_FUNCNAME( MCOL )}, NULL },
{ "ADDEVENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBTUI_EVENTMOUSE", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBTUI_EVENTMOUSE )}, NULL },
{ "INKEY", {HB_FS_PUBLIC}, {HB_FUNCNAME( INKEY )}, NULL },
{ "HBTUI_UI_WINDOWATMOUSEPOS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBTUI_UI_WINDOWATMOUSEPOS )}, NULL },
{ "HBTUI_EVENTKEY", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBTUI_EVENTKEY )}, NULL },
{ "_FEVENTSTACK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( LEN )}, NULL },
{ "ASIZE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ASIZE )}, NULL },
{ "__DBGENTRY", {HB_FS_PUBLIC}, {HB_FUNCNAME( __DBGENTRY )}, NULL },
{ "(_INITSTATICS00004)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL },
{ "(_INITLINES)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITLINES}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_HBTUI_APP, "src/HBTui_App.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_HBTUI_APP
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_HBTUI_APP )
   #include "hbiniseg.h"
#endif

HB_FUNC( HBTUI_APP )
{
   HB_BOOL fValue;
   do {
	hb_xvmSFrame( symbols + 56 );
	hb_xvmModuleName( "src/HBTui_App.prg:HBTUI_APP" );
	hb_xvmSetLine( 8 );
	hb_xvmStaticName( 0, 1, "OBJ" );
	hb_xvmStaticName( 0, 2, "ONCE" );
	hb_xvmSetLine( 8 );
	hb_xvmPushStatic( 1 );
	hb_xvmPushNil();
	if( hb_xvmExactlyEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmPushFuncSymbol( symbols + 1 );
	hb_xvmPushStaticByRef( 2 );
	{
		static const HB_BYTE codeblock[ 39 ] = {
			51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 65, 112, 112, 46, 112, 
			114, 103, 58, 72, 66, 84, 85, 73, 95, 65, 80, 80, 0, 176, 2, 0, 
			12, 0, 165, 82, 1, 0, 6 };
		hb_xvmPushBlockShort( codeblock, symbols );
	}
	if( hb_xvmDo( 2 ) ) break;
lab00001: ;
	hb_xvmSetLine( 8 );
	hb_xvmPushStatic( 1 );
	hb_xvmRetValue();
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( __S_HBTUI_APP )
{
   HB_BOOL fValue;
   do {
	hb_xvmVFrame( 3, 0 );
	hb_xvmSFrame( symbols + 56 );
	hb_xvmModuleName( "src/HBTui_App.prg:__S_HBTUI_APP" );
	hb_xvmSetLine( 8 );
	hb_xvmStaticName( 0, 3, "S_OCLASS" );
	hb_xvmLocalName( 1, "NSCOPE" );
	hb_xvmLocalName( 2, "OCLASS" );
	hb_xvmLocalName( 3, "OINSTANCE" );
	hb_xvmPushStatic( 3 );
	hb_xvmPushNil();
	if( hb_xvmExactlyEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00002;
	hb_xvmPushFuncSymbol( symbols + 3 );
	hb_xvmPushStaticByRef( 3 );
	if( hb_xvmFunction( 1 ) ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00002;
	hb_xvmSeqAlways();
	do {
	hb_xvmLocalSetInt( 1, 1 );
	hb_xvmPushSymbol( symbols + 4 );
	hb_xvmPushFuncSymbol( symbols + 5 );
	if( hb_xvmFunction( 0 ) ) break;
	hb_xvmPushStringConst( "HBTui_App", 9 );
	hb_xvmPushSymbol( symbols + 6 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushSymbol( symbols + 2 );
	if( hb_xvmSend( 3 ) ) break;
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 9 );
	hb_xvmLocalSetInt( 1, 2 );
	hb_xvmSetLine( 11 );
	hb_xvmPushSymbol( symbols + 7 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushLogical( HB_FALSE );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	hb_xvmPushStringConst( "Fexecute", 8 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 13 );
	hb_xvmPushSymbol( symbols + 8 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "FocusEvent", 10 );
	hb_xvmPushSymbol( symbols + 9 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 14 );
	hb_xvmPushSymbol( symbols + 8 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "SetEventStack", 13 );
	hb_xvmPushSymbol( symbols + 10 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 16 );
	hb_xvmPushSymbol( symbols + 7 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushLogical( HB_FALSE );
	hb_xvmPushInteger( 2 );
	hb_xvmPushStringConst( "FStateOnMove", 12 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmPushSymbol( symbols + 11 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "StateOnMove", 11 );
	{
		static const HB_BYTE codeblock[ 53 ] = {
			1, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 65, 
			112, 112, 46, 112, 114, 103, 58, 95, 95, 83, 95, 72, 66, 84, 85, 73, 
			95, 65, 80, 80, 0, 37, 1, 0, 83, 69, 76, 70, 0, 48, 12, 0, 
			95, 1, 112, 0, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 18 );
	hb_xvmLocalSetInt( 1, 1 );
	hb_xvmSetLine( 20 );
	hb_xvmPushSymbol( symbols + 8 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "Exec", 4 );
	hb_xvmPushSymbol( symbols + 13 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 21 );
	hb_xvmPushSymbol( symbols + 11 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "FocusWindow", 11 );
	{
		static const HB_BYTE codeblock[ 51 ] = {
			1, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 65, 
			112, 112, 46, 112, 114, 103, 58, 95, 95, 83, 95, 72, 66, 84, 85, 73, 
			95, 65, 80, 80, 0, 37, 1, 0, 83, 69, 76, 70, 0, 176, 14, 0, 
			12, 0, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 22 );
	hb_xvmPushSymbol( symbols + 8 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "GetEvent", 8 );
	hb_xvmPushSymbol( symbols + 15 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 24 );
	hb_xvmPushSymbol( symbols + 7 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushNil();
	hb_xvmPushInteger( 2 );
	hb_xvmPushStringConst( "FallWidgets", 11 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmPushSymbol( symbols + 11 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "allWidgets", 10 );
	{
		static const HB_BYTE codeblock[ 53 ] = {
			1, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 65, 
			112, 112, 46, 112, 114, 103, 58, 95, 95, 83, 95, 72, 66, 84, 85, 73, 
			95, 65, 80, 80, 0, 37, 1, 0, 83, 69, 76, 70, 0, 48, 16, 0, 
			95, 1, 112, 0, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 25 );
	hb_xvmPushSymbol( symbols + 7 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushNil();
	hb_xvmPushInteger( 2 );
	hb_xvmPushStringConst( "FeventStack", 11 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmPushSymbol( symbols + 11 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "eventStack", 10 );
	{
		static const HB_BYTE codeblock[ 53 ] = {
			1, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 65, 
			112, 112, 46, 112, 114, 103, 58, 95, 95, 83, 95, 72, 66, 84, 85, 73, 
			95, 65, 80, 80, 0, 37, 1, 0, 83, 69, 76, 70, 0, 48, 17, 0, 
			95, 1, 112, 0, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 25 );
	hb_xvmPushSymbol( symbols + 11 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "_eventStack", 11 );
	{
		static const HB_BYTE codeblock[ 66 ] = {
			2, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 65, 
			112, 112, 46, 112, 114, 103, 58, 95, 95, 83, 95, 72, 66, 84, 85, 73, 
			95, 65, 80, 80, 0, 37, 1, 0, 83, 69, 76, 70, 0, 37, 2, 0, 
			88, 78, 69, 87, 86, 65, 76, 0, 48, 18, 0, 95, 1, 95, 2, 112, 
			1, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 26 );
	hb_xvmPushSymbol( symbols + 7 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushInteger( 0 );
	hb_xvmPushInteger( 2 );
	hb_xvmPushStringConst( "FeventStackLen", 14 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmPushSymbol( symbols + 11 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "eventStackLen", 13 );
	{
		static const HB_BYTE codeblock[ 53 ] = {
			1, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 65, 
			112, 112, 46, 112, 114, 103, 58, 95, 95, 83, 95, 72, 66, 84, 85, 73, 
			95, 65, 80, 80, 0, 37, 1, 0, 83, 69, 76, 70, 0, 48, 19, 0, 
			95, 1, 112, 0, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 28 );
	hb_xvmPushSymbol( symbols + 20 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_stackPop();
	} while( 0 );
	if( hb_xvmAlwaysBegin() ) break;
	do {
	hb_xvmPushFuncSymbol( symbols + 21 );
	hb_xvmPushStaticByRef( 3 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmDo( 2 ) ) break;
	} while( 0 );
	if( hb_xvmAlwaysEnd() ) break;
	hb_xvmPushSymbol( symbols + 22 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPopLocal( 3 );
	hb_xvmPushFuncSymbol( symbols + 23 );
	hb_xvmPushLocal( 3 );
	hb_xvmPushStringConst( "InitClass", 9 );
	if( hb_xvmFunction( 2 ) ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmPushSymbol( symbols + 24 );
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
	hb_xvmPushSymbol( symbols + 22 );
	hb_xvmPushStatic( 3 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmRetValue();
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_APP_EXEC )
{
   HB_BOOL fValue;
   do {
	hb_xvmFrame( 4, 0 );
	hb_xvmModuleName( "src/HBTui_App.prg:HBTUI_APP_EXEC" );
	hb_xvmSetLine( 33 );
	hb_xvmLocalName( 1, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 1 );
	hb_xvmSetLine( 34 );
	hb_xvmLocalName( 2, "RESULT" );
	hb_xvmSetLine( 35 );
	hb_xvmLocalName( 3, "EVENT" );
	hb_xvmSetLine( 36 );
	hb_xvmLocalName( 4, "HBTOBJECT" );
	hb_xvmSetLine( 38 );
	hb_xvmPushFuncSymbol( symbols + 25 );
	if( hb_xvmDo( 0 ) ) break;
	hb_xvmSetLine( 40 );
	hb_xvmPushSymbol( symbols + 26 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( fValue )
		goto lab00011;
	hb_xvmSetLine( 43 );
	hb_xvmPushFuncSymbol( symbols + 27 );
	hb_xvmPushInteger( 39 );
	hb_xvmPushInteger( 255 );
	if( hb_xvmDo( 2 ) ) break;
	hb_xvmSetLine( 45 );
	hb_xvmLocalSetInt( 2, 0 );
	hb_xvmSetLine( 47 );
	hb_xvmPushSymbol( symbols + 28 );
	hb_xvmPushLocal( 1 );
	hb_xvmPushLogical( HB_TRUE );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
lab00001: ;
	hb_xvmSetLine( 49 );
	hb_xvmPushSymbol( symbols + 26 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00012;
	hb_xvmSetLine( 51 );
	hb_xvmPushSymbol( symbols + 29 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 53 );
	hb_xvmPushSymbol( symbols + 30 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmGreaterThenIntIs( 0, &fValue ) ) break;
	if( !fValue )
		goto lab00001;
	hb_xvmSetLine( 55 );
	hb_xvmPushSymbol( symbols + 17 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmArrayItemPush( 1 ) ) break;
	hb_xvmPopLocal( 3 );
	hb_xvmSetLine( 56 );
	hb_xvmPushFuncSymbol( symbols + 31 );
	hb_xvmPushSymbol( symbols + 17 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushInteger( 1 );
	if( hb_xvmDo( 2 ) ) break;
	hb_xvmSetLine( 57 );
	hb_xvmPushSymbol( symbols + 32 );
	hb_xvmPushLocal( 1 );
	hb_xvmDuplicate();
	hb_xvmPushSymbol( symbols + 19 );
	hb_xvmSwap( 0 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmDec() ) break;
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 59 );
	hb_xvmPushSymbol( symbols + 33 );
	hb_xvmPushLocal( 3 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushNil();
	if( hb_xvmEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00002;
	hb_xvmPushSymbol( symbols + 34 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	goto lab00003;
lab00002: ;
	hb_xvmPushSymbol( symbols + 33 );
	hb_xvmPushLocal( 3 );
	if( hb_xvmSend( 0 ) ) break;
lab00003: ;
	hb_xvmPopLocal( 4 );
	hb_xvmSetLine( 61 );
	goto lab00010;
lab00004: ;
	hb_xvmSetLine( 63 );
	hb_xvmPushSymbol( symbols + 35 );
	hb_xvmPushLocal( 4 );
	hb_xvmPushLocal( 3 );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 64 );
	goto lab00001;
lab00005: ;
	hb_xvmSetLine( 66 );
	hb_xvmPushSymbol( symbols + 36 );
	hb_xvmPushLocal( 1 );
	hb_xvmPushLocal( 3 );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 67 );
	goto lab00001;
lab00006: ;
	hb_xvmSetLine( 69 );
	hb_xvmPushSymbol( symbols + 37 );
	hb_xvmPushLocal( 4 );
	hb_xvmPushLocal( 3 );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 70 );
	goto lab00001;
lab00007: ;
	hb_xvmSetLine( 72 );
	hb_xvmPushSymbol( symbols + 38 );
	hb_xvmPushLocal( 4 );
	hb_xvmPushLocal( 3 );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 73 );
	goto lab00001;
lab00008: ;
	hb_xvmSetLine( 75 );
	hb_xvmPushSymbol( symbols + 39 );
	hb_xvmPushLocal( 4 );
	hb_xvmPushLocal( 3 );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 76 );
	goto lab00001;
lab00009: ;
	hb_xvmSetLine( 78 );
	hb_xvmPushSymbol( symbols + 40 );
	hb_xvmPushLocal( 4 );
	hb_xvmPushLocal( 3 );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 79 );
	goto lab00001;
lab00010: ;
	hb_xvmPushSymbol( symbols + 41 );
	hb_xvmPushLocal( 3 );
	if( hb_xvmSend( 0 ) ) break;
	{
		PHB_ITEM pSwitch;
		HB_TYPE type;
		long lVal;
		if( hb_xvmSwitchGet( &pSwitch ) ) break;
		type = hb_itemType( pSwitch );
		lVal = ( type & HB_IT_NUMINT ) ? hb_itemGetNL( pSwitch ) : 0;

		if( ( type & HB_IT_NUMINT ) != 0 && lVal == 1L )
		{
			hb_stackPop();
			goto lab00004;
		}
		if( ( type & HB_IT_NUMINT ) != 0 && lVal == 2L )
		{
			hb_stackPop();
			goto lab00005;
		}
		if( ( type & HB_IT_NUMINT ) != 0 && lVal == 5L )
		{
			hb_stackPop();
			goto lab00006;
		}
		if( ( type & HB_IT_NUMINT ) != 0 && lVal == 6L )
		{
			hb_stackPop();
			goto lab00007;
		}
		if( ( type & HB_IT_NUMINT ) != 0 && lVal == 7L )
		{
			hb_stackPop();
			goto lab00008;
		}
		if( ( type & HB_IT_NUMINT ) != 0 && lVal == 8L )
		{
			hb_stackPop();
			goto lab00009;
		}
		hb_stackPop();
	}
	hb_xvmSetLine( 82 );
	goto lab00001;
lab00011: ;
	hb_xvmSetLine( 88 );
	hb_xvmPushSymbol( symbols + 42 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_stackPop();
lab00012: ;
	hb_xvmSetLine( 92 );
	hb_xvmPushLocal( 2 );
	hb_xvmRetValue();
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_APP_FOCUSEVENT )
{
   do {
	hb_xvmFrame( 1, 1 );
	hb_xvmModuleName( "src/HBTui_App.prg:HBTUI_APP_FOCUSEVENT" );
	hb_xvmLocalName( 1, "EVENT" );
	hb_xvmSetLine( 97 );
	hb_xvmLocalName( 2, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 99 );
	hb_xvmPushSymbol( symbols + 43 );
	hb_xvmPushSymbol( symbols + 34 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 100 );
	hb_xvmPushSymbol( symbols + 44 );
	hb_xvmPushSymbol( symbols + 33 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 102 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_APP_GETEVENT )
{
   HB_BOOL fValue;
   do {
	hb_xvmFrame( 4, 0 );
	hb_xvmSFrame( symbols + 56 );
	hb_xvmModuleName( "src/HBTui_App.prg:HBTUI_APP_GETEVENT" );
	hb_xvmSetLine( 107 );
	hb_xvmLocalName( 1, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 1 );
	hb_xvmSetLine( 108 );
	hb_xvmLocalName( 2, "NKEY" );
	hb_xvmSetLine( 109 );
	hb_xvmLocalName( 3, "MROW" );
	hb_xvmPushFuncSymbol( symbols + 45 );
	hb_xvmPushLogical( HB_TRUE );
	if( hb_xvmFunction( 1 ) ) break;
	hb_xvmPopLocal( 3 );
	hb_xvmSetLine( 110 );
	hb_xvmLocalName( 4, "MCOL" );
	hb_xvmPushFuncSymbol( symbols + 46 );
	hb_xvmPushLogical( HB_TRUE );
	if( hb_xvmFunction( 1 ) ) break;
	hb_xvmPopLocal( 4 );
	hb_xvmSetLine( 112 );
	hb_xvmStaticName( 0, 4, "MCOORDS" );
	hb_xvmSetLine( 114 );
	hb_xvmPushStatic( 4 );
	hb_xvmPushNil();
	if( hb_xvmEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmSetLine( 115 );
	hb_xvmPushLocal( 3 );
	hb_xvmPushLocal( 4 );
	hb_xvmArrayGen( 2 );
	hb_xvmPopStatic( 4 );
lab00001: ;
	hb_xvmSetLine( 118 );
	hb_xvmPushStatic( 4 );
	if( hb_xvmArrayItemPush( 1 ) ) break;
	hb_xvmPushLocal( 3 );
	if( hb_xvmNotEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( fValue )
		goto lab00002;
	hb_xvmPushStatic( 4 );
	if( hb_xvmArrayItemPush( 2 ) ) break;
	hb_xvmPushLocal( 4 );
	if( hb_xvmNotEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00003;
lab00002: ;
	hb_xvmSetLine( 119 );
	hb_xvmPushSymbol( symbols + 47 );
	hb_xvmPushSymbol( symbols + 34 );
	hb_xvmPushFuncSymbol( symbols + 0 );
	if( hb_xvmFunction( 0 ) ) break;
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushSymbol( symbols + 4 );
	hb_xvmPushFuncSymbol( symbols + 48 );
	if( hb_xvmFunction( 0 ) ) break;
	hb_xvmPushInteger( 1001 );
	if( hb_xvmSend( 1 ) ) break;
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 120 );
	hb_xvmPushLocal( 3 );
	hb_xvmPushStatic( 4 );
	if( hb_xvmArrayItemPop( 1 ) ) break;
	hb_xvmSetLine( 121 );
	hb_xvmPushLocal( 4 );
	hb_xvmPushStatic( 4 );
	if( hb_xvmArrayItemPop( 2 ) ) break;
	hb_xvmSetLine( 122 );
	/* *** END PROC *** */
	break;
lab00003: ;
	hb_xvmSetLine( 125 );
	hb_xvmPushSymbol( symbols + 30 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmGreaterThenIntIs( 0, &fValue ) ) break;
	if( !fValue )
		goto lab00004;
	hb_xvmSetLine( 126 );
	hb_xvmPushFuncSymbol( symbols + 49 );
	if( hb_xvmFunction( 0 ) ) break;
	hb_xvmPopLocal( 2 );
	goto lab00005;
lab00004: ;
	hb_xvmSetLine( 128 );
	hb_xvmPushFuncSymbol( symbols + 49 );
	hb_xvmPushDouble( * ( double * ) "\x9A\x99\x99\x99\x99\x99\xC9\?", 10, 1 );
	if( hb_xvmFunction( 1 ) ) break;
	hb_xvmPopLocal( 2 );
lab00005: ;
	hb_xvmSetLine( 131 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmNotEqualIntIs( 0, &fValue ) ) break;
	if( !fValue )
		goto lab00007;
	hb_xvmSetLine( 132 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmGreaterEqualThenIntIs( 1001, &fValue ) ) break;
	if( !fValue )
		goto lab00006;
	hb_xvmPushLocal( 2 );
	if( hb_xvmLessEqualThenIntIs( 1016, &fValue ) ) break;
	if( !fValue )
		goto lab00006;
	hb_xvmSetLine( 133 );
	hb_xvmPushSymbol( symbols + 47 );
	hb_xvmPushFuncSymbol( symbols + 50 );
	if( hb_xvmFunction( 0 ) ) break;
	hb_xvmPushSymbol( symbols + 4 );
	hb_xvmPushFuncSymbol( symbols + 48 );
	if( hb_xvmFunction( 0 ) ) break;
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 1 ) ) break;
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	goto lab00007;
lab00006: ;
	hb_xvmSetLine( 135 );
	hb_xvmPushSymbol( symbols + 47 );
	hb_xvmPushFuncSymbol( symbols + 50 );
	if( hb_xvmFunction( 0 ) ) break;
	hb_xvmPushSymbol( symbols + 4 );
	hb_xvmPushFuncSymbol( symbols + 51 );
	if( hb_xvmFunction( 0 ) ) break;
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 1 ) ) break;
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
lab00007: ;
	hb_xvmSetLine( 139 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_APP_SETEVENTSTACK )
{
   HB_BOOL fValue;
   do {
	hb_xvmFrame( 1, 1 );
	hb_xvmModuleName( "src/HBTui_App.prg:HBTUI_APP_SETEVENTSTACK" );
	hb_xvmLocalName( 1, "EVENT" );
	hb_xvmSetLine( 144 );
	hb_xvmLocalName( 2, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 145 );
	hb_xvmPushSymbol( symbols + 17 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushNil();
	if( hb_xvmEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmSetLine( 146 );
	hb_xvmPushSymbol( symbols + 52 );
	hb_xvmPushLocal( 2 );
	hb_xvmArrayGen( 0 );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
lab00001: ;
	hb_xvmSetLine( 148 );
	hb_xvmPushSymbol( symbols + 19 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmLessThenIntIs( 128, &fValue ) ) break;
	if( !fValue )
		goto lab00003;
	hb_xvmSetLine( 149 );
	hb_xvmPushSymbol( symbols + 32 );
	hb_xvmPushLocal( 2 );
	hb_xvmDuplicate();
	hb_xvmPushSymbol( symbols + 19 );
	hb_xvmSwap( 0 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmInc() ) break;
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 150 );
	hb_xvmPushFuncSymbol( symbols + 53 );
	hb_xvmPushSymbol( symbols + 17 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmFunction( 1 ) ) break;
	hb_xvmPushSymbol( symbols + 19 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmLess() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00002;
	hb_xvmSetLine( 151 );
	hb_xvmPushFuncSymbol( symbols + 54 );
	hb_xvmPushSymbol( symbols + 17 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushSymbol( symbols + 19 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmDo( 2 ) ) break;
lab00002: ;
	hb_xvmSetLine( 153 );
	hb_xvmPushLocal( 1 );
	hb_xvmPushSymbol( symbols + 17 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushSymbol( symbols + 19 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmArrayPop() ) break;
lab00003: ;
	hb_xvmSetLine( 155 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_INITSTATICS()
{
   do {
	hb_xvmStatics( symbols + 56, 4 );
	hb_xvmSFrame( symbols + 56 );
	hb_xvmModuleName( "src/HBTui_App.prg:(_INITSTATICS)" );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_INITLINES()
{
   do {
	hb_xvmModuleName( "src/HBTui_App.prg:(_INITLINES)" );
	hb_xvmPushStringConst( "src/HBTui_App.prg", 17 );
	hb_xvmPushInteger( 8 );
	hb_xvmPushStringConst( "ku\x17^\xA9\xAA\xAB" "m\xDB\x04\x11" "Zx\xCD" "g\xB9\x08\xF7\x0A", 19 );
	hb_xvmArrayGen( 3 );
	hb_xvmArrayGen( 1 );
	hb_xvmRetValue();
	/* *** END PROC *** */
   } while( 0 );
}

