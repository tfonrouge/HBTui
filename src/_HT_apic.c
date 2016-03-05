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
    ht_objectFromId
*/
HB_FUNC( HT_OBJECTFROMID )
{
    void *pObjectId = hb_parptr( 1 );

    if ( pObjectId ) {
        PHB_ITEM pItem = hb_arrayFromId( NULL, pObjectId );
        if( hb_arrayIsObject( pItem ) ) {
            hb_itemReturnRelease( pItem );
        }
        else {
            hb_itemRelease( pItem );
        }
    }
}

/*
    ht_objectId
*/
HB_FUNC( HT_OBJECTID )
{
    PHB_ITEM pItem = hb_param( 1, HB_IT_ARRAY );

    if( pItem && hb_arrayIsObject( pItem ) )
    {
        hb_retptr( hb_arrayId( pItem ) );
    }
}

/*
    ht_windowAtMousePos
*/
HB_FUNC( HB_WINDOWATMOUSEPOS )
{
    int x,y;

    hb_mouseGetPos( &x, &y );
    hb_retni( hb_ctwGetPosWindow( x, y ) );
}
