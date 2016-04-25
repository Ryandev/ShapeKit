/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import "NSString+GEOS.h"
#import <geos/GEOSHelper.h>


@implementation NSString (GEOS)

+(NSString*) stringWithGEOSGeom:(GEOSGeom)geosGeom
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);

    GEOSWKTWriter *WKTWriter = GEOSWKTWriter_create_r(handle);
    char *wktString = GEOSWKTWriter_write_r(handle, WKTWriter, geosGeom);
    
    NSString *string = nil;
    
    if ( wktString )
    {
        string = [[NSString alloc] initWithUTF8String:wktString];
    }

    GEOSWKTWriter_destroy_r(handle, WKTWriter);
    
    return string;
}

-(GEOSGeom) geosGeometry
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    GEOSWKTReader *WKTReader = GEOSWKTReader_create_r(handle);
    GEOSGeom geosGeom = GEOSWKTReader_read_r(handle, WKTReader, self.UTF8String);
    assert(geosGeom);
    
    GEOSWKTReader_destroy_r(handle, WKTReader);
    
    return geosGeom;
}

-(int) geomTypeForWKT
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    GEOSWKTReader *WKTReader = GEOSWKTReader_create_r(handle);
    GEOSGeom geosGeom = GEOSWKTReader_read_r(handle, WKTReader, self.UTF8String);
    assert(geosGeom);
    
    int geomTypeID = GEOSGeomTypeId_r(handle, geosGeom);
    
    GEOSWKTReader_destroy_r(handle, WKTReader);
    
    return geomTypeID;
    
}

@end
