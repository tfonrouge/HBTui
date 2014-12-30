/*
 *
 */

#include "hbvmint.h"
#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"

#include "ctwin.h"
#include "hbapigt.h"

/*
    HBTUI_UI_UnRefCountCopy
*/
HB_FUNC( HBTUI_UI_UNREFCOUNTCOPY )
{
    PHB_ITEM pSelf = hb_param( 1, HB_IT_OBJECT );

    if( pSelf )
    {
        PHB_ITEM pNew = hb_itemNew( pSelf );
//        hb_itemRawCpy( pNew, pSelf );
//        pNew->type &= ~HB_IT_DEFAULT;
        hb_itemReturnRelease( pNew );
    }
}

/*
    HBTUI_UI_RefCount
*/
HB_FUNC( HBTUI_UI_REFCOUNT )
{
    PHB_ITEM pSelf = hb_param( 1, HB_IT_OBJECT );

    if( pSelf )
    {
        hb_retnl( hb_gcRefCount( hb_arrayId( pSelf ) ) );
    }
}

/*
    HBTUI_UI_WIdAtMousePos
*/
HB_FUNC( HBTUI_UI_WIDATMOUSEPOS )
{
    int x,y;
    hb_mouseGetPos( &x, &y );
    hb_retni( hb_ctwGetPosWindow( x, y ) );
}
