/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import "ShapePoint.h"
#import <geos/GEOSHelper.h>


@interface ShapePoint ()
{
@private
    CLLocationCoordinate2D _coordinate;
}
@end


@implementation ShapePoint

@synthesize coordinate = _coordinate;


-(id) initWithWKT:(NSString *)wkt
{
    if (( [super initWithWKT:wkt] ))
    {
        [self _extractCoordinatesFromGEOSGeom];
    }
    
    return self;
}

-(id) initWithWKB:(NSData*)wkb
{
    if (( [super initWithWKB:wkb] ))
    {
        [self _extractCoordinatesFromGEOSGeom];
    }
    
    return self;
}

-(id) initWithGeosGeometry:(GEOSGeometry*)geom
{
    if (( [super initWithGeosGeometry:geom] ))
    {
        [self _extractCoordinatesFromGEOSGeom];
    }
    
    return self;
}

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (( self = [super init] ))
    {
        GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
        assert(handle);
        
        GEOSCoordSequence *sequence = GEOSCoordSeq_create_r(handle, 1,2);

        GEOSCoordSeq_setX_r(handle, sequence, 0, coordinate.longitude);
        GEOSCoordSeq_setY_r(handle, sequence, 0, coordinate.latitude);
        
        GEOSGeometry *geosGeom = GEOSGeom_createPoint_r(handle, sequence);
        assert(geosGeom);
        
        NSAssert(geosGeom, @"Error creating ShapeKitPoint");
        
        [self setValue:(__bridge id _Nullable)(geosGeom) forKey:@"_geosHandle"];
    }
    
    return self;
}


#pragma mark - private


-(void) _extractCoordinatesFromGEOSGeom
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    assert(self.geosGeometry);
    GEOSCoordSequence *sequence = GEOSCoordSeq_clone_r(handle, GEOSGeom_getCoordSeq_r(handle, self.geosGeometry));
    assert(sequence);
    
    double x = 0.0;
    double y = 0.0f;

    GEOSCoordSeq_getX_r(handle, sequence, 0, &x);
    GEOSCoordSeq_getY_r(handle, sequence, 0, &y);
    
    _coordinate.latitude = y;
    _coordinate.longitude = x;
    
    GEOSCoordSeq_destroy_r(handle, sequence);
}

@end
