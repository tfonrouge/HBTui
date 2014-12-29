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
    HBTui_UI_UnRefCountCopy
*/
HB_FUNC( HBTui_UI_UNREFCOUNTCOPY )
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
    HBTui_UI_RefCount
*/
HB_FUNC( HBTui_UI_REFCOUNT )
{
    PHB_ITEM pSelf = hb_param( 1, HB_IT_OBJECT );

    if( pSelf )
    {
        hb_retnl( hb_gcRefCount( hb_arrayId( pSelf ) ) );
    }
}

/*
    HBTui_UI_WIdAtMousePos
*/
HB_FUNC( HBTui_UI_WIDATMOUSEPOS )
{
    int x,y;
    hb_mouseGetPos( &x, &y );
    hb_retni( hb_ctwGetPosWindow( x, y ) );
}
