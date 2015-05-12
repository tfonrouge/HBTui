/*
 *
 */

#include "hbclass.ch"
#include "property.ch"

#ifndef __HBTUI_INC__
#define __HBTUI_INC__

#define HBTUI_UI_STACK_EVENT_SIZE           128

#define HT_EVENT_TYPE_NULL          0
#define HT_EVENT_TYPE_CLOSE         1
#define HT_EVENT_TYPE_FOCUSIN       2
#define HT_EVENT_TYPE_FOCUSOUT      3
#define HT_EVENT_TYPE_KEYBOARD      4
#define HT_EVENT_TYPE_MOUSE         5
#define HT_EVENT_TYPE_MOVE          6
#define HT_EVENT_TYPE_PAINT         7
#define HT_EVENT_TYPE_RESIZE        8
#define HT_EVENT_TYPE_HIDE          9
#define HT_EVENT_TYPE_MAXIMIZE      10
#define HT_EVENT_TYPE_SHOW          11

#define HT_EVENT_PRIORITY_HIGH      1
#define HT_EVENT_PRIORITY_NORMAL    2
#define HT_EVENT_PRIORITY_LOW       3


#define HT_WIDGET                   0x00000000
#define HT_WINDOW                   0x00000001
#define HT_DIALOG                   hb_bitOr( 0x00000002, HT_WINDOW )
#define HT_SHEET                    hb_bitOr( 0x00000004, HT_WINDOW )
#define HT_POPUP                    hb_bitOr( 0x00000008, HT_WINDOW )
#define HT_TOOPTIP                  hb_bitOr( HT_POPUP, HT_SHEET )
#define HT_DESKTOP                  hb_bitOr( 0x00000010, HT_WINDOW )

#endif
