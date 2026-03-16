/** @class HTTheme
 * Singleton color theme manager. Provides named color categories for all widgets
 * and ships with four built-in themes: default, dark, high-contrast, and monochrome.
 */

#include "hbtui.ch"

SINGLETON CLASS HTTheme

PROTECTED:

    DATA FaColors

PUBLIC:

    CONSTRUCTOR new()

    METHOD getColor( nCategory )
    METHOD setColor( nCategory, cColor )
    METHOD loadDefault()
    METHOD loadDark()
    METHOD loadHighContrast()
    METHOD loadMono()

ENDCLASS

/** Creates the singleton instance and loads the default theme. */
METHOD new() CLASS HTTheme
    ::FaColors := Array( HT_CLR_MAX )
    ::loadDefault()
RETURN self

/** Returns the color string for a given category constant.
 * @param nCategory HT_CLR_* constant
 * @return Color string (e.g. "N/W"), or "N/W" if invalid
 */
METHOD FUNCTION getColor( nCategory ) CLASS HTTheme
    IF nCategory >= 1 .AND. nCategory <= HT_CLR_MAX
        RETURN ::FaColors[ nCategory ]
    ENDIF
    ht_debugLog( "HTTheme:getColor: invalid category " + hb_ntos( nCategory ) )
RETURN "N/W"

/** Sets the color string for a given category.
 * @param nCategory HT_CLR_* constant
 * @param cColor Color string (e.g. "15/01")
 */
METHOD PROCEDURE setColor( nCategory, cColor ) CLASS HTTheme
    IF nCategory >= 1 .AND. nCategory <= HT_CLR_MAX
        ::FaColors[ nCategory ] := cColor
    ENDIF
RETURN

/** Loads the standard light color theme. */
METHOD PROCEDURE loadDefault() CLASS HTTheme
    ::FaColors[ HT_CLR_WINDOW           ] := "11/09"
    ::FaColors[ HT_CLR_DESKTOP          ] := "03/01"
    ::FaColors[ HT_CLR_LABEL            ] := "11/09"
    ::FaColors[ HT_CLR_GET_NORMAL       ] := "N/W"
    ::FaColors[ HT_CLR_GET_FOCUSED      ] := "N/BG"
    ::FaColors[ HT_CLR_GET_READONLY     ] := "N+/W"
    ::FaColors[ HT_CLR_GET_LABEL        ] := "00/07"
    ::FaColors[ HT_CLR_BUTTON_NORMAL    ] := "00/07"
    ::FaColors[ HT_CLR_BUTTON_FOCUSED   ] := "15/01"
    ::FaColors[ HT_CLR_CHECK_NORMAL     ] := "00/07"
    ::FaColors[ HT_CLR_CHECK_FOCUSED    ] := "15/01"
    ::FaColors[ HT_CLR_LIST_NORMAL      ] := "N/W"
    ::FaColors[ HT_CLR_LIST_SELECTED    ] := "W+/B"
    ::FaColors[ HT_CLR_LIST_SEL_UNFOC   ] := "N/BG"
    ::FaColors[ HT_CLR_BROWSE_NORMAL    ] := "N/W,N/BG,B/W,B/W,B/GR"
    ::FaColors[ HT_CLR_BROWSE_FOCUSED   ] := "N/W,W+/B,B/W,B/W,B/GR"
    ::FaColors[ HT_CLR_MENU_BAR         ] := "00/07"
    ::FaColors[ HT_CLR_MENU_BAR_SEL     ] := "15/01"
    ::FaColors[ HT_CLR_MENU_ITEM        ] := "00/07"
    ::FaColors[ HT_CLR_MENU_ITEM_SEL    ] := "00/BG"
    ::FaColors[ HT_CLR_STATUSBAR        ] := "00/07"
    ::FaColors[ HT_CLR_PROGRESS_FILL    ] := "02/00"
    ::FaColors[ HT_CLR_PROGRESS_EMPTY   ] := "08/00"
    ::FaColors[ HT_CLR_FRAME            ] := "11/09"
    ::FaColors[ HT_CLR_LINEEDIT_NORMAL  ] := "N/W"
    ::FaColors[ HT_CLR_LINEEDIT_FOCUSED ] := "N/BG"
    ::FaColors[ HT_CLR_LINEEDIT_SELECTED ] := "N/GR+"
    ::FaColors[ HT_CLR_COMBO_NORMAL     ] := "N/W"
    ::FaColors[ HT_CLR_COMBO_FOCUSED    ] := "N/BG"
    ::FaColors[ HT_CLR_COMBO_DROP_N     ] := "N/W"
    ::FaColors[ HT_CLR_COMBO_DROP_S     ] := "W+/B"
    ::FaColors[ HT_CLR_TAB_ACTIVE       ] := "15/01"
    ::FaColors[ HT_CLR_TAB_INACTIVE     ] := "00/07"
    ::FaColors[ HT_CLR_TAB_BAR          ] := "00/07"
    ::FaColors[ HT_CLR_SPINNER_NORMAL   ] := "N/W"
    ::FaColors[ HT_CLR_SPINNER_FOCUSED  ] := "N/BG"
    ::FaColors[ HT_CLR_TOOLBAR_NORMAL   ] := "N/W"
    ::FaColors[ HT_CLR_TOOLBAR_FOCUSED  ] := "N/BG"
    ::FaColors[ HT_CLR_TOOLBAR_ACTIVE   ] := "W+/B"
    ::FaColors[ HT_CLR_CHECKLIST_NORMAL ] := "N/W"
    ::FaColors[ HT_CLR_CHECKLIST_SELECTED ] := "W+/B"
    ::FaColors[ HT_CLR_CHECKLIST_SELUNFOC ] := "N/BG"
    ::FaColors[ HT_CLR_MSGBOX_INFO      ] := "15/01"
    ::FaColors[ HT_CLR_MSGBOX_WARN      ] := "14/04"
    ::FaColors[ HT_CLR_MSGBOX_QUEST     ] := "15/05"
    ::FaColors[ HT_CLR_MENU_SEP         ] := "00/07"
    ::FaColors[ HT_CLR_SCROLLBAR        ] := "08/07"
    ::FaColors[ HT_CLR_CTXMENU_NORMAL  ] := "00/07"
    ::FaColors[ HT_CLR_CTXMENU_SELECTED ] := "00/BG"
    ::FaColors[ HT_CLR_CTXMENU_SEP     ] := "00/07"
RETURN

/** Loads the dark color theme. */
METHOD PROCEDURE loadDark() CLASS HTTheme
    ::FaColors[ HT_CLR_WINDOW           ] := "15/00"
    ::FaColors[ HT_CLR_DESKTOP          ] := "08/00"
    ::FaColors[ HT_CLR_LABEL            ] := "15/00"
    ::FaColors[ HT_CLR_GET_NORMAL       ] := "15/08"
    ::FaColors[ HT_CLR_GET_FOCUSED      ] := "14/01"
    ::FaColors[ HT_CLR_GET_READONLY     ] := "07/08"
    ::FaColors[ HT_CLR_GET_LABEL        ] := "15/00"
    ::FaColors[ HT_CLR_BUTTON_NORMAL    ] := "15/08"
    ::FaColors[ HT_CLR_BUTTON_FOCUSED   ] := "14/01"
    ::FaColors[ HT_CLR_CHECK_NORMAL     ] := "15/00"
    ::FaColors[ HT_CLR_CHECK_FOCUSED    ] := "14/01"
    ::FaColors[ HT_CLR_LIST_NORMAL      ] := "15/08"
    ::FaColors[ HT_CLR_LIST_SELECTED    ] := "14/01"
    ::FaColors[ HT_CLR_LIST_SEL_UNFOC   ] := "15/08"
    ::FaColors[ HT_CLR_BROWSE_NORMAL    ] := "15/08,14/01,11/08,11/08,03/08"
    ::FaColors[ HT_CLR_BROWSE_FOCUSED   ] := "15/08,14/01,11/08,11/08,03/08"
    ::FaColors[ HT_CLR_MENU_BAR         ] := "15/08"
    ::FaColors[ HT_CLR_MENU_BAR_SEL     ] := "14/01"
    ::FaColors[ HT_CLR_MENU_ITEM        ] := "15/08"
    ::FaColors[ HT_CLR_MENU_ITEM_SEL    ] := "14/01"
    ::FaColors[ HT_CLR_STATUSBAR        ] := "15/08"
    ::FaColors[ HT_CLR_PROGRESS_FILL    ] := "10/00"
    ::FaColors[ HT_CLR_PROGRESS_EMPTY   ] := "08/00"
    ::FaColors[ HT_CLR_FRAME            ] := "15/00"
    ::FaColors[ HT_CLR_LINEEDIT_NORMAL  ] := "15/08"
    ::FaColors[ HT_CLR_LINEEDIT_FOCUSED ] := "14/01"
    ::FaColors[ HT_CLR_LINEEDIT_SELECTED ] := "00/14"
    ::FaColors[ HT_CLR_COMBO_NORMAL     ] := "15/08"
    ::FaColors[ HT_CLR_COMBO_FOCUSED    ] := "14/01"
    ::FaColors[ HT_CLR_COMBO_DROP_N     ] := "15/08"
    ::FaColors[ HT_CLR_COMBO_DROP_S     ] := "14/01"
    ::FaColors[ HT_CLR_TAB_ACTIVE       ] := "14/01"
    ::FaColors[ HT_CLR_TAB_INACTIVE     ] := "15/08"
    ::FaColors[ HT_CLR_TAB_BAR          ] := "15/08"
    ::FaColors[ HT_CLR_SPINNER_NORMAL   ] := "15/08"
    ::FaColors[ HT_CLR_SPINNER_FOCUSED  ] := "14/01"
    ::FaColors[ HT_CLR_TOOLBAR_NORMAL   ] := "15/08"
    ::FaColors[ HT_CLR_TOOLBAR_FOCUSED  ] := "14/01"
    ::FaColors[ HT_CLR_TOOLBAR_ACTIVE   ] := "14/01"
    ::FaColors[ HT_CLR_CHECKLIST_NORMAL ] := "15/08"
    ::FaColors[ HT_CLR_CHECKLIST_SELECTED ] := "14/01"
    ::FaColors[ HT_CLR_CHECKLIST_SELUNFOC ] := "15/08"
    ::FaColors[ HT_CLR_MSGBOX_INFO      ] := "14/01"
    ::FaColors[ HT_CLR_MSGBOX_WARN      ] := "14/04"
    ::FaColors[ HT_CLR_MSGBOX_QUEST     ] := "14/05"
    ::FaColors[ HT_CLR_MENU_SEP         ] := "15/08"
    ::FaColors[ HT_CLR_SCROLLBAR        ] := "07/00"
    ::FaColors[ HT_CLR_CTXMENU_NORMAL  ] := "15/08"
    ::FaColors[ HT_CLR_CTXMENU_SELECTED ] := "14/01"
    ::FaColors[ HT_CLR_CTXMENU_SEP     ] := "15/08"
RETURN

/** Loads the high-contrast theme for accessibility. */
METHOD PROCEDURE loadHighContrast() CLASS HTTheme
    ::FaColors[ HT_CLR_WINDOW           ] := "15/00"
    ::FaColors[ HT_CLR_DESKTOP          ] := "07/00"
    ::FaColors[ HT_CLR_LABEL            ] := "15/00"
    ::FaColors[ HT_CLR_GET_NORMAL       ] := "15/00"
    ::FaColors[ HT_CLR_GET_FOCUSED      ] := "00/15"
    ::FaColors[ HT_CLR_GET_READONLY     ] := "07/00"
    ::FaColors[ HT_CLR_GET_LABEL        ] := "14/00"
    ::FaColors[ HT_CLR_BUTTON_NORMAL    ] := "15/00"
    ::FaColors[ HT_CLR_BUTTON_FOCUSED   ] := "00/15"
    ::FaColors[ HT_CLR_CHECK_NORMAL     ] := "15/00"
    ::FaColors[ HT_CLR_CHECK_FOCUSED    ] := "00/15"
    ::FaColors[ HT_CLR_LIST_NORMAL      ] := "15/00"
    ::FaColors[ HT_CLR_LIST_SELECTED    ] := "00/15"
    ::FaColors[ HT_CLR_LIST_SEL_UNFOC   ] := "00/07"
    ::FaColors[ HT_CLR_BROWSE_NORMAL    ] := "15/00,00/15,14/00,14/00,11/00"
    ::FaColors[ HT_CLR_BROWSE_FOCUSED   ] := "15/00,00/15,14/00,14/00,11/00"
    ::FaColors[ HT_CLR_MENU_BAR         ] := "15/00"
    ::FaColors[ HT_CLR_MENU_BAR_SEL     ] := "00/15"
    ::FaColors[ HT_CLR_MENU_ITEM        ] := "15/00"
    ::FaColors[ HT_CLR_MENU_ITEM_SEL    ] := "00/15"
    ::FaColors[ HT_CLR_STATUSBAR        ] := "14/00"
    ::FaColors[ HT_CLR_PROGRESS_FILL    ] := "15/00"
    ::FaColors[ HT_CLR_PROGRESS_EMPTY   ] := "08/00"
    ::FaColors[ HT_CLR_FRAME            ] := "15/00"
    ::FaColors[ HT_CLR_LINEEDIT_NORMAL  ] := "15/00"
    ::FaColors[ HT_CLR_LINEEDIT_FOCUSED ] := "00/15"
    ::FaColors[ HT_CLR_LINEEDIT_SELECTED ] := "00/14"
    ::FaColors[ HT_CLR_COMBO_NORMAL     ] := "15/00"
    ::FaColors[ HT_CLR_COMBO_FOCUSED    ] := "00/15"
    ::FaColors[ HT_CLR_COMBO_DROP_N     ] := "15/00"
    ::FaColors[ HT_CLR_COMBO_DROP_S     ] := "00/15"
    ::FaColors[ HT_CLR_TAB_ACTIVE       ] := "00/15"
    ::FaColors[ HT_CLR_TAB_INACTIVE     ] := "15/00"
    ::FaColors[ HT_CLR_TAB_BAR          ] := "15/00"
    ::FaColors[ HT_CLR_SPINNER_NORMAL   ] := "15/00"
    ::FaColors[ HT_CLR_SPINNER_FOCUSED  ] := "00/15"
    ::FaColors[ HT_CLR_TOOLBAR_NORMAL   ] := "15/00"
    ::FaColors[ HT_CLR_TOOLBAR_FOCUSED  ] := "00/15"
    ::FaColors[ HT_CLR_TOOLBAR_ACTIVE   ] := "00/15"
    ::FaColors[ HT_CLR_CHECKLIST_NORMAL ] := "15/00"
    ::FaColors[ HT_CLR_CHECKLIST_SELECTED ] := "00/15"
    ::FaColors[ HT_CLR_CHECKLIST_SELUNFOC ] := "00/07"
    ::FaColors[ HT_CLR_MSGBOX_INFO      ] := "15/00"
    ::FaColors[ HT_CLR_MSGBOX_WARN      ] := "14/00"
    ::FaColors[ HT_CLR_MSGBOX_QUEST     ] := "11/00"
    ::FaColors[ HT_CLR_MENU_SEP         ] := "15/00"
    ::FaColors[ HT_CLR_SCROLLBAR        ] := "15/00"
    ::FaColors[ HT_CLR_CTXMENU_NORMAL  ] := "15/00"
    ::FaColors[ HT_CLR_CTXMENU_SELECTED ] := "00/15"
    ::FaColors[ HT_CLR_CTXMENU_SEP     ] := "15/00"
RETURN

/** Loads the monochrome (grayscale) theme. */
METHOD PROCEDURE loadMono() CLASS HTTheme
    ::FaColors[ HT_CLR_WINDOW           ] := "07/00"
    ::FaColors[ HT_CLR_DESKTOP          ] := "08/00"
    ::FaColors[ HT_CLR_LABEL            ] := "07/00"
    ::FaColors[ HT_CLR_GET_NORMAL       ] := "07/00"
    ::FaColors[ HT_CLR_GET_FOCUSED      ] := "00/07"
    ::FaColors[ HT_CLR_GET_READONLY     ] := "08/00"
    ::FaColors[ HT_CLR_GET_LABEL        ] := "15/00"
    ::FaColors[ HT_CLR_BUTTON_NORMAL    ] := "15/00"
    ::FaColors[ HT_CLR_BUTTON_FOCUSED   ] := "00/07"
    ::FaColors[ HT_CLR_CHECK_NORMAL     ] := "15/00"
    ::FaColors[ HT_CLR_CHECK_FOCUSED    ] := "00/07"
    ::FaColors[ HT_CLR_LIST_NORMAL      ] := "07/00"
    ::FaColors[ HT_CLR_LIST_SELECTED    ] := "00/07"
    ::FaColors[ HT_CLR_LIST_SEL_UNFOC   ] := "00/08"
    ::FaColors[ HT_CLR_BROWSE_NORMAL    ] := "07/00,00/07,15/00,15/00,08/00"
    ::FaColors[ HT_CLR_BROWSE_FOCUSED   ] := "07/00,00/07,15/00,15/00,08/00"
    ::FaColors[ HT_CLR_MENU_BAR         ] := "15/00"
    ::FaColors[ HT_CLR_MENU_BAR_SEL     ] := "00/07"
    ::FaColors[ HT_CLR_MENU_ITEM        ] := "15/00"
    ::FaColors[ HT_CLR_MENU_ITEM_SEL    ] := "00/07"
    ::FaColors[ HT_CLR_STATUSBAR        ] := "15/00"
    ::FaColors[ HT_CLR_PROGRESS_FILL    ] := "15/00"
    ::FaColors[ HT_CLR_PROGRESS_EMPTY   ] := "08/00"
    ::FaColors[ HT_CLR_FRAME            ] := "07/00"
    ::FaColors[ HT_CLR_LINEEDIT_NORMAL  ] := "07/00"
    ::FaColors[ HT_CLR_LINEEDIT_FOCUSED ] := "00/07"
    ::FaColors[ HT_CLR_LINEEDIT_SELECTED ] := "00/15"
    ::FaColors[ HT_CLR_COMBO_NORMAL     ] := "07/00"
    ::FaColors[ HT_CLR_COMBO_FOCUSED    ] := "00/07"
    ::FaColors[ HT_CLR_COMBO_DROP_N     ] := "07/00"
    ::FaColors[ HT_CLR_COMBO_DROP_S     ] := "00/07"
    ::FaColors[ HT_CLR_TAB_ACTIVE       ] := "00/07"
    ::FaColors[ HT_CLR_TAB_INACTIVE     ] := "15/00"
    ::FaColors[ HT_CLR_TAB_BAR          ] := "15/00"
    ::FaColors[ HT_CLR_SPINNER_NORMAL   ] := "07/00"
    ::FaColors[ HT_CLR_SPINNER_FOCUSED  ] := "00/07"
    ::FaColors[ HT_CLR_TOOLBAR_NORMAL   ] := "07/00"
    ::FaColors[ HT_CLR_TOOLBAR_FOCUSED  ] := "00/07"
    ::FaColors[ HT_CLR_TOOLBAR_ACTIVE   ] := "00/07"
    ::FaColors[ HT_CLR_CHECKLIST_NORMAL ] := "07/00"
    ::FaColors[ HT_CLR_CHECKLIST_SELECTED ] := "00/07"
    ::FaColors[ HT_CLR_CHECKLIST_SELUNFOC ] := "00/08"
    ::FaColors[ HT_CLR_MSGBOX_INFO      ] := "15/00"
    ::FaColors[ HT_CLR_MSGBOX_WARN      ] := "15/00"
    ::FaColors[ HT_CLR_MSGBOX_QUEST     ] := "15/00"
    ::FaColors[ HT_CLR_MENU_SEP         ] := "15/00"
    ::FaColors[ HT_CLR_SCROLLBAR        ] := "07/00"
    ::FaColors[ HT_CLR_CTXMENU_NORMAL  ] := "15/00"
    ::FaColors[ HT_CLR_CTXMENU_SELECTED ] := "00/07"
    ::FaColors[ HT_CLR_CTXMENU_SEP     ] := "15/00"
RETURN
