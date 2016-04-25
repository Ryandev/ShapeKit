/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import "ShapePolygon.h"
#import <geos/GEOSHelper.h>


@interface ShapePolygon ()
{
@private
    NSMutableArray *_interiors;
    NSMutableArray *_exteriors;
}
@end


@implementation ShapePolygon

@synthesize interiors = _interiors;

-(NSArray*) coordinates
{
    return _exteriors;
}

- (id)initWithWKB:(NSData*)wkb
{
    if (( [super initWithWKB:wkb] ))
    {
        [self _loadInteriorRings];
        [self _loadExteriorRing];
    }
    
    return self;
}

- (id)initWithWKT:(NSString*)wkt
{
    if (( self = [super initWithWKT:wkt] ))
    {
        [self _loadInteriorRings];
        [self _loadExteriorRing];
    }
    
    return self;
}

-(id) initWithGeosGeometry:(GEOSGeometry*)geom
{
    if (( self = [super initWithGeosGeometry:geom] ))
    {
        [self _loadInteriorRings];
        [self _loadExteriorRing];
    }
    
    return self;
}

-(id) initWithCoordinates:(NSArray<LocationPoint*>*)coordinates
{
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    GEOSCoordSequence *sequence = GEOSCoordSeq_create_r(handle, (unsigned int)coordinates.count, 2);
    
    for (int i = 0; i <coordinates.count; i++)
    {
        LocationPoint *point = coordinates[i];
        GEOSCoordSeq_setX_r(handle, sequence, i, point.longitude);
        GEOSCoordSeq_setY_r(handle, sequence, i, point.latitude);
    }
    
    GEOSGeometry *ring = GEOSGeom_createLinearRing_r(handle, sequence);
    void *geosGeom = GEOSGeom_createPolygon_r(handle, ring, nil, 0);
    
    self = [self initWithGeosGeometry:geosGeom];
    
    GEOSCoordSeq_destroy_r(handle, sequence);

    return self;
}

-(void) _loadInteriorRings
{
    _exteriors = [NSMutableArray new];
    
    GEOSCoordSequence *sequence = nil;

    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    assert(self.geosGeometry);
    GEOSGeometry *geosGeom = self.geosGeometry;
    
    /* Loop interior rings to convert to ShapeKitPolygons */
    int numInteriorRings = GEOSGetNumInteriorRings_r(handle, geosGeom);

    for (int interiorIndex = 0; interiorIndex < numInteriorRings; interiorIndex++)
    {
        const GEOSGeometry *interior = GEOSGetInteriorRingN_r(handle, geosGeom, interiorIndex);
        sequence = GEOSCoordSeq_clone_r(handle, GEOSGeom_getCoordSeq_r(handle, interior));
        
        unsigned int numCoordsInt = 0;
        GEOSCoordSeq_getSize_r(handle, sequence, &numCoordsInt);
        NSMutableArray *coords = [NSMutableArray new];
        
        for (int i=0; i<numCoordsInt; i++)
        {
            double x = 0.0;
            double y = 0.0;

            bool didGetX = GEOSCoordSeq_getX_r(handle, sequence, i, &x);
            bool didGetY = GEOSCoordSeq_getY_r(handle, sequence, i, &y);


            if ( didGetX && didGetY )
            {
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(y, x);
                
                coords[i] = [LocationPoint pointWithCoordinate:coord];
            }
            else
            {
                coords[i] = [NSNull null];
                NSLog(@"ShapeKit error: failed to load coordinate (%@)",self.description);
            }
        }
        
        ShapePolygon *curInterior = [[ShapePolygon alloc] initWithCoordinates:coords];

        [_interiors addObject:curInterior];
        
        GEOSCoordSeq_destroy_r(handle, sequence);
    }
}


-(void) _loadExteriorRing
{
    _exteriors = [NSMutableArray new];
    
    GEOSContextHandle_t handle = [GEOSHelper sharedInstance].handle;
    assert(handle);
    
    assert(self.geosGeometry);
    const GEOSGeometry *exterior = GEOSGetExteriorRing_r(handle, self.geosGeometry);

    GEOSCoordSequence *sequence = GEOSCoordSeq_clone_r(handle, GEOSGeom_getCoordSeq_r(handle, exterior));

    unsigned int count = 0;
    
    GEOSCoordSeq_getSize_r(handle, sequence, &count);
    
    for (int i=0; i<count; i++)
    {
        double x = 0.0;
        double y = 0.0;

        GEOSCoordSeq_getX_r(handle, sequence, i, &x);
        GEOSCoordSeq_getY_r(handle, sequence, i, &y);
        
        [_exteriors addObject:[LocationPoint pointWithCoordinate:CLLocationCoordinate2DMake(y, x)]];
    }
    
    GEOSCoordSeq_destroy_r(handle, sequence);
}

@end
