/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import "ShapeGeometry+Predicates.h"

#import <geos/GEOSHelper.h>


@implementation ShapeGeometry (predicates)


-(bool) isDisjointFromGeometry:(ShapeGeometry*)compareGeometry
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    bool disjoint = GEOSDisjoint_r(handle, self.geosGeometry, compareGeometry.geosGeometry);

    return disjoint;
}

-(bool) touchesGeometry:(ShapeGeometry*)compareGeometry
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    bool touches = GEOSTouches_r(handle, self.geosGeometry, compareGeometry.geosGeometry);

    return touches;
}

-(bool) intersectsGeometry:(ShapeGeometry*)compareGeometry
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);

    bool intersects = GEOSIntersects_r(handle, self.geosGeometry, compareGeometry.geosGeometry);

    return intersects;
}

-(bool) crossesGeometry:(ShapeGeometry*)compareGeometry
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    bool crosses = GEOSCrosses_r(handle, self.geosGeometry, compareGeometry.geosGeometry);

    return crosses;
}

-(bool) isWithinGeometry:(ShapeGeometry*)compareGeometry
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    bool within = GEOSWithin_r(handle, self.geosGeometry, compareGeometry.geosGeometry);

    return within;
}

-(bool) containsGeometry:(ShapeGeometry*)compareGeometry
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    bool contains = GEOSContains_r(handle, self.geosGeometry, compareGeometry.geosGeometry);

    return contains;
}

-(bool) overlapsGeometry:(ShapeGeometry*)compareGeometry
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;

    bool overlaps = GEOSOverlaps_r(handle, self.geosGeometry, compareGeometry.geosGeometry);

    return overlaps;
}

-(bool) isEqualToGeometry:(ShapeGeometry*)compareGeometry
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;

    bool equals = GEOSEquals_r(handle, self.geosGeometry, compareGeometry.geosGeometry);

    return equals;
}


-(bool) isRelatedToGeometry:(ShapeGeometry*)compareGeometry withRelatePattern:(NSString *)pattern
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    bool isRelated = GEOSRelatePattern_r(handle, self.geosGeometry, compareGeometry.geosGeometry, pattern.UTF8String);

    return isRelated;
}

@end
