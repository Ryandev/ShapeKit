/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <geos/geos_c.h>

#import "LocationPoint.h"


/** 
 @brief ShapeGeometry is an abstract class that holds generic information about your geometry.
 */
@interface ShapeGeometry : NSObject
{
@protected
    NSString *_geomType;
    NSString *_projDefinition;
    GEOSGeometry *_geosGeometry;
    NSMutableArray <LocationPoint*> *_coordinates;
}

@property (readonly, copy) NSString *wkt;
@property (readonly, copy) NSData *wkb;
@property (readonly, copy) NSString *geomType;
@property (readonly, copy) NSString *projDefinition;
@property (readonly) GEOSGeometry *geosGeometry;
@property (readonly) NSArray <LocationPoint*> *coordinates;


-(id) initWithWKT:(NSString*)wkt;
-(id) initWithWKB:(NSData*)wkb;
-(id) initWithGeosGeometry:(GEOSGeometry*)geom;

+(instancetype) geometryWithWKT:(NSString*)wkt;
+(instancetype) geometryWithWKB:(NSData*)wkb;
+(instancetype) geometryWithGeosGeometry:(GEOSGeometry*)geom;

@end
