/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import "NSString+GEOS.h"
#import "GEOS.h"


@implementation NSString (GEOS)

+(NSString*) stringWithGEOSGeom:(GEOSGeom)geosGeom
{
    GEOSContextHandle_t handle = [GEOS sharedInstance].handle;

    GEOSWKTWriter *WKTWriter = GEOSWKTWriter_create_r(handle);
    char *wktString = GEOSWKTWriter_write_r(handle, WKTWriter, geosGeom);
    
    id str = [[NSString alloc] initWithUTF8String:wktString];

    GEOSWKTWriter_destroy_r(handle, WKTWriter);
    
    return str;
}

-(GEOSGeom) geosGeom
{
    GEOSContextHandle_t handle = [GEOS sharedInstance].handle;
    
    GEOSWKTReader *WKTReader = GEOSWKTReader_create_r(handle);
    GEOSGeom geosGeom = GEOSWKTReader_read_r(handle, WKTReader, self.UTF8String);

    GEOSWKTReader_destroy_r(handle, WKTReader);
    
    return geosGeom;
}

-(int) geomTypeForWKT
{
    GEOSContextHandle_t handle = [GEOS sharedInstance].handle;
    
    GEOSWKTReader *WKTReader = GEOSWKTReader_create_r(handle);
    GEOSGeom geosGeom = GEOSWKTReader_read_r(handle, WKTReader, self.UTF8String);
    
    int geomTypeID = GEOSGeomTypeId_r([GEOS sharedInstance].handle, geosGeom);
    
    GEOSWKTReader_destroy_r(handle, WKTReader);
    
    return geomTypeID;
    
}

@end
