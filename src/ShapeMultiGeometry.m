/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import "ShapeMultiGeometry.h"

#import <geos/GEOSHelper.h>


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

-(id) initWithGeosGeometry:(void*)geom
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
    if (( self = [super init] ))
    {
        _geometries = [NSMutableArray new];
        [_geometries addObjectsFromArray:geometry];
    }
    
    return self;
}


#pragma mark - private

        
-(void) _loadSubGeometries
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    
    int numGeometries = GEOSGetNumGeometries_r(handle, self.geosHandle);

    for (int i=0; i<numGeometries; i++)
    {
        const GEOSGeometry *curGeom = GEOSGetGeometryN_r(handle, self.geosHandle, i);
        
        //TODO: memory leak?
        GEOSGeometry *geomCopy = GEOSGeom_clone_r(handle, curGeom);
        
        ShapeGeometry *geomObj = [ShapeGeometry geometryWithGeosGeometry:geomCopy];
        [_geometries addObject:geomObj];
    }
}

-(NSString*) description
{
    NSMutableString *geomsList = [NSMutableString new];
    
    NSInteger i = 1;

    for (ShapeGeometry*geom in self.geometries)
    {
        [geomsList appendFormat:@"\n     Geometry %i: %@", (int)i, geom.description];
        i += 1;
    }
    
    return [super.description stringByAppendingFormat: @"%@", geomsList];
}

@end
