/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import "ShapeGeometry.h"
#import "LocationPoint.h"


@interface ShapePolygon : ShapeGeometry

@property (readonly) NSArray *interiors;

- (id)initWithCoordinates:(NSArray<LocationPoint*>*)coordinates;

@end
