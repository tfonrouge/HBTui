/*
 * Harbour 3.2.0dev (r1412151448)
 * LLVM/Clang C 6.0 (clang-600.0.56) (64-bit)
 * Generated C source from "src/HBTui_Object.prg"
 */

#include "hbvmpub.h"
#include "hbpcode.h"
#include "hbinit.h"
#include "hbxvm.h"


HB_FUNC( HBTUI_OBJECT );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( HBTUI_BASE );
HB_FUNC_STATIC( HBTUI_OBJECT_ADDCHILD );
HB_FUNC_STATIC( HBTUI_OBJECT_NEW );
HB_FUNC_STATIC( HBTUI_OBJECT_SETPARENT );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( AADD );
HB_FUNC( HBTUI_UI_ADDMAINWIDGET );
HB_FUNC_EXTERN( LEN );
HB_FUNC_EXTERN( ASIZE );
HB_FUNC_EXTERN( HBTUI_UI_UNREFCOUNTCOPY );
HB_FUNC( HBTUI_UI_GETFOCUSEDWINDOW );
HB_FUNC_EXTERN( HBTUI_DESKTOP );
HB_FUNC( HBTUI_UI_SETFOCUSEDWINDOW );
HB_FUNC( HBTUI_UI_WINDOWATMOUSEPOS );
HB_FUNC_EXTERN( HBTUI_UI_WIDATMOUSEPOS );
HB_FUNC_EXTERN( __DBGENTRY );
HB_FUNC_INITSTATICS();
HB_FUNC_INITLINES();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_HBTUI_OBJECT )
{ "HBTUI_OBJECT", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_OBJECT )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "HBTUI_BASE", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBTUI_BASE )}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBTUI_OBJECT_ADDCHILD", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_OBJECT_ADDCHILD )}, NULL },
{ "HBTUI_OBJECT_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_OBJECT_NEW )}, NULL },
{ "HBTUI_OBJECT_SETPARENT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_OBJECT_SETPARENT )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FCHILDREN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FPARENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETPARENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AADD", {HB_FS_PUBLIC}, {HB_FUNCNAME( AADD )}, NULL },
{ "ISDERIVEDFROM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_FPARENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDCHILD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ERROR_PARENT_IS_NOT_DERIVED_FROM_TXOBJECT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBTUI_UI_ADDMAINWIDGET", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_UI_ADDMAINWIDGET )}, NULL },
{ "LEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( LEN )}, NULL },
{ "WID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ASIZE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ASIZE )}, NULL },
{ "HBTUI_UI_UNREFCOUNTCOPY", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBTUI_UI_UNREFCOUNTCOPY )}, NULL },
{ "HBTUI_UI_GETFOCUSEDWINDOW", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_UI_GETFOCUSEDWINDOW )}, NULL },
{ "HBTUI_DESKTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBTUI_DESKTOP )}, NULL },
{ "HBTUI_UI_SETFOCUSEDWINDOW", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_UI_SETFOCUSEDWINDOW )}, NULL },
{ "HBTUI_UI_WINDOWATMOUSEPOS", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_UI_WINDOWATMOUSEPOS )}, NULL },
{ "HBTUI_UI_WIDATMOUSEPOS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBTUI_UI_WIDATMOUSEPOS )}, NULL },
{ "__DBGENTRY", {HB_FS_PUBLIC}, {HB_FUNCNAME( __DBGENTRY )}, NULL },
{ "(_INITSTATICS00003)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL },
{ "(_INITLINES)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITLINES}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_HBTUI_OBJECT, "src/HBTui_Object.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_HBTUI_OBJECT
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_HBTUI_OBJECT )
   #include "hbiniseg.h"
#endif

HB_FUNC( HBTUI_OBJECT )
{
   HB_BOOL fValue;
   do {
	hb_xvmVFrame( 3, 0 );
	hb_xvmSFrame( symbols + 35 );
	hb_xvmModuleName( "src/HBTui_Object.prg:HBTUI_OBJECT" );
	hb_xvmSetLine( 13 );
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
	hb_xvmPushFuncSymbol( symbols + 1 );
	hb_xvmPushStaticByRef( 3 );
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
	hb_xvmPushStringConst( "HBTui_Object", 12 );
	hb_xvmPushSymbol( symbols + 4 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushSymbol( symbols + 0 );
	if( hb_xvmSend( 3 ) ) break;
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 14 );
	hb_xvmLocalSetInt( 1, 2 );
	hb_xvmSetLine( 15 );
	hb_xvmPushSymbol( symbols + 5 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "AddChild", 8 );
	hb_xvmPushSymbol( symbols + 6 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 16 );
	hb_xvmLocalSetInt( 1, 1 );
	hb_xvmSetLine( 18 );
	hb_xvmPushSymbol( symbols + 5 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "New", 3 );
	hb_xvmPushSymbol( symbols + 7 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 8 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 20 );
	hb_xvmPushSymbol( symbols + 5 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "SetParent", 9 );
	hb_xvmPushSymbol( symbols + 8 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 22 );
	hb_xvmPushSymbol( symbols + 9 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmArrayGen( 0 );
	hb_xvmPushInteger( 2 );
	hb_xvmPushStringConst( "Fchildren", 9 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmPushSymbol( symbols + 10 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "children", 8 );
	{
		static const HB_BYTE codeblock[ 55 ] = {
			1, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 79, 
			98, 106, 101, 99, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			79, 66, 74, 69, 67, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 48, 
			11, 0, 95, 1, 112, 0, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 23 );
	hb_xvmPushSymbol( symbols + 9 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushNil();
	hb_xvmPushInteger( 2 );
	hb_xvmPushStringConst( "Fparent", 7 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmPushSymbol( symbols + 10 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "parent", 6 );
	{
		static const HB_BYTE codeblock[ 55 ] = {
			1, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 79, 
			98, 106, 101, 99, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			79, 66, 74, 69, 67, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 48, 
			12, 0, 95, 1, 112, 0, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 23 );
	hb_xvmPushSymbol( symbols + 10 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "_parent", 7 );
	{
		static const HB_BYTE codeblock[ 68 ] = {
			2, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 79, 
			98, 106, 101, 99, 116, 46, 112, 114, 103, 58, 72, 66, 84, 85, 73, 95, 
			79, 66, 74, 69, 67, 84, 0, 37, 1, 0, 83, 69, 76, 70, 0, 37, 
			2, 0, 88, 78, 69, 87, 86, 65, 76, 0, 48, 13, 0, 95, 1, 95, 
			2, 112, 1, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 25 );
	hb_xvmPushSymbol( symbols + 14 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_stackPop();
	} while( 0 );
	if( hb_xvmAlwaysBegin() ) break;
	do {
	hb_xvmPushFuncSymbol( symbols + 15 );
	hb_xvmPushStaticByRef( 3 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmDo( 2 ) ) break;
	} while( 0 );
	if( hb_xvmAlwaysEnd() ) break;
	hb_xvmPushSymbol( symbols + 16 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPopLocal( 3 );
	hb_xvmPushFuncSymbol( symbols + 17 );
	hb_xvmPushLocal( 3 );
	hb_xvmPushStringConst( "InitClass", 9 );
	if( hb_xvmFunction( 2 ) ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmPushSymbol( symbols + 18 );
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
	hb_xvmPushSymbol( symbols + 16 );
	hb_xvmPushStatic( 3 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmRetValue();
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_OBJECT_NEW )
{
   do {
	hb_xvmFrame( 1, 1 );
	hb_xvmModuleName( "src/HBTui_Object.prg:HBTUI_OBJECT_NEW" );
	hb_xvmLocalName( 1, "PARENT" );
	hb_xvmSetLine( 30 );
	hb_xvmLocalName( 2, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 31 );
	hb_xvmPushSymbol( symbols + 13 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 32 );
	hb_xvmPushLocal( 2 );
	hb_xvmRetValue();
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_OBJECT_ADDCHILD )
{
   do {
	hb_xvmFrame( 1, 1 );
	hb_xvmModuleName( "src/HBTui_Object.prg:HBTUI_OBJECT_ADDCHILD" );
	hb_xvmLocalName( 1, "CHILD" );
	hb_xvmSetLine( 37 );
	hb_xvmLocalName( 2, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 38 );
	hb_xvmPushFuncSymbol( symbols + 19 );
	hb_xvmPushSymbol( symbols + 11 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushLocal( 1 );
	if( hb_xvmDo( 2 ) ) break;
	hb_xvmSetLine( 39 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_OBJECT_SETPARENT )
{
   HB_BOOL fValue;
   do {
	hb_xvmFrame( 1, 1 );
	hb_xvmModuleName( "src/HBTui_Object.prg:HBTUI_OBJECT_SETPARENT" );
	hb_xvmLocalName( 1, "PARENT" );
	hb_xvmSetLine( 44 );
	hb_xvmLocalName( 2, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 45 );
	hb_xvmPushLocal( 1 );
	hb_xvmPushNil();
	if( hb_xvmNotEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00002;
	hb_xvmSetLine( 46 );
	hb_xvmPushSymbol( symbols + 20 );
	hb_xvmPushLocal( 1 );
	hb_xvmPushStringConst( "HBTui_Object", 12 );
	if( hb_xvmSend( 1 ) ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmSetLine( 47 );
	hb_xvmPushSymbol( symbols + 21 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 48 );
	hb_xvmPushSymbol( symbols + 22 );
	hb_xvmPushLocal( 1 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	goto lab00002;
lab00001: ;
	hb_xvmSetLine( 50 );
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_stackPop();
lab00002: ;
	hb_xvmSetLine( 53 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC( HBTUI_UI_ADDMAINWIDGET )
{
   HB_BOOL fValue;
   do {
	hb_xvmFrame( 0, 1 );
	hb_xvmSFrame( symbols + 35 );
	hb_xvmModuleName( "src/HBTui_Object.prg:HBTUI_UI_ADDMAINWIDGET" );
	hb_xvmLocalName( 1, "WIDGET" );
	hb_xvmSetLine( 63 );
	hb_xvmPushStatic( 2 );
	hb_xvmPushNil();
	if( hb_xvmEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmSetLine( 64 );
	hb_xvmArrayGen( 0 );
	hb_xvmPopStatic( 2 );
lab00001: ;
	hb_xvmSetLine( 66 );
	hb_xvmPushFuncSymbol( symbols + 25 );
	hb_xvmPushStatic( 2 );
	if( hb_xvmFunction( 1 ) ) break;
	hb_xvmPushSymbol( symbols + 26 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmLess() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00002;
	hb_xvmSetLine( 67 );
	hb_xvmPushFuncSymbol( symbols + 27 );
	hb_xvmPushStatic( 2 );
	hb_xvmPushSymbol( symbols + 26 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmDo( 2 ) ) break;
lab00002: ;
	hb_xvmSetLine( 69 );
	hb_xvmPushFuncSymbol( symbols + 28 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmFunction( 1 ) ) break;
	hb_xvmPushStatic( 2 );
	hb_xvmPushSymbol( symbols + 26 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmArrayPop() ) break;
	hb_xvmSetLine( 70 );
	hb_xvmPushStatic( 2 );
	hb_xvmRetValue();
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC( HBTUI_UI_GETFOCUSEDWINDOW )
{
   HB_BOOL fValue;
   do {
	hb_xvmSFrame( symbols + 35 );
	hb_xvmModuleName( "src/HBTui_Object.prg:HBTUI_UI_GETFOCUSEDWINDOW" );
	hb_xvmSetLine( 76 );
	hb_xvmPushStatic( 1 );
	hb_xvmPushNil();
	if( hb_xvmEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmSetLine( 77 );
	hb_xvmPushFuncSymbol( symbols + 30 );
	if( hb_xvmDo( 0 ) ) break;
	/* *** END PROC *** */
	break;
lab00001: ;
	hb_xvmSetLine( 79 );
	hb_xvmPushStatic( 1 );
	hb_xvmRetValue();
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC( HBTUI_UI_SETFOCUSEDWINDOW )
{
   do {
	hb_xvmFrame( 1, 1 );
	hb_xvmSFrame( symbols + 35 );
	hb_xvmModuleName( "src/HBTui_Object.prg:HBTUI_UI_SETFOCUSEDWINDOW" );
	hb_xvmLocalName( 1, "WINDOW" );
	hb_xvmSetLine( 85 );
	hb_xvmLocalName( 2, "OLDWINDOW" );
	hb_xvmSetLine( 87 );
	hb_xvmPushStatic( 1 );
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 88 );
	hb_xvmPushLocal( 1 );
	hb_xvmPopStatic( 1 );
	hb_xvmSetLine( 90 );
	hb_xvmPushLocal( 2 );
	hb_xvmRetValue();
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC( HBTUI_UI_WINDOWATMOUSEPOS )
{
   HB_BOOL fValue;
   do {
	hb_xvmFrame( 1, 0 );
	hb_xvmSFrame( symbols + 35 );
	hb_xvmModuleName( "src/HBTui_Object.prg:HBTUI_UI_WINDOWATMOUSEPOS" );
	hb_xvmSetLine( 96 );
	hb_xvmLocalName( 1, "WID" );
	hb_xvmPushFuncSymbol( symbols + 33 );
	if( hb_xvmFunction( 0 ) ) break;
	hb_xvmPopLocal( 1 );
	hb_xvmSetLine( 98 );
	hb_xvmPushStatic( 2 );
	hb_xvmPushNil();
	if( hb_xvmNotEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmPushLocal( 1 );
	if( hb_xvmGreaterThenIntIs( 0, &fValue ) ) break;
	if( !fValue )
		goto lab00001;
	hb_xvmPushLocal( 1 );
	hb_xvmPushFuncSymbol( symbols + 25 );
	hb_xvmPushStatic( 2 );
	if( hb_xvmFunction( 1 ) ) break;
	if( hb_xvmLessEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmSetLine( 99 );
	hb_xvmPushStatic( 2 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmArrayPush() ) break;
	hb_xvmRetValue();
	/* *** END PROC *** */
	break;
lab00001: ;
	hb_xvmSetLine( 102 );
	hb_xvmPushFuncSymbol( symbols + 30 );
	if( hb_xvmDo( 0 ) ) break;
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_INITSTATICS()
{
   do {
	hb_xvmStatics( symbols + 35, 3 );
	hb_xvmSFrame( symbols + 35 );
	hb_xvmModuleName( "src/HBTui_Object.prg:(_INITSTATICS)" );
	hb_xvmStaticName( 1, 1, "S_FOCUSEDWINDOW" );
	hb_xvmStaticName( 1, 2, "S_MAINWIDGET" );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_INITLINES()
{
   do {
	hb_xvmModuleName( "src/HBTui_Object.prg:(_INITLINES)" );
	hb_xvmPushStringConst( "src/HBTui_Object.prg", 20 );
	hb_xvmPushInteger( 8 );
	hb_xvmPushStringConst( "\xE0\xD5\xC2\xE1\xF0%\x80" "m\xB0\xA0\x05" "M", 12 );
	hb_xvmArrayGen( 3 );
	hb_xvmArrayGen( 1 );
	hb_xvmRetValue();
	/* *** END PROC *** */
   } while( 0 );
}

