
# ShapeKit

ShapeKit is a iOS/OSX library that offers an Objective-C interface to the powerful [GEOS](http://trac.osgeo.org/geos/) library.
Through GEOS, ShapeKit includes all the OpenGIS Simple Features for SQL spatial predicate functions and spatial operators, as well as specific JTS enhanced topology functions.
This fork is based on the [original repository](https://github.com/mweisman/ShapeKit) by Michael Weisman, with major customizations.
- ShapeKit has been refactored to build in a dynamic library (using Carthage)


## Usage

* ShapeKitGeometries are standard cocoa objects

```objc
ShapePoint *myPoint = [[ShapePoint alloc] initWithCoordinate:CLLocationCoordinate2DMake(0, 0)];
```

* ShapeKit has spatial predicates and topology operations

```objc
ShapeKitPolygon *bufferedPoint = [myPoint bufferWithWidth:0.005]
[bufferedPoint containsGeometry:myPoint]; // Returns YES
```

* ShapeKit has support for linear projection and interpolation 

```objc
ShapeKitPoint *middlePoint = [myLine interpolatePointAtNormalizedDistance: 0.5];
double projectedPosition = [myLine distanceFromOriginToProjectionOfPoint: myPoint];
```

## Project setup

### Carthage
```
github 'Ryandev/proj4' 4.9.2
github 'Ryandev/geos' 3.5.0
github 'Ryandev/ShapeKit' 0.1

```

## License

This is free software; you can redistribute and/or modify it under the terms of the GNU Lesser General Public Licence as published by the Free Software Foundation. See the COPYING file for more information.

**License note: Be aware that LGPL v2.1 (GEOS license) and Apple Store compatibility is at least controversial - if statically linking (carthage=dynamic)**
