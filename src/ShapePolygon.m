/**
 @file ShapeKit
 @author Michael Weisman
 @editor Ryan Powell
 @license GNU Lesser General Public Licence
 */


#import "ShapePolygon.h"
#import "GEOS.h"


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

- (id)initWithWKT:(NSString *)wkt
{
    if (( self = [super initWithWKT:wkt] ))
    {
        [self _loadInteriorRings];
        [self _loadExteriorRing];
    }
    
    return self;
}

-(id) initWithGeosGeometry:(void*)geom
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
    GEOSContextHandle_t handle = [GEOS sharedInstance].handle;
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
    GEOSContextHandle_t handle = [GEOS sharedInstance].handle;
    GEOSGeometry *geosGeom = self.geosHandle;
    
    /* Loop interior rings to convert to ShapeKitPolygons */
    int numInteriorRings = GEOSGetNumInteriorRings_r(handle, geosGeom);

    for (int interiorIndex = 0; interiorIndex < numInteriorRings; interiorIndex++)
    {
        const GEOSGeometry *interior = GEOSGetInteriorRingN_r(handle, geosGeom, interiorIndex);
        sequence = GEOSCoordSeq_clone_r(handle, GEOSGeom_getCoordSeq_r(handle, interior));
        
        unsigned int numCoordsInt = 0;
        GEOSCoordSeq_getSize_r(handle, sequence, &numCoordsInt);
        NSMutableArray *coords = [NSMutableArray new];
        
        for (int coord = 0; coord < numCoordsInt; coord++)
        {
            double x = 0.0;
            double y = 0.0;

            GEOSCoordSeq_getX_r(handle, sequence, coord, &x);
            GEOSCoordSeq_getY_r(handle, sequence, coord, &y);
            
            coords[coord] = [LocationPoint pointWithCoordinate:CLLocationCoordinate2DMake(y, x)];
        }
        
        ShapePolygon *curInterior = [[ShapePolygon alloc] initWithCoordinates:coords];

        [_interiors addObject:curInterior];
        
        GEOSCoordSeq_destroy_r(handle, sequence);
    }
}


-(void) _loadExteriorRing
{
    _exteriors = [NSMutableArray new];
    
    GEOSCoordSequence *sequence = nil;
    GEOSContextHandle_t handle = [GEOS sharedInstance].handle;
    
    const GEOSGeometry *exterior = GEOSGetExteriorRing_r(handle, self.geosHandle);
    sequence = GEOSCoordSeq_clone_r(handle, GEOSGeom_getCoordSeq_r(handle, exterior));

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
