/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import "ShapePolyline.h"

#import <geos/GEOSHelper.h>


@interface ShapePolyline ()
{
@private
    NSMutableArray *_geometries;
}
@end

@implementation ShapePolyline

-(NSArray*) coordinates
{
    return _geometries;
}

-(id) initWithWKT:(NSString*)wkt
{
    if (( [super initWithWKT:wkt] ))
    {
        [self _loadCoordinatesFromGeos];
    }
    
    return self;
}

-(id) initWithWKB:(NSData*)wkb
{
    if (( [super initWithWKB:wkb] ))
    {
        [self _loadCoordinatesFromGeos];
    }

    return self;
}

-(id) initWithGeosGeometry:(void*)geom
{
    if (( [super initWithGeosGeometry:geom] ))
    {
        [self _loadCoordinatesFromGeos];
    }

    return self;
}

-(id) initWithCoordinates:(NSArray<LocationPoint*>*)points
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    GEOSCoordSequence *sequence = GEOSCoordSeq_create_r(handle, (unsigned int)points.count, 2);
    assert(sequence);
    
    for (int i=0; i<points.count; i++)
    {
        LocationPoint *point = points[i];

        GEOSCoordSeq_setX_r(handle, sequence, i, point.longitude);
        GEOSCoordSeq_setY_r(handle, sequence, i, point.latitude);
    }

    void *geosGeom = GEOSGeom_createLineString_r(handle, sequence);
    assert(geosGeom);
    
    self = [self initWithGeosGeometry:geosGeom];
    
    GEOSCoordSeq_destroy_r(handle, sequence);

    return self;
}


-(double) distanceFromOriginToProjectionOfPoint:(ShapePoint*)point
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    double distance = GEOSProject_r(handle, self.geosHandle, point.geosHandle);
    
    return distance;
}

-(double) normalizedDistanceFromOriginToProjectionOfPoint:(ShapePoint*)point
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    double distance = GEOSProjectNormalized_r(handle, self.geosHandle, point.geosHandle);
    
    return distance;
}

-(ShapePoint*) interpolatePointAtDistance:(double)distance
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    void *geom = GEOSInterpolate_r(handle, self.geosHandle, distance);
    assert(geom);

    ShapePoint *point = [[ShapePoint alloc] initWithGeosGeometry:geom];

    return point;
}

-(ShapePoint*) interpolatePointAtNormalizedDistance:(double)fraction
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    void *geom = GEOSInterpolateNormalized_r(handle, self.geosHandle, fraction);
    assert(geom);

    ShapePoint *point = [[ShapePoint alloc] initWithGeosGeometry:geom];

    return point;
}

-(ShapePoint*) middlePoint
{
    ShapePoint *midPoint = [self interpolatePointAtNormalizedDistance:0.5f];
    return midPoint;
}


#pragma mark - private


-(void) _loadCoordinatesFromGeos
{
    _geometries = [NSMutableArray new];
    
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    GEOSCoordSequence *sequence = GEOSCoordSeq_clone_r(handle, GEOSGeom_getCoordSeq_r(handle, self.geosHandle));
    assert(sequence);
    
    unsigned int count = 0;
    
    GEOSCoordSeq_getSize_r(handle, sequence, &count);
    
    for (int i=0; i<count; i++)
    {
        double x = 0.0;
        double y = 0.0;

        GEOSCoordSeq_getX_r(handle, sequence, i, &x);
        GEOSCoordSeq_getY_r(handle, sequence, i, &y);

        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(y, x);

        [_geometries addObject:[LocationPoint pointWithCoordinate:coord]];
    }
    
    GEOSCoordSeq_destroy_r(handle, sequence);
}

@end
