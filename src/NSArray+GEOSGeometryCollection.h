

#import <Foundation/Foundation.h>
#import <geos/geos_c.h>


@interface NSArray (GEOSGeometryCollection)

-(GEOSGeometry*) geometryCollection;

@end
