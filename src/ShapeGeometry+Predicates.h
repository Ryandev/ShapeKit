/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import <Foundation/Foundation.h>

#import "ShapeGeometry.h"


/** @name Spatial predicates methods
 * All of the following spatial predicate methods take another GEOSGeometry instance (other) as a parameter, and return a boolean.
 */
@interface ShapeGeometry (Predicates)


/** 
 @brief Returns TRUE if the DE-9IM intersection matrix for the two geometries is "FF*FF****".
 */
-(bool) isDisjointFromGeometry:(ShapeGeometry*)compareGeometry;

/** 
 @brief Returns TRUE if the DE-9IM intersection matrix for the two geometries is "FT*******", "F**T*****" or "F***T****".
 */
-(bool) touchesGeometry:(ShapeGeometry*)compareGeometry;

/** 
 @brief Returns TRUE if isDisjointFromGeometry is FALSE.
 */
-(bool) intersectsGeometry:(ShapeGeometry*)compareGeometry;

/** 
  @brief Returns TRUE if the DE-9IM intersection matrix for the two Geometries is "T*T******" (for a point and a curve,a point and an area or a line and an area) 0******** (for two curves).
 */
-(bool) crossesGeometry:(ShapeGeometry*)compareGeometry;

/** 
 @brief Returns TRUE if the DE-9IM intersection matrix for the two geometries is "T*F**F***".
*/
-(bool) isWithinGeometry:(ShapeGeometry*)compareGeometry;

/** Returns TRUE if isWithinGeometry is FALSE.
 */
-(bool) containsGeometry:(ShapeGeometry*)compareGeometry;

/** 
 @brief Returns TRUE if the DE-9IM intersection matrix for the two geometries is "T*T***T**" (for two points or two surfaces) "1*T***T**" (for two curves).
 */
-(bool) overlapsGeometry:(ShapeGeometry*)compareGeometry;

/** 
 @brief Returns TRUE if the DE-9IM intersection matrix for the two geometries is "T*F**FFF*".
 */
-(bool) isEqualToGeometry:(ShapeGeometry*)compareGeometry;

/** 
 @brief Returns TRUE if the elements in the DE-9IM intersection matrix for this geometry and the other matches the given pattern – a string of nine characters from the alphabet: {T, F, *, 0}.
 */
-(bool) isRelatedToGeometry:(ShapeGeometry*)compareGeometry withRelatePattern:(NSString*)pattern;

@end
