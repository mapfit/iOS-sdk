//
//  Sample_AppTests.swift
//  Sample-AppTests
//
//  Created by Zain N. on 2/22/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import XCTest
import CoreLocation
import Mapfit
@testable import Sample_App

class Sample_AppTests: XCTestCase {
    
    var mapView: MFTMapView!
    var layer: MFTLayer!
    
    override func setUp() {
        super.setUp()
        MFTManager.sharedManager.apiKey = "591dccc4e499ca0001a4c6a4413a1efe64344fb599b501aaeef6937d"
        mapView = MFTMapView()
        layer = MFTLayer()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        mapView = nil
        layer = nil
    }
    
    func testDefaultMapState() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        //XCTAssertEqual(mapView.mapStyle, .day, file: "Style created was incorrect")
        //XCTAssertEqual(mapView.isDirectionsEnabled, false, file: "Directions is enabled upon map creation")
        XCTAssertEqual(mapView.getZoom(), 1.0, file: "zoom level is not at 0.0")
        //XCTAssertEqual(mapView.tilt, 0.0, file: "tile level is not at 0.0")
        XCTAssertEqual(mapView.getRotation(), 0.0, file: "tile level is not at 0.0")
        
    }
    
    func testDefaultMFTLayerState(){
        //Test visibility of layer upon map creation®
        XCTAssertEqual(layer.isVisible, true, file: "MFTLayer is not visible upon creation")
    }
    
    
    func testAddingandRemovingOfMFTLayer(){
        //adding mapview to the layer property
        mapView.addLayer(layer: layer)
        var containsMFTLayer = Bool()
        
        //checks to see if their is a layer in the mapview.layers
        guard let mapMFTLayer = mapView.layers.first else{ return print("mapview not added to layer.mapViews")}
        
        //compares layer to maplayer uuid
        if mapMFTLayer.uuid == layer.uuid {
            containsMFTLayer = true
        } else {
            containsMFTLayer = false
        }
        
        //expects that the mapview has the layer that was added
        XCTAssertEqual(containsMFTLayer, true, "MFTLayer was not added to mapview")
        
        //remove mapview layer
        mapView.removeLayer(layer: mapMFTLayer)
        
        XCTAssertEqual(mapView.layers.isEmpty, true, "MFTLayer was not removed")
        
    }
    
    func testMarkerAddedToDefaultMFTLayer(){
        let options = MFTMarkerOptions()
        let expect = expectation(description: "Marker position should be valid")
        options.setPosition(position: CLLocationCoordinate2DMake(40, 75), reverseGeocode: false)
        mapView.addMarker(options) { (marker, error) in
            XCTAssertEqual(self.mapView.defaultAnnotationMFTLayer.annotations.isEmpty, false, "Annotation was not added to default layer")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Test timed out. \(String(describing: error?.localizedDescription))")
        }
        
        
        
    }
    
    //    func testAddingAndRemovingToMapview(){
    //        let marker = mapView.addMarker(position: CLLocationCoordinate2DMake(40, 75))
    //        XCTAssertEqual(mapView.defaultAnnotationMFTLayer.annotations.isEmpty, false, "Annotation was not added to default layer")
    //        mapView.removeAnnotationFromMap(marker)
    //        XCTAssertEqual(mapView.defaultAnnotationMFTLayer.annotations.isEmpty, true, "Annotation still on mapview")
    //    }
    
    
    func testIfMarkerHasValidLatLng() {
        //Valid Lat must be between -90 and 90
        //Valid Lng must be between -180 and 180
        let options = MFTMarkerOptions()
        options.setPosition(position: CLLocationCoordinate2DMake(40, 75), reverseGeocode: false)
        let expect = expectation(description: "Marker position should be valid")
        mapView.addMarker(options) { (marker, error) in
            
            if let marker = marker {
                 XCTAssertEqual(CLLocationCoordinate2DIsValid(marker.position), true, "This is not a valid LatLng")
                expect.fulfill()
            }
        }
        
        
        let sOptions = MFTMarkerOptions()
        sOptions.setPosition(position: CLLocationCoordinate2DMake(-91, 75), reverseGeocode: false)
        
        let expect2 = expectation(description: "Marker position should be valid")
        mapView.addMarker(sOptions) { (marker, error) in
            if let marker = marker {
                XCTAssertEqual(CLLocationCoordinate2DIsValid(marker.position), false, "This is a valid LatLng")
                expect2.fulfill()
            }
        }
        
        let tOptions = MFTMarkerOptions()
        tOptions.setPosition(position: CLLocationCoordinate2DMake(40, -185), reverseGeocode: false)
        let expect3 = expectation(description: "Marker position should be valid")
        mapView.addMarker(tOptions) { (marker, error) in
            if let marker = marker {
                XCTAssertEqual(CLLocationCoordinate2DIsValid(marker.position), false, "This is a valid LatLng")
                expect3.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Test timed out. \(String(describing: error?.localizedDescription))")
        }
        
    }
    
    
    
    
    func testGeocodeCallIsSuccessful() {
        let expect = expectation(description: "Download should succeed")
        MFTGeocoder.sharedInstance.geocode(address: "119 W 24th street new york", includeBuilding: true) { (addresses, error) in
            if let error = error {
                XCTFail("geocode server error: \(error.localizedDescription)")
            }
            
            XCTAssertNil(error, "Unexpected error occured: \(String(describing: error?.localizedDescription))")
            if let addresses = addresses {
                XCTAssertEqual(addresses[0].locality, "New York", file: "Locality was incorrect")
                XCTAssertEqual(addresses[0].postalCode, "10011", file: "Locality was incorrect")
            }

            
            expect.fulfill()
            
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Test timed out. \(String(describing: error?.localizedDescription))")
        }
        
    }
    
    func testGeocodeCallWithViewPortIsSuccessful() {
        let expect = expectation(description: "Download should succeed")
        MFTGeocoder.sharedInstance.geocode(address: "new york", includeBuilding: true) { (addresses, error) in
            if let error = error {
               // XCTFail("geocode server error: \(error.localizedDescription)")
                expect.fulfill()
            }
            if let addresses = addresses {
                if let viewport = addresses[0].viewport {
                    XCTAssertEqual(viewport.southwest!.lng,  -80.809183, file: "southwest lon was incorrect")
                    XCTAssertEqual(viewport.southwest!.lat, 41.755976, file: "southwest lat was incorrect")
                    XCTAssertEqual(viewport.northeast!.lng,  -70.809183, file: "northeast lon was incorrect")
                    XCTAssertEqual(viewport.northeast!.lat, 43.755976, file: "northeat lat was incorrect")
                }
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Test timed out. \(String(describing: error?.localizedDescription))")
        }
        
    }
    
    
    func testCityGeocodeCallIsSuccessful() {
        let expect = expectation(description: "Download should succeed")
        
        MFTGeocoder.sharedInstance.geocode(address: "orlando, florida", includeBuilding: true) { (addresses, error) in
            if let error = error {
                XCTFail("geocode server error: \(error)")
                expect.fulfill()
            }
            
            if let addresses = addresses {
                XCTAssertNil(error, "Unexpected error occured: \(String(describing: error?.localizedDescription))")
                XCTAssertEqual(addresses[0].locality, "Orlando", file: "Locality was incorrect")
                expect.fulfill()
            }
            
            
        }
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNil(error, "Test timed out. \(String(describing: error?.localizedDescription))")
        }
        
    }
    
    func testReverseGeocodeCallIsSuccessful() {
        let expect = expectation(description: "Download should succeed")
        MFTGeocoder.sharedInstance.reverseGeocode(latLng: CLLocationCoordinate2DMake(40.74405, -73.99324), includeBuilding: true) { (addresses, error) in
            if let error = error {
                XCTFail("geocode server error: \(error)")
            }
            
            XCTAssertNil(error, "Unexpected error occured: \(String(describing: error?.localizedDescription))")
            XCTAssertEqual(addresses![0].locality, "New York", file: "Locality was incorrect")
            XCTAssertEqual(addresses![0].postalCode, "10001", file: "Locality was incorrect")
            XCTAssertEqual(addresses![0].streetAddress, "119 W 24th St", file: "address was incorrect")
            
            expect.fulfill()
            
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Test timed out. \(String(describing: error?.localizedDescription))")
        }
        
    }
    
    func testMarkerPositionAfterGeocoding(){
        let expect = expectation(description: "Marker postion should have valid lat long")
        let options = MFTMarkerOptions()
        options.setStreetAddress(streetAddress: "119 W 24th street new york", geocode: true)
        
        mapView.addMarker(options) { (marker, error) in
            if let marker = marker {
                XCTAssertEqual(marker.position.latitude, 40.744050000000001, file: "Lat is not valid")
                XCTAssertEqual(marker.position.longitude, -73.99324, file: "Lng is not valid")
            }
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 8) { (error) in
            XCTAssertNil(error, "Test timed out. \(String(describing: error?.localizedDescription))")
        }
        
    }
    
    
    func testMarkerAndBuildingPolygonCreationWithOptions(){
        let expect = expectation(description: "Marker and building polygon initialized with options")
        let markerOptions = MFTMarkerOptions()
        markerOptions.setStreetAddress(streetAddress: "119 w 24th street new york, NY", geocode: true)
        markerOptions.setHeight(height: 50)
        markerOptions.setWidth(width: 80)
        markerOptions.setFlat(false)
        markerOptions.setDrawOrder(drawOrder: 300)
        markerOptions.setInteractivity(false)
        markerOptions.setAnchorPosition(.center)
        markerOptions.setTitle("title")
        markerOptions.setSubTitle1("subtitle1")
        markerOptions.setSubTitle2("subtitle2")
        markerOptions.setVisibility(false)
       
        let polygonOptions = MFTPolygonOptions()
        polygonOptions.setFillColor("#800000")
        polygonOptions.setStrokeColor("#FFFF00")
        polygonOptions.setStrokeOutlineColor("#808000")
        polygonOptions.setStrokeWidth(4)
        polygonOptions.setLineCapType(.square)
        polygonOptions.setLineJoinType(.bevel)
        polygonOptions.setDrawOrder(100)
        polygonOptions.setOutlineWidth(50)
        markerOptions.addBuildingPolygon(true, options: polygonOptions)
        
        
        
        mapView.addMarker(markerOptions) { (marker, error) in
           
            if let mark = marker {
                //Marker
                XCTAssertEqual(mark.streetAddress, "119 W 24th St", file: "street address is incorrect")
                XCTAssertEqual(mark.height, 50, file: "height is incorrect")
                XCTAssertEqual(mark.width, 80, file: "width is incorrect")
                XCTAssertEqual(mark.isFlat, false, file: "isFlat is incorrect")
                XCTAssertEqual(mark.drawOrder, 300, file: "draworder is incorrect")
                XCTAssertEqual(mark.isInteractive, false, file: "isInteractive is incorrect")
                XCTAssertEqual(mark.anchor, .center, file: "anchor is incorrect")
                XCTAssertEqual(mark.title, "title", file: "title is incorrect")
                XCTAssertEqual(mark.subtitle1, "subtitle1", file: "subtitle1 is incorrect")
                XCTAssertEqual(mark.subtitle2, "subtitle2", file: "subtitle2 is incorrect")
                XCTAssertEqual(mark.isVisible, false, file: "visibility is incorrect")
                //building polygon
                guard let buildingPolygon = mark.buildingPolygon else { return }
                XCTAssertEqual(buildingPolygon.strokeColor, "#FFFF00", file: "stroke color is incorrect")
                XCTAssertEqual(buildingPolygon.strokeWidth, 4, file: "stroke width is incorrect")
                XCTAssertEqual(buildingPolygon.strokeOutlineColor, "#808000", file: "stroke outline color is incorrect")
                XCTAssertEqual(buildingPolygon.strokeOutlineWidth, 50, file: "stroke outline width is incorrect")
                XCTAssertEqual(buildingPolygon.fillColor, "#800000", file: "fill color is incorrect")
                XCTAssertEqual(buildingPolygon.drawOrder, 100, file: "draw order is incorrect")
                XCTAssertEqual(buildingPolygon.lineCapType, .square, file: "line cap type is incorrect")
                XCTAssertEqual(buildingPolygon.lineJoinType, .bevel, file: "line join type is incorrect")

            }

            expect.fulfill()
        }
        
        waitForExpectations(timeout: 8) { (error) in
            XCTAssertNil(error, "Test timed out. \(String(describing: error?.localizedDescription))")
        }
    
    }
    
    func testPolylineCreationWithOptions(){
        
        
        let polylineOptions = MFTPolylineOptions()
        polylineOptions.setStrokeColor("#FFFF00")
        polylineOptions.setStrokeOutlineColor("#808000")
        polylineOptions.setStrokeWidth(4)
        polylineOptions.setLineCapType(.square)
        polylineOptions.setLineJoinType(.bevel)
        polylineOptions.setDrawOrder(100)
        polylineOptions.setOutlineWidth(50)
        polylineOptions.addPoints([[CLLocationCoordinate2D(latitude:40.729877, longitude:-74.000588),
                                    CLLocationCoordinate2D(latitude:40.729171, longitude:-74.001191),
                                    CLLocationCoordinate2D(latitude:40.728103, longitude:-74.002099),
                                    CLLocationCoordinate2D(latitude:40.728248, longitude:-74.002396),
                                    CLLocationCoordinate2D(latitude:40.728382, longitude:-74.002663)]])
        
        let polyline = mapView.addPolyline(options: polylineOptions)
        
        guard let poly = polyline else { return }
        
        XCTAssertEqual(poly.strokeColor, "#FFFF00", file: "stroke color is incorrect")
        XCTAssertEqual(poly.strokeWidth, 4, file: "stroke width is incorrect")
        XCTAssertEqual(poly.strokeOutlineColor, "#808000", file: "stroke outline color is incorrect")
        XCTAssertEqual(poly.strokeOutlineWidth, 50, file: "stroke outline width is incorrect")
        XCTAssertEqual(poly.drawOrder, 100, file: "draw order is incorrect")
        XCTAssertEqual(poly.lineCapType, .square, file: "line cap type is incorrect")
        XCTAssertEqual(poly.lineJoinType, .bevel, file: "line join type is incorrect")
        
    }
    
    
    func testDirectionsCallWithJustAddresses(){
        let expect = expectation(description: "Directions should return sourceLocation, destinationLocation, trip")
        MFTDirections.sharedInstance.route(origin: nil, originAddress: "new york, new york", destination: nil, destinationAddress: "119 w 24th street,new york NY", directionsType: .driving) { (routeObject, error) in
            
            if let routeObject = routeObject {
                
                XCTAssertEqual(routeObject.sourceLocation![0], -74.00714, file: "source location lattitude for NY is not correct")
                XCTAssertEqual(routeObject.sourceLocation![1],  40.71455, file: "source location longitude for NY is not correct")
                
                XCTAssertEqual(routeObject.destinationLocation![0], -73.99324, file: "destination location lattitude for NY is not correct")
                XCTAssertEqual(routeObject.destinationLocation![1], 40.74405, file: "destionation location longitude for NY is not correct")
                
                XCTAssertEqual(routeObject.trip?.status, 0, file: "destionation location longitude for NY is not correct")
                XCTAssertEqual(routeObject.trip?.statusMessage, "Found route between points", file: "status message did not find route")
                
            }
            
            
            expect.fulfill()
        }
        waitForExpectations(timeout: 8) { (error) in
            XCTAssertNil(error, "Test timed out. \(String(describing: error?.localizedDescription))")
        }
        
    }
    
    func testDirectionsCallWithLatLon(){
        let expect = expectation(description: "Directions should return sourceLocation, destinationLocation, trip")
        MFTDirections.sharedInstance.route(origin: CLLocationCoordinate2D(latitude: 40.71455, longitude: -74.00714), originAddress: "new york, new york", destination: CLLocationCoordinate2D(latitude:  40.74405, longitude: -73.99324), destinationAddress: "119 w 24th street,new york NY", directionsType: .driving) { (routeObject, error) in
            
            if let routeObject = routeObject {
                
                XCTAssertEqual(routeObject.sourceLocation![0], -74.00714, file: "Only CLLocations Included: source location lattitude for NY is not correct")
                XCTAssertEqual(routeObject.sourceLocation![1], 40.71455, file: "Only CLLocations Included: source location longtitude for NY is not correct")
                
                XCTAssertEqual(routeObject.destinationLocation![0], -73.99324, file: "Only CLLocations Included: destination location longitude for NY is not correct")
                XCTAssertEqual(routeObject.destinationLocation![1], 40.74405, file: "Only CLLocations Included: destionation location lattitude for NY is not correct")
                
                XCTAssertEqual(routeObject.trip?.status, 0, file: "destionation location longitude for NY is not correct")
                XCTAssertEqual(routeObject.trip?.statusMessage, "Found route between points", file: "status message did not find route")
                
            }
            
            
            expect.fulfill()
        }
        waitForExpectations(timeout: 8) { (error) in
            XCTAssertNil(error, "Test timed out. \(String(describing: error?.localizedDescription))")
        }
        
    }
    
    func testDirectionsCallOneAddressAndOneLatLon(){
        let expect = expectation(description: "Directions should return sourceLocation, destinationLocation, trip")
        MFTDirections.sharedInstance.route(origin: nil, originAddress: "new york, new york", destination: CLLocationCoordinate2D(latitude:  40.74405, longitude: -73.99324), destinationAddress: nil, directionsType: .driving) { (routeObject, error) in
            
            if let routeObject = routeObject {
                
                XCTAssertEqual(routeObject.sourceLocation![0], -74.00714, file: "One Address and One Lat Lng: source location lattitude for NY is not correct")
                XCTAssertEqual(routeObject.sourceLocation![1], 40.71455, file: "One Address and One Lat Lng:  source location longtitude for NY is not correct")
                
                XCTAssertEqual(routeObject.destinationLocation![0], -73.99324, file: "One Address and One Lat Lng:  destination location longitude for NY is not correct")
                XCTAssertEqual(routeObject.destinationLocation![1], 40.74405, file: "One Address and One Lat Lng:  destionation location lattitude for NY is not correct")
                
                XCTAssertEqual(routeObject.trip?.status, 0, file: "destination location longitude for NY is not correct")
                XCTAssertEqual(routeObject.trip?.statusMessage, "Found route between points", file: "status message did not find route")
  
            }
            
            expect.fulfill()
        }
        waitForExpectations(timeout: 8) { (error) in
            XCTAssertNil(error, "Test timed out. \(String(describing: error?.localizedDescription))")
        }
        
    }
    
    
    
    func testDirectionsOptions(){
        let expect = expectation(description: "Source & Destination locations set through directionsOptions")
        
        
        self.mapView.directionsOptions.setOrigin("55 east street, Hicksville NY, 11801")
            self.mapView.directionsOptions.setDestination( "119 w 24th street, New York, NY")
        self.mapView.directionsOptions.showDirections(options: nil, completion: { (polyline, error) in
                    
                    XCTAssertEqual(self.mapView.directionsOptions.directionsType, .driving, file: "Transit type is incorrect")
                    
                    XCTAssertEqual(self.mapView.currentPolylines.count, 1, file: "Polyline should be present on map")
                    
                    expect.fulfill()
                })
            
       
        
        waitForExpectations(timeout: 12) { (error) in
            XCTAssertNil(error, "Test timed out. \(String(describing: error?.localizedDescription))")
        }
        
    }
    
    func testMFTLayerAddingAndRemovingAnnotations(){
        
        
    }
    
    func testDirectionViewAndOptionsDefaultValues(){
        XCTAssertEqual(mapView.directionsOptions.isVisible, true, file: "Directions options isShown defaults to true")
        XCTAssertEqual(mapView.directionsOptions.directionsType, .driving, file: "Directions type defaults to driving")
        XCTAssertEqual(mapView.directionsOptions.isVisible, true, file: "Directions view defaults to visible")
    }
    
    func testClearingOfPolylinesFromDirectionsView(){
        
        
        
    }
    
    func testInitializingMapWithCustomTheme(){
        
        if let path = Bundle.main.path(forResource: "day-theme", ofType: "yaml")  {
            self.mapView = MFTMapView(frame: .zero, customMapStyle: "file:///\(path)")
        }
        XCTAssertEqual(mapView.mapOptions.getTheme(), .custom, file: "custom theme now set")
 
    }
    
    func testDefaultMapOptions(){
        
        XCTAssertEqual(mapView.mapOptions.isPanEnabled, true, file: "pan is turned off by default")
        XCTAssertEqual(mapView.mapOptions.isTiltEnabled, true, file: "tilt is turned off by default")
        XCTAssertEqual(mapView.mapOptions.isPinchEnabled, true, file: "pinch is turned off by default")
        XCTAssertEqual(mapView.mapOptions.isCompassVisible, false, file: "compass is turned on by default")
        XCTAssertEqual(mapView.mapOptions.isRotateEnabled, true, file: "rotate is turned off by default")
        XCTAssertEqual(mapView.mapOptions.isZoomControlVisible, false, file: "zoom buttons are turned on by default")
        XCTAssertEqual(mapView.mapOptions.isRotateEnabled, true, file: "rotate is turned off by default")
        XCTAssertEqual(mapView.mapOptions.getTheme(), .day, file: "Day theme not set as default")
        
    }
    
    func testSetAndGetBounds(){
        var bounds = MFTLatLngBounds()
        
        let latLngList = [CLLocationCoordinate2D(latitude: 37.198504, longitude: -83.272133),CLLocationCoordinate2D(latitude: 29.652243, longitude: -29.042111),CLLocationCoordinate2D(latitude: 38.246623, longitude: -82.737144),CLLocationCoordinate2D(latitude: 36.691771, longitude: -110.030517),CLLocationCoordinate2D(latitude: 37.940202, longitude: -107.461721),CLLocationCoordinate2D(latitude: 39.400789, longitude: -80.243273)]
        
        var builder = MFTLatLngBounds.Builder()
        
        for latLng in latLngList {
            builder.add(latLng: latLng)
        }
        
        bounds = builder.build()
        
        
        let expectedNE = CLLocationCoordinate2D(latitude: 39.400789, longitude: -29.042111)
        let expectedSW = CLLocationCoordinate2D(latitude: 29.652243, longitude: -110.030517)
     
        
        XCTAssertEqual(bounds.northEast.latitude, expectedNE.latitude, file: "Northeast latitude was not computed correctly")
        XCTAssertEqual(bounds.northEast.longitude, expectedNE.longitude, file: "Northeast longitude was not computed correctly")
        
        XCTAssertEqual(bounds.southWest.latitude, expectedSW.latitude, file: "Southwest latitude was not computed correctly")
        XCTAssertEqual(bounds.southWest.longitude, expectedSW.longitude, file: "Southwest latitude was not computed correctly")
        
        XCTAssertEqual(bounds.southWest.longitude, expectedSW.longitude, file: "Southwest latitude was not computed correctly")
        
        let expectedCenter = CLLocationCoordinate2D(latitude:42.09842441252814, longitude: -72.40426108071209)
        let expectedZoomLevel = Float(3.6440628)
        
        let viewWidth = Float(1440)
        let viewHeight = Float(2194)
        
        let (center, zoomLevel) = bounds.getVisibleBounds(viewWidth: viewHeight, viewHeight: viewWidth, padding: Float(1))
        
        XCTAssertEqual(expectedCenter.latitude, center.latitude, accuracy: 0.001, file: "center latitude was not computed correctly")
        XCTAssertEqual(expectedCenter.longitude, center.longitude, accuracy: 0.001, file: "center longitude was not computed correctly")
        XCTAssertEqual(expectedZoomLevel, zoomLevel, accuracy: 1, file: "Zoom not calculated correctly")

    }
    
    
    
    func testCustomThemes(){
        mapView.mapOptions.setCustomTheme("https://cdn.mapfit.com/v2/themes/mapfit-grayscale.yaml")
        XCTAssertEqual(mapView.mapOptions.getTheme(), .custom, file: "Theme was not set to custom")
        
        
        mapView.mapOptions.setCustomTheme("file:/Users/zain/Desktop/iOS-sdk/Sample-App/Sample-App/bubble-wrap-style.yaml")
        XCTAssertEqual(mapView.mapOptions.getTheme(), .custom, file: "Theme was not set to custom on local yaml load")
    }
    
    
    func testMinAndMaxZoom(){
        mapView.mapOptions.setMaxZoomLevel(zoomLevel: 17)
        mapView.mapOptions.setMinZoomLevel(zoomLevel: 5)
        
        mapView.setZoom(zoomLevel: 3)
        XCTAssertEqual(mapView.getZoom(), 5, file: "Mapview was not set to min zoom level")
        
        mapView.setZoom(zoomLevel: 19)
        XCTAssertEqual(mapView.getZoom(), 17, file: "Mapview was not set to min zoom level")

    }
    
    func testUserLocationStates() {
        mapView.mapOptions.setUserLocationButtonVisibility(true)
        XCTAssertEqual(CLLocationManager.locationServicesEnabled(), true, file: "Location services in enabled")

    }
    
    func testSceneUpdate(){
        

    }
    
    func testScreenPositionToLatLng(){
        let expect = expectation(description: "Adding a marker")
        var point = CGPoint()
        let options = MFTMarkerOptions()
        options.setStreetAddress(streetAddress: "119 W 24th street new york", geocode: true)
        mapView.addMarker(options) { (marker, error) in
            if let marker = marker {
                self.mapView.setZoom(zoomLevel: 5)
                self.mapView.setCenter(position: CLLocationCoordinate2D(latitude: 40, longitude: -73))
                point = self.mapView.latLngToScreenPosition(marker.position)
                XCTAssertEqual(point, CGPoint(x: 2412.24271644444, y: 3079.09632368462), file: "CGPoint in incorrect")
                
            }
        
            expect.fulfill()
        }
        
        
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNil(error, "Test timed out. \(String(describing: error?.localizedDescription))")
        }
        
    }

    
    func testLatLngToScreenPosition(){
        let latLng = CLLocationCoordinate2D(latitude: -53.88698076354973, longitude: -51.562535762787178)
        
        let testLatlng = mapView.screenPositionToLatLng(CGPoint(x: 182.666615804036, y: 347.333106486003))
        
        XCTAssertEqual(testLatlng.latitude, latLng.latitude, file: "lat in incorrect")
        XCTAssertEqual(testLatlng.longitude, latLng.longitude, file: "lng in incorrect")
        
        
    }
    
    func testMapViewGestures(){
        mapView.mapOptions.setGesturesEnabled(true)
        XCTAssertEqual(mapView.mapOptions.isPinchEnabled, true, file: "Mapview pinch is not enabled")
        XCTAssertEqual(mapView.mapOptions.isPanEnabled, true, file: "Mapview pan is not enabled")
        XCTAssertEqual(mapView.mapOptions.isTiltEnabled, true, file: "Mapview tilt is not enabled")
        XCTAssertEqual(mapView.mapOptions.isRotateEnabled, true, file: "Mapview rotate is not enabled")
        XCTAssertEqual(mapView.mapOptions.getGesturesEnabled(), true, file: "Mapview gestures is not enabled")

        mapView.mapOptions.setGesturesEnabled(false)
        XCTAssertEqual(mapView.mapOptions.isPinchEnabled, false, file: "Mapview pinch is enabled")
        XCTAssertEqual(mapView.mapOptions.isPanEnabled, false, file: "Mapview pan is enabled")
        XCTAssertEqual(mapView.mapOptions.isTiltEnabled, false, file: "Mapview tilt is enabled")
        XCTAssertEqual(mapView.mapOptions.isRotateEnabled, false, file: "Mapview rotate is enabled")
        XCTAssertEqual(mapView.mapOptions.getGesturesEnabled(), false, file: "Mapview gestures is enabled")

    }
    
    func testCameraAnimation(){
        
        let expect = expectation(description: "Adding animation")
        print("Before animation")
        print(self.mapView.getZoom())
        print(self.mapView.getTilt())
        print(self.mapView.getRotation())
        print(self.mapView.getCenter())
        
        
        let orbitTrajectory = OrbitTrajectory()
        var orbitAnimation:  Cinematography? = nil
        var cameraAnimation: CameraAnimation? = nil
        
        let callBack: ()->AnimationCallback = {
            
            struct c : AnimationCallback {
                
                func onStart() {
                   
                }
                
                func onFinish() {
                    
                }
            }
            
            return c() as AnimationCallback
        }
        
        let pivotPosition = CLLocationCoordinate2D(latitude: 40.743502, longitude: -73.991667)
        // define the options for the animation
        
        orbitTrajectory.loop(loop: false)
        orbitTrajectory.pivot(position: pivotPosition, centerToPivot: true, duration: 1, easeType: .quartIn)
        orbitTrajectory.duration(duration: 10)
        orbitTrajectory.tiltTo(angle: 2, duration: 4, easeType: .linear)
        orbitTrajectory.zoomTo(zoomLevel: 15, duration: 2, easeType: .expInOut)
        orbitTrajectory.speedMultiplier(multiplier: 2) /* positive values will rotate anti-clockwise whereas negative values will rotate clockwise */
        
        // create the animation
        if let mapview = self.mapView {
            orbitAnimation = Cinematography(mapview)
            
            cameraAnimation = orbitAnimation?.create(cameraOptions: orbitTrajectory, cameraAnimationCallback: callBack)
            cameraAnimation?.start()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                expect.fulfill()
        }
        
        waitForExpectations(timeout: 5) { (error) in
        
            XCTAssertNotEqual(self.mapView.getZoom(), 0, file: "camera animation did not calculate accurate zoom")
            XCTAssertNotEqual(self.mapView.getRotation(), 0, file: "camera animation is not rotating properly")
            XCTAssertNotEqual(self.mapView.getCenter().latitude,  40.6892, file: "camera animation center latitude not being set properly")
            XCTAssertNotEqual(self.mapView.getCenter().longitude, -74.044499999999999, file: "camera animation center longitude not being set properly")

        }
    

    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    
}
