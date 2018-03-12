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
        mapView = MFTMapView()
        layer = MFTLayer()
        MFTManager.sharedManager.apiKey = "591dccc4e499ca0001a4c6a4abab8998a9ec4e0d8efce03e489a00ea"
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
        XCTAssertEqual(mapView.getZoom(), 0.0, file: "zoom level is not at 0.0")
        //XCTAssertEqual(mapView.tilt, 0.0, file: "tile level is not at 0.0")
        //XCTAssertEqual(mapView.rotation, 0.0, file: "tile level is not at 0.0")
        
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
        _ = mapView.addMarker(position: CLLocationCoordinate2DMake(40, 75))
        XCTAssertEqual(mapView.defaultAnnotationMFTLayer.annotations.isEmpty, false, "Annotation was not added to default layer")
        
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
        let marker = mapView.addMarker(position: CLLocationCoordinate2DMake(40, 75))
        XCTAssertEqual(CLLocationCoordinate2DIsValid(marker.position), true, "This is not a valid LatLng")
        
        let secondMarker = mapView.addMarker(position: CLLocationCoordinate2DMake(-91, 75))
        XCTAssertEqual(CLLocationCoordinate2DIsValid(secondMarker.position), false, "-91 is not a valid lattitude")
        
        let thirdMarker = mapView.addMarker(position: CLLocationCoordinate2DMake(40, -185))
        XCTAssertEqual(CLLocationCoordinate2DIsValid(thirdMarker.position), false, "-185 is not a valid longitude")
        
    }
    
    
    func testGeocodeCallIsSuccessful() {
        let expect = expectation(description: "Download should succeed")
        MFTGeocoder.sharedInstance.geocode(address: "119 W 24th street new york", includeBuilding: true) { (addresses, error) in
            if let error = error {
                XCTFail("geocode server error: \(error)")
            }
            
            XCTAssertNil(error, "Unexpected error occured: \(String(describing: error?.localizedDescription))")
            XCTAssertEqual(addresses![0].locality, "New York", file: "Locality was incorrect")
            XCTAssertEqual(addresses![0].postalCode, "10001", file: "Locality was incorrect")
            
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
            }
            
            XCTAssertNil(error, "Unexpected error occured: \(String(describing: error?.localizedDescription))")
            XCTAssertEqual(addresses![0].locality, "Orlando", file: "Locality was incorrect")
            expect.fulfill()
            
        }
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNil(error, "Test timed out. \(String(describing: error?.localizedDescription))")
        }
        
    }
    
    func testMarkerPositionAfterGeocoding(){
        let expect = expectation(description: "Marker postion should have valid lat long")
        
        mapView.addMarker(address: "119 W 24th street new york") { (marker, error) in
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
                self.mapView.directionsOptions.showDirections(completion: { (polyline, error) in
                    
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
        mapView.mapOptions.setTheme(customTheme: "https://cdn.mapfit.com/v2/themes/mapfit-grayscale.yaml")
        XCTAssertEqual(mapView.mapOptions.getTheme(), .custom, file: "Theme was not set to custom")
        
        
        mapView.mapOptions.setTheme(customTheme: "file:/Users/zain/Desktop/iOS-sdk/Sample-App/Sample-App/bubble-wrap-style.yaml")
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
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
