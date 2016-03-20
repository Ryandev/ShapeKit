/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface LocationPoint : NSObject

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) float latitude;
@property (nonatomic, readonly) float longitude;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate;

+(LocationPoint*) pointWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
