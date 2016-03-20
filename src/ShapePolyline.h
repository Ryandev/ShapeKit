/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "ShapeGeometry.h"
#import "ShapePoint.h"
#import "LocationPoint.h"


@interface ShapePolyline : ShapeGeometry


-(id) initWithCoordinates:(NSArray<LocationPoint*>*)points;

/**
 @brief Returns the distance (float) from the origin of the geometry (LineString or MultiLineString) to the point projected on the geometry (that is to a point of the line the closest to the given point).*/
-(double) distanceFromOriginToProjectionOfPoint:(ShapePoint*)point;

/**
 @brief Returns the  distance as a float between 0 (origin) and 1 (endpoint) from the origin of the geometry (LineString or MultiLineString) to the point projected on the geometry (that is to a point of the line the closest to the given point).*/
-(double) normalizedDistanceFromOriginToProjectionOfPoint:(ShapePoint*)point;

/**
 @brief Returns the middle point of a ShapeKitPolyline */
-(ShapePoint*) middlePoint;

/**
 @brief Given a distance (double), returns the point (or closest point) within the geometry (LineString or MultiLineString) at that distance. */
-(ShapePoint*) interpolatePointAtDistance:(double)distance;

/**
 @brief Given a distance as a float between 0 (origin) and 1 (endpoint), returns the point (or closest point) within the geometry (LineString or MultiLineString) at that distance. */
-(ShapePoint*) interpolatePointAtNormalizedDistance:(double)fraction;


@end
