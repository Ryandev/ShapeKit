/**
 @file ShapeKit
 @author Michael Weisman
 @license GNU Lesser General Public Licence
 */



#ifndef ShapeKit_ShapeKitPrivateInterface_h
#define ShapeKit_ShapeKitPrivateInterface_h

#import <geos/geos_c.h>
#import <CoreLocation/CoreLocation.h>

@interface ShapeGeometry (PrivateInterface)

@property (readwrite, copy) NSString *wktGeom;
@property (readwrite, copy) NSString *geomType;

@property (readwrite, copy) NSString *projDefinition;

@property (readwrite) GEOSGeometry *geosGeom;

@property (readwrite) CLLocationCoordinate2D *coords;

@end

#endif
