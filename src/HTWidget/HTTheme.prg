/*
 * HTTheme - Centralized color theme system
 *
 * Usage:
 *   HTTheme():setColor( HT_CLR_BUTTON_NORMAL, "00/07" )
 *   cColor := HTTheme():getColor( HT_CLR_BUTTON_NORMAL )
 *
 * Or use predefined themes:
 *   HTTheme():loadDark()
 *   HTTheme():loadLight()
 */

#include "hbtui.ch"

/* color category indices */
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
#define HT_CLR_MAX              24

SINGLETON CLASS HTTheme

PROTECTED:

    DATA FaColors

PUBLIC:

    CONSTRUCTOR new()

    METHOD getColor( nCategory )
    METHOD setColor( nCategory, cColor )
    METHOD loadDefault()
    METHOD loadDark()

ENDCLASS

/*
    new
*/
METHOD new() CLASS HTTheme
    ::FaColors := Array( HT_CLR_MAX )
    ::loadDefault()
RETURN self

/*
    getColor
*/
METHOD FUNCTION getColor( nCategory ) CLASS HTTheme
    IF nCategory >= 1 .AND. nCategory <= HT_CLR_MAX
        RETURN ::FaColors[ nCategory ]
    ENDIF
RETURN "N/W"

/*
    setColor
*/
METHOD PROCEDURE setColor( nCategory, cColor ) CLASS HTTheme
    IF nCategory >= 1 .AND. nCategory <= HT_CLR_MAX
        ::FaColors[ nCategory ] := cColor
    ENDIF
RETURN

/*
    loadDefault - standard light theme
*/
METHOD PROCEDURE loadDefault() CLASS HTTheme
    ::FaColors[ HT_CLR_WINDOW         ] := "11/09"
    ::FaColors[ HT_CLR_DESKTOP        ] := "03/01"
    ::FaColors[ HT_CLR_LABEL          ] := "11/09"
    ::FaColors[ HT_CLR_GET_NORMAL     ] := "N/W"
    ::FaColors[ HT_CLR_GET_FOCUSED    ] := "N/BG"
    ::FaColors[ HT_CLR_GET_READONLY   ] := "N+/W"
    ::FaColors[ HT_CLR_GET_LABEL      ] := "00/07"
    ::FaColors[ HT_CLR_BUTTON_NORMAL  ] := "00/07"
    ::FaColors[ HT_CLR_BUTTON_FOCUSED ] := "15/01"
    ::FaColors[ HT_CLR_CHECK_NORMAL   ] := "00/07"
    ::FaColors[ HT_CLR_CHECK_FOCUSED  ] := "15/01"
    ::FaColors[ HT_CLR_LIST_NORMAL    ] := "N/W"
    ::FaColors[ HT_CLR_LIST_SELECTED  ] := "W+/B"
    ::FaColors[ HT_CLR_LIST_SEL_UNFOC ] := "N/BG"
    ::FaColors[ HT_CLR_BROWSE_NORMAL  ] := "N/W,N/BG,B/W,B/W,B/GR"
    ::FaColors[ HT_CLR_BROWSE_FOCUSED ] := "N/W,W+/B,B/W,B/W,B/GR"
    ::FaColors[ HT_CLR_MENU_BAR       ] := "00/07"
    ::FaColors[ HT_CLR_MENU_BAR_SEL   ] := "15/01"
    ::FaColors[ HT_CLR_MENU_ITEM      ] := "00/07"
    ::FaColors[ HT_CLR_MENU_ITEM_SEL  ] := "00/BG"
    ::FaColors[ HT_CLR_STATUSBAR      ] := "00/07"
    ::FaColors[ HT_CLR_PROGRESS_FILL  ] := "02/00"
    ::FaColors[ HT_CLR_PROGRESS_EMPTY ] := "08/00"
    ::FaColors[ HT_CLR_FRAME          ] := "11/09"
RETURN

/*
    loadDark - dark theme variant
*/
METHOD PROCEDURE loadDark() CLASS HTTheme
    ::FaColors[ HT_CLR_WINDOW         ] := "15/00"
    ::FaColors[ HT_CLR_DESKTOP        ] := "08/00"
    ::FaColors[ HT_CLR_LABEL          ] := "15/00"
    ::FaColors[ HT_CLR_GET_NORMAL     ] := "15/08"
    ::FaColors[ HT_CLR_GET_FOCUSED    ] := "14/01"
    ::FaColors[ HT_CLR_GET_READONLY   ] := "07/08"
    ::FaColors[ HT_CLR_GET_LABEL      ] := "15/00"
    ::FaColors[ HT_CLR_BUTTON_NORMAL  ] := "15/08"
    ::FaColors[ HT_CLR_BUTTON_FOCUSED ] := "14/01"
    ::FaColors[ HT_CLR_CHECK_NORMAL   ] := "15/00"
    ::FaColors[ HT_CLR_CHECK_FOCUSED  ] := "14/01"
    ::FaColors[ HT_CLR_LIST_NORMAL    ] := "15/08"
    ::FaColors[ HT_CLR_LIST_SELECTED  ] := "14/01"
    ::FaColors[ HT_CLR_LIST_SEL_UNFOC ] := "15/08"
    ::FaColors[ HT_CLR_BROWSE_NORMAL  ] := "15/08,14/01,11/08,11/08,03/08"
    ::FaColors[ HT_CLR_BROWSE_FOCUSED ] := "15/08,14/01,11/08,11/08,03/08"
    ::FaColors[ HT_CLR_MENU_BAR       ] := "15/08"
    ::FaColors[ HT_CLR_MENU_BAR_SEL   ] := "14/01"
    ::FaColors[ HT_CLR_MENU_ITEM      ] := "15/08"
    ::FaColors[ HT_CLR_MENU_ITEM_SEL  ] := "14/01"
    ::FaColors[ HT_CLR_STATUSBAR      ] := "15/08"
    ::FaColors[ HT_CLR_PROGRESS_FILL  ] := "10/00"
    ::FaColors[ HT_CLR_PROGRESS_EMPTY ] := "08/00"
    ::FaColors[ HT_CLR_FRAME          ] := "15/00"
RETURN
