/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import <Foundation/Foundation.h>

#import "ShapeGeometry.h"
#import "ShapePoint.h"
#import "ShapePolygon.h"


/** @name Topological properties */
@interface ShapeGeometry (Topology)


/** 
 @brief Returns a ShapeKitPolygon that represents all points whose distance from this geometry is less than or equal to the given width.
 */
-(ShapePolygon*) bufferWithWidth:(double)width;

/** 
 @brief Returns the boundary as a newly allocated Geometry object. */
-(ShapeGeometry*) boundary;

/** 
 @brief Returns a ShapeKitPoint representing the geometric center of the geometry. The point is not guaranteed to be on the interior of the geometry. */
-(ShapePoint*) centroid;

/** 
 @brief Returns the smallest ShapeKitPolygon that contains all the points in the geometry.
 */
-(ShapePolygon*) convexHull;

/** 
 @brief Returns a ShapeKitPolygon that represents the bounding envelope of this geometry.
 */
-(ShapePolygon*) envelope;

/** 
 @brief Returns a ShapeKitPolygon that represents the bounding envelope of this geometry. */
-(ShapePoint*) pointOnSurface;

/** 
 @brief Returns the DE-9IM intersection matrix (a string) representing the topological relationship between this geometry and the other. */
-(NSString*) relationshipWithGeometry:(ShapeGeometry*)geometry;

/** 
 @brief Returns a ShapeGeometry representing the points shared by this geometry and other. */
-(ShapeGeometry*) intersectionWithGeometry:(ShapeGeometry*)geometry;

/** 
 @brief Returns a ShapeGeometry representing the points making up this geometry that do not make up other. */
-(ShapeGeometry*) differenceWithGeometry:(ShapeGeometry*)geometry;

/** 
 @brief Returns a ShapeGeometry representing all the points in this geometry and the other. */
-(ShapeGeometry*) unionWithGeometry:(ShapeGeometry*)geometry;

@end
