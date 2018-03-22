//
//  MFTMapOptions.swift
//  iOS.SDK
//
//  Created by Zain N. on 1/5/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import Foundation
import TangramMap
import CoreLocation

/**
 `MFTMapOptions` This is the class that controls options for MFTMapView.
 */

public protocol LocationUpdateDelegate: class {
    func didRecieveLocationUpdate(_ location: CLLocation)
}

public class MFTMapOptions  {

    
    /**
     Indicates if compass is enabled. Set by setCompassEnabled.
     */
    public var isCompassVisible: Bool {
        didSet {
            mapView?.toggleCompassButton()
        }
    }

    /**
     Indicates if zoom controls are visible. Set by setZoomControlVisibility.
     */

    public var isZoomControlVisible: Bool {
        didSet {
            mapView?.toggleZoomButtons()
        }
    }
    
    public var isRecenterControlVisible: Bool {
        didSet {
            mapView?.toggleRecenterButton()
        }
    }

    /**
     The mapview that is controlled by the options.
     */
    
    public var mapView: MFTMapView?
    internal var mapTheme: MFTMapTheme
    public var cameraType: TGCameraType?
    public var showUserLocation: Bool?
    public var isPanEnabled: Bool
    public var isPinchEnabled: Bool
    public var isRotateEnabled: Bool
    public var isTiltEnabled: Bool
    public var is3DbuildingsEnabled: Bool?
    private var maxZoomLevel: Float
    private var minZoomLevel: Float
    
    fileprivate let styles: [MFTMapTheme:MFTStyleSheet] = [MFTMapTheme.day : MFTDayStyle(),
                                                           MFTMapTheme.night : MFTNightStyle(), MFTMapTheme.grayScale : MFTGreyScaleStyle()]
    

    internal var currentLocationGem: MFTMarker?
    internal var accuracyCircle: MFTMarker?
    internal var lastLocation: CLLocation?
    private var firstRun: Int = 0
    internal var accuracyCircleTimer = Timer()
    
    
    /// Location
    internal let locationManager: LocationManagerProtocol
    internal var locEngine = LocationCorrectionEngine()
    /// Receiver for location updates
    public weak var userLocationDelegate: LocationUpdateDelegate?
    /**
     Sets mapView to be controlled by the class.
     - parameter mapView: The map view that will be controlled by the options.
     */

    public func setMapView(mapView: MFTMapView) {
        self.mapView = mapView
    }

    public func setMaxZoomLevel(zoomLevel: Float){
        self.maxZoomLevel = zoomLevel
    }

    public func getMaxZoomLevel()-> Float {
        return maxZoomLevel
    }

    public func setMinZoomLevel(zoomLevel: Float){
        self.minZoomLevel = zoomLevel
    }

    public func getMinZoomLevel()-> Float {
     return minZoomLevel

    }

    
    /**
     Sets theme for the map view controlled by the map options.
     - parameter theme: Style to be loaded.
     */
    
    
    public func setTheme(theme: MFTMapTheme) {
        guard let style = styles[theme] else { print("Could not load theme")
            return
        }
        
        self.mapTheme = theme
        try? mapView?.loadMFTStyleSheetAsync(style) { (style) in
           
        }
    }
    
    public func setCustomTheme(_ customTheme: String){
        
       self.mapTheme = .custom
       try? mapView?.loadCustomStyleSheetAsync(customTheme)
    
        
    }
    
    
    public func getTheme()->MFTMapTheme {
        return self.mapTheme
    }

    
    /**
     Sets zoom controls visibility.
     - parameter show: True or False value inidicating zoom visibility.
     */

    
    public func setZoomControlVisibility(_ show: Bool){
       isZoomControlVisible = show
    }
    
    public func setRecenterVisibility(_ show: Bool){
        isRecenterControlVisible = show
    }
    
    
    /**
     Sets compass control visibility.
     - parameter show: True or False value inidicating compass visibility.
     */
    
    public func setCompassVisibility(_ show: Bool){
        isCompassVisible = show
    }
    

    internal init(mapView: MFTMapView){
        self.isCompassVisible = false
        self.isZoomControlVisible = false
        self.isRecenterControlVisible = false
        self.mapTheme = .day
        self.cameraType = TGCameraType.flat
        self.isPanEnabled = true
        self.isPinchEnabled = true
        self.isRotateEnabled = true
        self.isTiltEnabled = true
        self.is3DbuildingsEnabled = true
        self.minZoomLevel = 0
        self.maxZoomLevel = 20
        self.locationManager = MFTLocationProvider()
        self.mapView = mapView
        self.firstRun = 0
    }
    
    internal init(){
        self.isCompassVisible = false
        self.isZoomControlVisible = false
        self.isRecenterControlVisible = false
        self.mapTheme = .day
        self.cameraType = TGCameraType.flat
        self.isPanEnabled = true
        self.isPinchEnabled = true
        self.isRotateEnabled = true
        self.isTiltEnabled = true
        self.is3DbuildingsEnabled = true
        self.minZoomLevel = 0
        self.maxZoomLevel = 20
        self.locationManager = MFTLocationProvider()
        self.firstRun = 0
    }
}

public enum MFTLocationAccuracy {
    case high, low
}

extension MFTMapOptions : LocationCorrectionEngineDelegate, LocationManagerDelegate {
    
    
    
    /**
     Sets compass control visibility.
     - parameter show: True or False value inidicating compass visibility.
     */
    public func setUserLocationEnabled(_ show: Bool, accuracy: MFTLocationAccuracy){
        if show {
            locEngine.delegate = self
            locationManager.delegate = self
            
            if accuracy == .high {
                locationManager.coreLocationManager?.desiredAccuracy = kCLLocationAccuracyBest
            }else {
                locationManager.coreLocationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
            }
        
        } else {
            locEngine.delegate = nil
            locationManager.delegate = nil
        }
    }

    
    public func alphaLocationManager(alphaLocation: CLLocation) {
        print("ALPHA LOCATION = \(alphaLocation.coordinate)")
        userLocationDelegate?.didRecieveLocationUpdate(alphaLocation)
        self.lastLocation = alphaLocation

        self.currentLocationGem?.setPosition(alphaLocation.coordinate)
        self.accuracyCircle?.setPosition(alphaLocation.coordinate)
        
        
    }
    
    public func locationDidUpdate(_ location: CLLocation) {
        print("Location Did update in Map Options: \(location.coordinate)")
        if firstRun == 0 {
            guard let mapView = self.mapView else { return }
            self.accuracyCircle = mapView.addMarker(position: location.coordinate)
            if let circleImage = UIImage(named: "Radius", in: Bundle.houseStylesBundle(), compatibleWith: nil) {
                
                self.accuracyCircle?.setIcon(circleImage)
                self.accuracyCircle?.markerOptions?.setAnchorPosition(.center)
               
                self.lastLocation = location
                adjustAccuracyCircle()
                
            }
            self.currentLocationGem = mapView.addMarker(position: location.coordinate)
            self.firstRun = 1
            if let image = UIImage(named: "location", in: Bundle.houseStylesBundle(), compatibleWith: nil) {
                self.currentLocationGem?.setIcon(image)
                
                self.currentLocationGem?.markerOptions?.setAnchorPosition(.center)
                self.currentLocationGem?.markerOptions?.setDrawOrder(drawOrder: 1000)
            }
        }
        
        locEngine.addToSignalArray(location: location)
        //self.lastLocation = location
    }
    
    @objc internal func adjustAccuracyCircle(){
        
        guard let lastLocation = self.lastLocation else {return}
        guard let zoom = mapView?.getZoom() else { return }
        let pixelMeterValue = self.getPixelPerMeter(lat: lastLocation.coordinate.latitude, zoom: zoom)
        
 
         let sideLength = Int(65.0 / 2) * Int(pixelMeterValue)

         self.accuracyCircle?.markerOptions?.setWidth(width: sideLength)
         self.accuracyCircle?.markerOptions?.setHeight(height: sideLength)
        
    }
    
    internal func getPixelPerMeter(lat: Double, zoom: Float)->Double{
        let tileSize = 512
        let earthRadius = 6371009.0
        let pixelsPerTile = (CGFloat(tileSize) * 401) / 160
        
        let numTiles = pow(2.0, (mapView?.getZoom())! - 3)
        let metersPerTile = cos(Double(lat).degreesToRadians) * earthRadius / Double(numTiles)
        return  Double(pixelsPerTile) / metersPerTile
    }


    open func authorizationDidSucceed() {
        locationManager.startUpdatingLocation()
        locationManager.requestLocationUpdates()
    }

    open func authorizationDenied() {
        failedLocationAuthorization()
    }

    open func authorizationRestricted() {
        //For our uses, this is effectively the same handling as denied location authorization
        failedLocationAuthorization()
    }

    func failedLocationAuthorization() {
        guard let marker = currentLocationGem else { return }
        //TODO: handle error?
        mapView?.removeMarker(marker)
        return
    }
}


