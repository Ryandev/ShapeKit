/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import "ShapePolyline.h"

#import "GEOS.h"


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
    GEOSContextHandle_t handle = [GEOS sharedInstance].handle;
    
    GEOSCoordSequence *sequence = GEOSCoordSeq_create_r(handle, (unsigned int)points.count, 2);
    
    for (int i=0; i<points.count; i++)
    {
        LocationPoint *point = points[i];
        GEOSCoordSeq_setX_r(handle, sequence, i, point.longitude);
        GEOSCoordSeq_setY_r(handle, sequence, i, point.latitude);
    }

    void *geosGeom = GEOSGeom_createLineString_r(handle, sequence);
    
    self = [self initWithGeosGeometry:geosGeom];
    
    GEOSCoordSeq_destroy_r(handle, sequence);

    return self;
}


-(double) distanceFromOriginToProjectionOfPoint:(ShapePoint*)point
{
    GEOSContextHandle_t handle = [GEOS sharedInstance].handle;
    return GEOSProject_r(handle, self.geosHandle, point.geosHandle);
}

-(double) normalizedDistanceFromOriginToProjectionOfPoint:(ShapePoint*)point
{
    GEOSContextHandle_t handle = [GEOS sharedInstance].handle;
    return GEOSProjectNormalized_r(handle, self.geosHandle, point.geosHandle);
}

-(ShapePoint*) interpolatePointAtDistance:(double)distance
{
    GEOSContextHandle_t handle = [GEOS sharedInstance].handle;
    void *geom = GEOSInterpolate_r(handle, self.geosHandle, distance);
    ShapePoint *point = [[ShapePoint alloc] initWithGeosGeometry:geom];
    return point;
}

-(ShapePoint*) interpolatePointAtNormalizedDistance:(double)fraction
{
    GEOSContextHandle_t handle = [GEOS sharedInstance].handle;
    void *geom = GEOSInterpolateNormalized_r(handle, self.geosHandle, fraction);
    ShapePoint *point = [[ShapePoint alloc] initWithGeosGeometry:geom];
    return point;
}

-(ShapePoint*) middlePoint
{
    return [self interpolatePointAtNormalizedDistance:0.5];
}


#pragma mark - private


-(void) _loadCoordinatesFromGeos
{
    _geometries = [NSMutableArray new];
    
    GEOSContextHandle_t handle = [GEOS sharedInstance].handle;
    GEOSCoordSequence *sequence = GEOSCoordSeq_clone_r(handle, GEOSGeom_getCoordSeq_r(handle, self.geosHandle));
    
    unsigned int count = 0;
    
    GEOSCoordSeq_getSize_r(handle, sequence, &count);
    
    for (int i=0; i<count; i++)
    {
        double x = 0.0;
        double y = 0.0;

        GEOSCoordSeq_getX_r(handle, sequence, i, &x);
        GEOSCoordSeq_getY_r(handle, sequence, i, &y);
        
        [_geometries addObject:[LocationPoint pointWithCoordinate:CLLocationCoordinate2DMake(y, x)]];
    }
    
    GEOSCoordSeq_destroy_r(handle, sequence);
}

@end
