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


/* focus policies */
#define HT_FOCUS_NONE               0
#define HT_FOCUS_TAB                1
#define HT_FOCUS_CLICK              2
#define HT_FOCUS_STRONG             3

#define HT_WIDGET                   0x00000000
#define HT_WINDOW                   0x00000001
#define HT_DIALOG                   hb_bitOr( 0x00000002, HT_WINDOW )
#define HT_SHEET                    hb_bitOr( 0x00000004, HT_WINDOW )
#define HT_POPUP                    hb_bitOr( 0x00000008, HT_WINDOW )
#define HT_TOOPTIP                  hb_bitOr( HT_POPUP, HT_SHEET )
#define HT_DESKTOP                  hb_bitOr( 0x00000010, HT_WINDOW )

/* theme color categories */
#define HT_CLR_WINDOW           1
#define HT_CLR_DESKTOP          2
#define HT_CLR_LABEL            3
#define HT_CLR_GET_NORMAL       4
#define HT_CLR_GET_FOCUSED      5
#define HT_CLR_GET_READONLY     6
#define HT_CLR_GET_LABEL        7
#define HT_CLR_BUTTON_NORMAL    8
#define HT_CLR_BUTTON_FOCUSED   9
#define HT_CLR_CHECK_NORMAL     10
#define HT_CLR_CHECK_FOCUSED    11
#define HT_CLR_LIST_NORMAL      12
#define HT_CLR_LIST_SELECTED    13
#define HT_CLR_LIST_SEL_UNFOC   14
#define HT_CLR_BROWSE_NORMAL    15
#define HT_CLR_BROWSE_FOCUSED   16
#define HT_CLR_MENU_BAR         17
#define HT_CLR_MENU_BAR_SEL     18
#define HT_CLR_MENU_ITEM        19
#define HT_CLR_MENU_ITEM_SEL    20
#define HT_CLR_STATUSBAR        21
#define HT_CLR_PROGRESS_FILL    22
#define HT_CLR_PROGRESS_EMPTY   23
#define HT_CLR_FRAME            24
#define HT_CLR_LINEEDIT_NORMAL  25
#define HT_CLR_LINEEDIT_FOCUSED 26
#define HT_CLR_LINEEDIT_SELECTED 27
#define HT_CLR_COMBO_NORMAL     28
#define HT_CLR_COMBO_FOCUSED    29
#define HT_CLR_COMBO_DROP_N     30
#define HT_CLR_COMBO_DROP_S     31
#define HT_CLR_TAB_ACTIVE       32
#define HT_CLR_TAB_INACTIVE     33
#define HT_CLR_TAB_BAR          34
#define HT_CLR_SPINNER_NORMAL   35
#define HT_CLR_SPINNER_FOCUSED  36
#define HT_CLR_TOOLBAR_NORMAL   37
#define HT_CLR_TOOLBAR_FOCUSED  38
#define HT_CLR_TOOLBAR_ACTIVE   39
#define HT_CLR_CHECKLIST_NORMAL 40
#define HT_CLR_CHECKLIST_SELECTED 41
#define HT_CLR_CHECKLIST_SELUNFOC 42
#define HT_CLR_MSGBOX_INFO      43
#define HT_CLR_MSGBOX_WARN      44
#define HT_CLR_MSGBOX_QUEST     45
#define HT_CLR_MENU_SEP         46
#define HT_CLR_SCROLLBAR        47
#define HT_CLR_CTXMENU_NORMAL  48
#define HT_CLR_CTXMENU_SELECTED 49
#define HT_CLR_CTXMENU_SEP     50
#define HT_CLR_MAX              50

/* alignment flags (can be combined with hb_bitOr) */
#define HT_ALIGN_LEFT           0
#define HT_ALIGN_CENTER         1
#define HT_ALIGN_HCENTER        1
#define HT_ALIGN_RIGHT          2
#define HT_ALIGN_TOP            0
#define HT_ALIGN_VCENTER        4
#define HT_ALIGN_BOTTOM         8

/* separator orientations */
#define HT_SEPARATOR_HORIZONTAL 0
#define HT_SEPARATOR_VERTICAL   1

#endif
