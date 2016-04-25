/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import "ShapeMultiGeometry.h"

#import <geos/GEOSHelper.h>

#import "NSArray+GEOSGeometryCollection.h"


@interface ShapeMultiGeometry ()
{
@private
    NSMutableArray *_geometries;
}
@end


@implementation ShapeMultiGeometry

@synthesize geometries = _geometries;

-(id) init
{
    if (( self = [super init] ))
    {
        _geometries = [NSMutableArray new];
    }

    return self;
}
        
-(id) initWithWKT:(NSString *)wkt
{
    if (( [super initWithWKT:wkt] ))
    {
        _geometries = [NSMutableArray new];
        [self _loadSubGeometries];
    }
    
    return self;
}

-(id) initWithWKB:(NSData*)wkb
{
    if (( self = [super initWithWKB:wkb] ))
    {
        _geometries = [NSMutableArray new];
        [self _loadSubGeometries];
    }
    
    return self;
}

-(id) initWithGeosGeometry:(GEOSGeometry*)geom
{
    if (( [super initWithGeosGeometry:geom] ))
    {
        _geometries = [NSMutableArray new];
        [self _loadSubGeometries];
    }
    
    return self;
}

-(id) initWithShapeGeometries:(NSArray<ShapeGeometry*>*)geometry
{
    assert([geometry isKindOfClass:[NSArray class]]);

    GEOSGeometry *geom = geometry.geometryCollection;
    assert(geom);

    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    GEOSGeometry *geom_clone = GEOSGeom_clone_r(handle, geom);
    
    id instance = [self initWithGeosGeometry:geom_clone];
    assert(instance);

    return instance;
}


#pragma mark - private

        
-(void) _loadSubGeometries
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    assert(self.geosGeometry);
    int count = GEOSGetNumGeometries_r(handle, self.geosGeometry);

    for (int i=0; i<count; i++)
    {
        const GEOSGeometry *curGeom = GEOSGetGeometryN_r(handle, self.geosGeometry, i);
        assert(curGeom);
        
        //TODO: memory leak?
        GEOSGeometry *geomCopy = GEOSGeom_clone_r(handle, curGeom);
        assert(geomCopy);
        
        ShapeGeometry *geomObj = [ShapeGeometry geometryWithGeosGeometry:geomCopy];

        [_geometries addObject:geomObj];
    }
}

-(NSString*) description
{
    NSMutableString *geomsList = [NSMutableString new];
    
    [self.geometries enumerateObjectsUsingBlock:^(ShapeGeometry *geom, NSUInteger idx, BOOL *stop)
    {
        [geomsList appendFormat:@"\n     Geometry %i: %@", (int)idx, geom.description];
    }];
    
    return [super.description stringByAppendingFormat: @"%@", geomsList];
}

@end
