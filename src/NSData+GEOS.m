/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import "NSData+GEOS.h"
#import <geos/GEOSHelper.h>


@implementation NSData (GEOS)


+(NSData*) dataWithGEOSGeom:(GEOSGeom)geosGeom
{
    /* initialize geos geom if not already */
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    size_t len = 0;
    
    unsigned char *buffer = GEOSGeomToWKB_buf(geosGeom, &len);
    
    NSData *data = [NSData dataWithBytes:buffer length:len];
    
    free(buffer);
    
    return data;
}

-(GEOSGeom) geosGeom
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    GEOSWKBReader *WKBReader = GEOSWKBReader_create_r(handle);
    
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
    GEOSGeometry *geosGeom = GEOSWKBReader_read_r(handle, WKBReader, self.bytes, self.length);
    assert(geosGeom);
    
    int geomTypeID = GEOSGeomTypeId_r(handle, geosGeom);

    GEOSWKBReader_destroy_r(handle, WKBReader);

    return geomTypeID;
}

@end
