/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import "ShapeGeometry.h"


@interface ShapeMultiGeometry : ShapeGeometry

@property (nonatomic, readonly) NSArray <ShapeGeometry*> *geometries;

@end
