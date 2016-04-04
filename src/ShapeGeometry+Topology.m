/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import "ShapeGeometry+Topology.h"

#import <geos/GEOSHelper.h>


@implementation ShapeGeometry (Topology)

-(ShapePolygon*) envelope
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    GEOSGeometry *geometryEnvelope = GEOSEnvelope_r(handle, self.geosHandle);
    assert(geometryEnvelope);
    
    ShapePolygon *polygon = [[ShapePolygon alloc] initWithGeosGeometry:geometryEnvelope];

    return polygon;
}

-(ShapePolygon*) bufferWithWidth:(double)width
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    GEOSGeometry *geometryBuffer = GEOSBuffer_r(handle, self.geosHandle, width, 0);
    assert(geometryBuffer);
    
    ShapePolygon *polygon = [[ShapePolygon alloc] initWithGeosGeometry:geometryBuffer];
    
    return polygon;
}

-(ShapePolygon*) convexHull
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    GEOSGeometry *geometryHull = GEOSConvexHull_r(handle, self.geosHandle);
    assert(geometryHull);
    
    ShapePolygon *polygon = [[ShapePolygon alloc] initWithGeosGeometry:geometryHull];
    
    return polygon;
}

-(NSString*) relationshipWithGeometry:(ShapeGeometry *)geometry
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    char *geometryRelate = GEOSRelate_r(handle, self.geosHandle, geometry.geosHandle);
    
    NSString *relationship = [NSString stringWithUTF8String:geometryRelate];
    
    return relationship;
}

-(ShapePoint*) centroid
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    GEOSGeometry *geometryCentroid = GEOSGetCentroid_r(handle, self.geosHandle);
    assert(geometryCentroid);
    
    ShapePoint *shapePoint = [[ShapePoint alloc] initWithGeosGeometry:geometryCentroid];
    
    return shapePoint;
}

-(ShapePoint*) pointOnSurface
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    GEOSGeometry *geometrySurface = GEOSPointOnSurface_r(handle, self.geosHandle);
    assert(geometrySurface);
    
    ShapePoint *point = [[ShapePoint alloc] initWithGeosGeometry:geometrySurface];

    return point;
}

-(ShapeGeometry*) intersectionWithGeometry:(ShapeGeometry *)geometryIntersect
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    GEOSGeometry *geometryIntersection = GEOSIntersection_r(handle, self.geosHandle, geometryIntersect.geosHandle);
    assert(geometryIntersection);
    
    ShapeGeometry *shape = [ShapeGeometry geometryWithGeosGeometry:geometryIntersection];
    
    return shape;
}

-(ShapeGeometry*) differenceWithGeometry:(ShapeGeometry *)geometry
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    GEOSGeometry *geometryDifference = GEOSDifference_r(handle, self.geosHandle, geometry.geosHandle);
    assert(geometryDifference);

    ShapeGeometry *shape = [ShapeGeometry geometryWithGeosGeometry:geometryDifference];
    
    return shape;
}

-(ShapeGeometry *)boundary
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    GEOSGeometry *geometryBoundary = GEOSBoundary_r(handle, self.geosHandle);
    assert(geometryBoundary);
    
    ShapeGeometry *shape = [ShapeGeometry geometryWithGeosGeometry:geometryBoundary];
    
    return shape;
}

-(ShapeGeometry *)unionWithGeometry:(ShapeGeometry *)geometry
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    GEOSGeometry *geometryUnion = GEOSUnion_r(handle, self.geosHandle, geometry.geosHandle);
    assert(geometryUnion);
    
    ShapeGeometry *shape = [ShapeGeometry geometryWithGeosGeometry:geometryUnion];
    
    return shape;
}

@end
