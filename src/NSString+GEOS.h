/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import <Foundation/Foundation.h>
#import <geos/geos_c.h>


@interface NSString (GEOS)

+(NSString*) stringWithGEOSGeom:(GEOSGeom)geosGeom;

-(GEOSGeom) geosGeom;

-(int) geomTypeForWKT;

@end
