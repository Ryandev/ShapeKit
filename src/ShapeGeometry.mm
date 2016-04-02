/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import "ShapeGeometry.h"

#import <geos/geos_c.h>
#import <geos/GEOSHelper.h>
#import <proj4/proj4.h>

#import "ShapePoint.h"
#import "ShapePolyline.h"
#import "ShapePolygon.h"
#import "ShapeMultiGeometry.h"
#import "LocationPoint.h"
#import "NSData+GEOS.h"
#import "NSString+GEOS.h"


@interface ShapeGeometry ()
{
@protected
    GEOSGeometry *_geosHandle;
    NSMutableArray <LocationPoint*> *_coordinates;
}

@property (readwrite, copy) NSString *geomType;
@property (readwrite, copy) NSString *projDefinition;

@property (readwrite) GEOSGeometry *geosGeom;
@property (readwrite) CLLocationCoordinate2D *coords;
@property (readwrite) id geometry;

@end


@implementation ShapeGeometry

@dynamic wkt;

-(NSString*) wkt
{
    return [NSString stringWithGEOSGeom:_geosHandle];
}

@dynamic wkb;

-(NSData*) wkb
{
    return [NSData dataWithGEOSGeom:_geosHandle];
}

@synthesize geomType = _geomType;
@synthesize geosHandle = _geosHandle;
@synthesize coordinates = _coordinates;


-(id) initWithWKB:(NSData*)wkb
{
    if (( self = [super init] ))
    {
        _coordinates = [NSMutableArray new];
        _geosHandle = wkb.geosGeom;
        [self _loadGeomType];
    }
    
    return self;
}

-(id) initWithWKT:(NSString*)wkt
{
    if (( self = [super init] ))
    {
        _coordinates = [NSMutableArray new];
        _geosHandle = wkt.geosGeom;
        [self _loadGeomType];
    }
    
    return self;
}

-(id) initWithGeosGeometry:(void*)geom
{
    if (( self = [super init] ))
    {
        _coordinates = [NSMutableArray new];
        _geosHandle = (GEOSGeometry*)geom;
        [self _loadGeomType];
    }
    return self;    
}

-(void) dealloc
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    GEOSGeom_destroy_r(handle, _geosHandle);
}

+(instancetype) geometryWithWKT:(NSString*)wkt
{
    Class classLoad = [self.class _classForGeometry:wkt.geomTypeForWKT];
    
    id instance = nil;
    
    if ( classLoad )
    {
        instance = [[classLoad alloc] initWithGeosGeometry:wkt.geosGeom];
    }
    
    return instance;
}

+(instancetype) geometryWithWKB:(NSData*)wkb
{
    Class classLoad = [self.class _classForGeometry:wkb.geomTypeForWKB];
    
    id instance = nil;
    
    if ( classLoad )
    {
        instance = [[classLoad alloc] initWithGeosGeometry:wkb.geosGeom];
    }
    
    return instance;
}

+(instancetype) geometryWithGeosGeometry:(GEOSGeometry*)geosGeom
{
    int type = [self.class _geomTypeForGEOSGeom:geosGeom];
    Class classLoad = [self.class _classForGeometry:type];
    
    id instance = nil;
    
    if ( classLoad )
    {
        instance = [[classLoad alloc] initWithGeosGeometry:geosGeom];
    }
    
    return instance;
}


#pragma mark - private


-(void) _loadGeomType
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    char *typeString = GEOSGeomType_r(handle, self.geosGeom);
    _geomType = [[NSString alloc] initWithUTF8String:typeString];
    free(typeString);
}

+(Class) _classForGeometry:(int)geomTypeId
{
    Class geomClass = nil;
    
    switch (geomTypeId)
    {
        case GEOS_POINT:
            geomClass = [ShapePoint class];
            break;

        case GEOS_LINESTRING:
            geomClass = [ShapePolyline class];
            break;

        case GEOS_LINEARRING:
            break;

        case GEOS_POLYGON:
            geomClass = [ShapePolygon class];
            break;

        case GEOS_MULTIPOINT:
        case GEOS_MULTILINESTRING:
        case GEOS_MULTIPOLYGON:
        case GEOS_GEOMETRYCOLLECTION:
            geomClass = [ShapeMultiGeometry class];
            break;

        default:
            NSLog(@"Unknown geometry type: %d",geomTypeId);
            break;
    }
    
    return geomClass;
}

+(int) _geomTypeForGEOSGeom:(GEOSGeom)geosGeom
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    int geomTypeID = GEOSGeomTypeId_r([GEOSHelper sharedInstance].handle, geosGeom);
    return geomTypeID;
}

-(NSString*) description
{
    __block NSMutableString *pointsList = [NSMutableString new];
    
    [self.coordinates enumerateObjectsUsingBlock:^(LocationPoint *point, NSUInteger idx, BOOL *stop)
    {
        [pointsList appendFormat:@"[%.4f, %.4f] ", point.latitude, point.longitude];
    }];
    
    return [[super description] stringByAppendingFormat: @"%@", pointsList];
}


@end
