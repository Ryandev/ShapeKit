
# ShapeKit

[![Build Status](https://api.travis-ci.org/Ryandev/ShapeKit.svg)](https://travis-ci.org/Ryandev/Shapekit)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

ShapeKit is a iOS/OSX library that offers an Objective-C interface to the powerful [GEOS](http://trac.osgeo.org/geos/) library.
Through GEOS, ShapeKit includes all the OpenGIS Simple Features for SQL spatial predicate functions and spatial operators, as well as specific JTS enhanced topology functions.


## Usage

* ShapeKitGeometries are standard cocoa objects

```objc
ShapePoint *myPoint = [[ShapePoint alloc] initWithCoordinate:CLLocationCoordinate2DMake(0, 0)];
```

* ShapeKit has spatial predicates and topology operations

```objc
ShapePolygon *bufferedPoint = [myPoint bufferWithWidth:0.005f]
[bufferedPoint containsGeometry:myPoint]; /* Returns YES */
```

* ShapeKit has support for linear projection and interpolation 

```objc
ShapePoint *middlePoint = [myLine interpolatePointAtNormalizedDistance:0.5f];
double projectedPosition = [myLine distanceFromOriginToProjectionOfPoint:myPoint];
```

## Project setup

### Carthage
```
github "Ryandev/proj4"
github "Ryandev/geos"
github "Ryandev/ShapeKit"

```

### Build Settings
Change:
Target->'Allow Non-modular Includes in Framework Modules' = YES

## Attribution
This fork is based on the [original repository](https://github.com/mweisman/ShapeKit) by Michael Weisman, with major customizations by [Andrea Cremaschi](https://github.com/andreacremaschi) and [myself](https://www.github.com/Ryandev)

## License

This is free software; you can redistribute and/or modify it under the terms of the GNU Lesser General Public Licence as published by the Free Software Foundation. See the COPYING file for more information.
