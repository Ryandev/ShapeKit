/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import "ShapeMultiGeometry.h"

#import "GEOS.h"


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
        [self _loadSubGeometries];
    }
    
    return self;
}

-(id) initWithWKB:(NSData*)wkb
{
    if (( self = [super initWithWKB:wkb] ))
    {
        [self _loadSubGeometries];
    }
    
    return self;
}

-(id) initWithGeosGeometry:(void*)geom
{
    if (( [super initWithGeosGeometry:geom] ))
    {
        [self _loadSubGeometries];
    }
    
    return self;
}


#pragma mark - private

        
-(void) _loadSubGeometries
{
    GEOSContextHandle_t handle = [GEOS sharedInstance].handle;
    
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
    
    int i=0;

    for (ShapeGeometry*geom in self.geometries)
    {
        [geomsList appendFormat:@"\n     Geometry %i: %@", ++i, [geom description]];
    }
    
    return [super.description stringByAppendingFormat: @"%@", geomsList];
}

@end
