/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import "NSData+GEOS.h"
#import <geos/GEOSHelper.h>
#import "NSArray+GEOSGeometryCollection.h"


@implementation NSData (GEOS)


+(NSData*) dataWithGEOSGeom:(GEOSGeom)geosGeom
{
    assert(geosGeom);

    /* initialize geos geom if not already */
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    size_t len = 0;
    
    unsigned char *buffer = GEOSGeomToWKB_buf_r(handle, geosGeom, &len);
    
    NSData *data = [NSData dataWithBytes:buffer length:len];
    
    free(buffer);
    
    return data;
}

+(NSData*) dataWithGEOSGeoms:(NSArray<NSValue*>*)geosGeoms
{
    assert(geosGeoms);
    
    /* initialize geos geom if not already */
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    GEOSGeometry *geomCollection = geosGeoms.geometryCollection;
    
    NSData *data = [self dataWithGEOSGeom:geomCollection];
    
    GEOSFree_r(handle, geomCollection);
    
    return data;
}

-(GEOSGeom) geosGeometry
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    GEOSWKBReader *WKBReader = GEOSWKBReader_create_r(handle);
    assert(WKBReader);
    
    GEOSGeometry *geosGeom = GEOSWKBReader_read_r(handle, WKBReader, (unsigned char*)self.bytes, (size_t)self.length);
    assert(geosGeom);
    
    GEOSWKBReader_destroy_r(handle, WKBReader);
    
    return geosGeom;
}

-(int) geomTypeForWKB
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    GEOSWKBReader *WKBReader = GEOSWKBReader_create_r(handle);
    assert(WKBReader);
    
    GEOSGeometry *geosGeom = GEOSWKBReader_read_r(handle, WKBReader, self.bytes, self.length);
    assert(geosGeom);
    
    int geomTypeID = GEOSGeomTypeId_r(handle, geosGeom);

    GEOSWKBReader_destroy_r(handle, WKBReader);

    return geomTypeID;
}

@end
