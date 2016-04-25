

#import "NSArray+GEOSGeometryCollection.h"
#import <geos/GEOSHelper.h>
#import "ShapeGeometry.h"


@implementation NSArray (GEOSGeometryCollection)


-(GEOSGeometry*) geometryCollection
{
    if ( self.count == 0 )
    {
        return nil;
    }
    
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    GEOSGeom *geomArray = malloc(sizeof(GEOSGeom*) * self.count);
    assert(geomArray);
    
    [self enumerateObjectsUsingBlock:^(NSValue *geom, NSUInteger idx, BOOL *stop)
    {
        if ( [geom isKindOfClass:[NSValue class]] )
        {
            geomArray[idx] = geom.pointerValue;
        }
        else if ( [geom isKindOfClass:[ShapeGeometry class]] )
        {
            geomArray[idx] = [(ShapeGeometry*)geom geosGeometry];
        }
        else
        {
            NSLog(@"Unexpected object in geometry array: %@",geom.description);
            assert(0);
        }
    }];
    
    int geomTypeItems = GEOSGeomTypeId_r(handle, geomArray[0]);
    int geomTypeCollection = GEOS_GEOMETRYCOLLECTION;

    switch (geomTypeItems)
    {
        case GEOS_POINT:
            geomTypeCollection = GEOS_MULTIPOINT;
            break;
            
        case GEOS_LINESTRING:
            geomTypeCollection = GEOS_MULTILINESTRING;
            break;
            
        case GEOS_POLYGON:
            geomTypeCollection = GEOS_MULTIPOLYGON;
            break;
            
        default:
            break;
    }

    GEOSGeometry *geomCollection = GEOSGeom_createCollection_r(handle, geomTypeCollection, geomArray, (int)self.count);
    assert(geomCollection);
    
    free(geomArray);

    return geomCollection;
}


@end
