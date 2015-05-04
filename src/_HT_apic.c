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
    HB_WINDOWATMOUSEPOS
*/
HB_FUNC( HB_WINDOWATMOUSEPOS )
{
    int x,y;
    hb_mouseGetPos( &x, &y );
    hb_retni( hb_ctwGetPosWindow( x, y ) );
}

/*
    HT_ARRAYFROMID
*/
HB_FUNC( HT_ARRAYFROMID )
{
    void *pArrayId = hb_parptr( 1 );

    if ( pArrayId ) {
        PHB_ITEM pItem = hb_arrayFromId( NULL, pArrayId );
        hb_itemReturnRelease( pItem );
    }
}
