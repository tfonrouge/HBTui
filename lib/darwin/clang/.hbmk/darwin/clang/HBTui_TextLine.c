/*
 * Harbour 3.2.0dev (r1412151448)
 * LLVM/Clang C 6.0 (clang-600.0.56) (64-bit)
 * Generated C source from "src/HBTui_TextLine.prg"
 */

#include "hbvmpub.h"
#include "hbpcode.h"
#include "hbinit.h"
#include "hbxvm.h"


HB_FUNC( HBTUI_TEXTLINE );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( HBTUI_WIDGET );
HB_FUNC_STATIC( HBTUI_TEXTLINE_NEW );
HB_FUNC_STATIC( HBTUI_TEXTLINE_PAINTEVENT );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( DEVPOS );
HB_FUNC_EXTERN( DEVOUT );
HB_FUNC_EXTERN( __DBGENTRY );
HB_FUNC_INITSTATICS();
HB_FUNC_INITLINES();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_HBTUI_TEXTLINE )
{ "HBTUI_TEXTLINE", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_TEXTLINE )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "HBTUI_WIDGET", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBTUI_WIDGET )}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBTUI_TEXTLINE_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_TEXTLINE_NEW )}, NULL },
{ "HBTUI_TEXTLINE_PAINTEVENT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( HBTUI_TEXTLINE_PAINTEVENT )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_FTEXT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FTEXT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETTEXT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETPARENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SUPER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_TEXT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEVPOS", {HB_FS_PUBLIC}, {HB_FUNCNAME( DEVPOS )}, NULL },
{ "X", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "Y", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEVOUT", {HB_FS_PUBLIC}, {HB_FUNCNAME( DEVOUT )}, NULL },
{ "TEXT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__DBGENTRY", {HB_FS_PUBLIC}, {HB_FUNCNAME( __DBGENTRY )}, NULL },
{ "(_INITSTATICS00001)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL },
{ "(_INITLINES)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITLINES}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_HBTUI_TEXTLINE, "src/HBTui_TextLine.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_HBTUI_TEXTLINE
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_HBTUI_TEXTLINE )
   #include "hbiniseg.h"
#endif

HB_FUNC( HBTUI_TEXTLINE )
{
   HB_BOOL fValue;
   do {
	hb_xvmVFrame( 3, 0 );
	hb_xvmSFrame( symbols + 27 );
	hb_xvmModuleName( "src/HBTui_TextLine.prg:HBTUI_TEXTLINE" );
	hb_xvmSetLine( 7 );
	hb_xvmStaticName( 0, 1, "S_OCLASS" );
	hb_xvmSetLine( 7 );
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
	hb_xvmPushStringConst( "HBTui_TextLine", 14 );
	hb_xvmPushSymbol( symbols + 4 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushSymbol( symbols + 0 );
	if( hb_xvmSend( 3 ) ) break;
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 8 );
	hb_xvmLocalSetInt( 1, 1 );
	hb_xvmSetLine( 10 );
	hb_xvmPushSymbol( symbols + 5 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "New", 3 );
	hb_xvmPushSymbol( symbols + 6 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 8 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 12 );
	hb_xvmPushSymbol( symbols + 5 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "PaintEvent", 10 );
	hb_xvmPushSymbol( symbols + 7 );
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 14 );
	hb_xvmPushSymbol( symbols + 8 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "Settext", 7 );
	{
		static const HB_BYTE codeblock[ 70 ] = {
			2, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 84, 
			101, 120, 116, 76, 105, 110, 101, 46, 112, 114, 103, 58, 72, 66, 84, 85, 
			73, 95, 84, 69, 88, 84, 76, 73, 78, 69, 0, 37, 1, 0, 83, 69, 
			76, 70, 0, 37, 2, 0, 86, 65, 76, 85, 69, 0, 48, 9, 0, 95, 
			1, 95, 2, 112, 1, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushInteger( 2 );
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 14 );
	hb_xvmPushSymbol( symbols + 10 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	hb_xvmPushStringConst( "", 0 );
	hb_xvmPushInteger( 2 );
	hb_xvmPushStringConst( "Ftext", 5 );
	hb_xvmArrayGen( 1 );
	hb_xvmPushLogical( HB_FALSE );
	if( hb_xvmSend( 5 ) ) break;
	hb_stackPop();
	hb_xvmPushSymbol( symbols + 8 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "text", 4 );
	{
		static const HB_BYTE codeblock[ 59 ] = {
			1, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 84, 
			101, 120, 116, 76, 105, 110, 101, 46, 112, 114, 103, 58, 72, 66, 84, 85, 
			73, 95, 84, 69, 88, 84, 76, 73, 78, 69, 0, 37, 1, 0, 83, 69, 
			76, 70, 0, 48, 11, 0, 95, 1, 112, 0, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 14 );
	hb_xvmPushSymbol( symbols + 8 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushStringConst( "_text", 5 );
	{
		static const HB_BYTE codeblock[ 72 ] = {
			2, 0, 0, 0, 51, 115, 114, 99, 47, 72, 66, 84, 117, 105, 95, 84, 
			101, 120, 116, 76, 105, 110, 101, 46, 112, 114, 103, 58, 72, 66, 84, 85, 
			73, 95, 84, 69, 88, 84, 76, 73, 78, 69, 0, 37, 1, 0, 83, 69, 
			76, 70, 0, 37, 2, 0, 88, 78, 69, 87, 86, 65, 76, 0, 48, 12, 
			0, 95, 1, 95, 2, 112, 1, 6 };
		hb_xvmPushBlock( codeblock, symbols );
	}
	hb_xvmPushLocal( 1 );
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmAddInt( 0 ) ) break;
	if( hb_xvmSend( 3 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 16 );
	hb_xvmPushSymbol( symbols + 13 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_stackPop();
	} while( 0 );
	if( hb_xvmAlwaysBegin() ) break;
	do {
	hb_xvmPushFuncSymbol( symbols + 14 );
	hb_xvmPushStaticByRef( 1 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmDo( 2 ) ) break;
	} while( 0 );
	if( hb_xvmAlwaysEnd() ) break;
	hb_xvmPushSymbol( symbols + 15 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPopLocal( 3 );
	hb_xvmPushFuncSymbol( symbols + 16 );
	hb_xvmPushLocal( 3 );
	hb_xvmPushStringConst( "InitClass", 9 );
	if( hb_xvmFunction( 2 ) ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmPushSymbol( symbols + 17 );
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
	hb_xvmPushSymbol( symbols + 15 );
	hb_xvmPushStatic( 1 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmRetValue();
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_TEXTLINE_NEW )
{
   HB_BOOL fValue;
   do {
	hb_xvmFrame( 1, 2 );
	hb_xvmModuleName( "src/HBTui_TextLine.prg:HBTUI_TEXTLINE_NEW" );
	hb_xvmLocalName( 1, "PARENT" );
	hb_xvmLocalName( 2, "TEXT" );
	hb_xvmSetLine( 21 );
	hb_xvmLocalName( 3, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 3 );
	hb_xvmSetLine( 22 );
	hb_xvmPushSymbol( symbols + 18 );
	hb_xvmPushSymbol( symbols + 19 );
	hb_xvmPushLocal( 3 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushLocal( 1 );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
	hb_xvmSetLine( 23 );
	hb_xvmPushLocal( 2 );
	hb_xvmPushNil();
	if( hb_xvmNotEqual() ) break;
	if( hb_xvmPopLogical( &fValue ) ) break;
	if( ! fValue )
		goto lab00001;
	hb_xvmSetLine( 24 );
	hb_xvmPushSymbol( symbols + 20 );
	hb_xvmPushLocal( 3 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 1 ) ) break;
	hb_stackPop();
lab00001: ;
	hb_xvmSetLine( 26 );
	hb_xvmPushLocal( 3 );
	hb_xvmRetValue();
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_STATIC( HBTUI_TEXTLINE_PAINTEVENT )
{
   do {
	hb_xvmFrame( 1, 1 );
	hb_xvmModuleName( "src/HBTui_TextLine.prg:HBTUI_TEXTLINE_PAINTEVENT" );
	hb_xvmLocalName( 1, "EVENT" );
	hb_xvmSetLine( 31 );
	hb_xvmLocalName( 2, "SELF" );
	hb_xvmPushSelf();
	hb_xvmPopLocal( 2 );
	hb_xvmSetLine( 33 );
	hb_xvmPushFuncSymbol( symbols + 21 );
	hb_xvmPushSymbol( symbols + 22 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	hb_xvmPushSymbol( symbols + 23 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmDo( 2 ) ) break;
	hb_xvmSetLine( 34 );
	hb_xvmPushFuncSymbol( symbols + 24 );
	hb_xvmPushSymbol( symbols + 25 );
	hb_xvmPushLocal( 2 );
	if( hb_xvmSend( 0 ) ) break;
	if( hb_xvmDo( 1 ) ) break;
	hb_xvmSetLine( 35 );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_INITSTATICS()
{
   do {
	hb_xvmStatics( symbols + 27, 1 );
	hb_xvmSFrame( symbols + 27 );
	hb_xvmModuleName( "src/HBTui_TextLine.prg:(_INITSTATICS)" );
	/* *** END PROC *** */
   } while( 0 );
}

HB_FUNC_INITLINES()
{
   do {
	hb_xvmModuleName( "src/HBTui_TextLine.prg:(_INITLINES)" );
	hb_xvmPushStringConst( "src/HBTui_TextLine.prg", 22 );
	hb_xvmPushInteger( 0 );
	hb_xvmPushStringConst( "\x80" "U\xE1\x85\x0E", 5 );
	hb_xvmArrayGen( 3 );
	hb_xvmArrayGen( 1 );
	hb_xvmRetValue();
	/* *** END PROC *** */
   } while( 0 );
}

