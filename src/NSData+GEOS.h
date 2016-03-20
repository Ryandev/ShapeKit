/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import <Foundation/Foundation.h>
#import <geos/geos_c.h>


@interface NSData (GEOS)

+(NSData*) dataWithGEOSGeom:(GEOSGeom)geosGeom;

-(GEOSGeom) geosGeom;

-(int) geomTypeForWKB;

@end
