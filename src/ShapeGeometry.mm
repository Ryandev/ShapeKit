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


@implementation ShapeGeometry

@dynamic wkt;

-(NSString*) wkt
{
    assert(_geosGeometry);
    return [NSString stringWithGEOSGeom:_geosGeometry];
}

@dynamic wkb;

-(NSData*) wkb
{
    assert(_geosGeometry);
    return [NSData dataWithGEOSGeom:_geosGeometry];
}

@synthesize geomType = _geomType;
@synthesize geosGeometry = _geosGeometry;
@synthesize coordinates = _coordinates;


-(id) initWithWKB:(NSData*)wkb
{
    if (( self = [super init] ))
    {
        _coordinates = [NSMutableArray new];

        _geosGeometry = wkb.geosGeometry;
        assert(_geosGeometry);

        [self _loadGeomType];
    }
    
    return self;
}

-(id) initWithWKT:(NSString*)wkt
{
    if (( self = [super init] ))
    {
        _coordinates = [NSMutableArray new];

        _geosGeometry = wkt.geosGeometry;
        assert(_geosGeometry);
        
        [self _loadGeomType];
    }
    
    return self;
}

-(id) initWithGeosGeometry:(GEOSGeometry*)geom
{
    if (( self = [super init] ))
    {
        _coordinates = [NSMutableArray new];

        GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
        assert(handle);

        _geosGeometry = GEOSGeom_clone_r(handle, geom);
        assert(_geosGeometry);

        [self _loadGeomType];
    }

    return self;    
}

-(void) dealloc
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);

    if ( _geosGeometry )
    {
        GEOSGeom_destroy_r(handle, _geosGeometry);
        _geosGeometry = nil;
    }
}

+(instancetype) geometryWithWKT:(NSString*)wkt
{
    Class classLoad = [self.class _classForGeometry:wkt.geomTypeForWKT];
    
    id instance = nil;
    
    if ( classLoad )
    {
        instance = [[classLoad alloc] initWithGeosGeometry:wkt.geosGeometry];
    }
    
    return instance;
}

+(instancetype) geometryWithWKB:(NSData*)wkb
{
    Class classLoad = [self.class _classForGeometry:wkb.geomTypeForWKB];
    
    id instance = nil;
    
    if ( classLoad )
    {
        instance = [[classLoad alloc] initWithGeosGeometry:wkb.geosGeometry];
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
    assert(handle);

    assert(self.geosGeometry);
    char *typeString = GEOSGeomType_r(handle, self.geosGeometry);
    
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
