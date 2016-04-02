/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import "ShapeGeometry+Topology.h"

#import <geos/GEOSHelper.h>


@implementation ShapeGeometry (Topology)

-(ShapePolygon*)envelope
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    return [[ShapePolygon alloc] initWithGeosGeometry:GEOSEnvelope_r(handle, self.geosHandle)];
}

-(ShapePolygon*)bufferWithWidth:(double)width
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    return [[ShapePolygon alloc] initWithGeosGeometry:GEOSBuffer_r(handle, self.geosHandle, width, 0)];
}

-(ShapePolygon*)convexHull
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    return [[ShapePolygon alloc] initWithGeosGeometry:GEOSConvexHull_r(handle, self.geosHandle)];
}

-(NSString*)relationshipWithGeometry:(ShapeGeometry *)geometry
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    return [NSString stringWithUTF8String:GEOSRelate_r(handle, self.geosHandle, geometry.geosHandle)];
}

-(ShapePoint*)centroid
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    return [[ShapePoint alloc] initWithGeosGeometry:GEOSGetCentroid_r(handle, self.geosHandle)];
}

-(ShapePoint*)pointOnSurface
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    return [[ShapePoint alloc] initWithGeosGeometry:GEOSPointOnSurface_r(handle, self.geosHandle)];
}

-(ShapeGeometry*) intersectionWithGeometry:(ShapeGeometry *)geometry
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    return [ShapeGeometry geometryWithGeosGeometry:GEOSIntersection_r(handle, self.geosHandle, geometry.geosHandle)];
}

-(ShapeGeometry*) differenceWithGeometry:(ShapeGeometry *)geometry
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    return [ShapeGeometry geometryWithGeosGeometry:GEOSDifference_r(handle, self.geosHandle, geometry.geosHandle)];
}

-(ShapeGeometry *)boundary
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    return [ShapeGeometry geometryWithGeosGeometry:GEOSBoundary_r(handle, self.geosHandle)];
}

-(ShapeGeometry *)unionWithGeometry:(ShapeGeometry *)geometry
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    return [ShapeGeometry geometryWithGeosGeometry:GEOSUnion_r(handle, self.geosHandle, geometry.geosHandle)];
}

@end
