/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import "LocationPoint.h"

@interface LocationPoint ()
{
@private
    CLLocationCoordinate2D _coordinate;
}
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@end


@implementation LocationPoint

@synthesize coordinate = _coordinate;

@dynamic latitude;

-(float) latitude
{
    return _coordinate.latitude;
}

@dynamic longitude;

-(float) longitude
{
    return _coordinate.longitude;
}

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (( self = [super init] ))
    {
        self.coordinate = coordinate;
    }
    
    return self;
}

+(LocationPoint*) pointWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    return [[LocationPoint alloc] initWithCoordinate:coordinate];
}

@end
