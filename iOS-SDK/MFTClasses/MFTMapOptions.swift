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
     Indicates if user location button is enabled. Set by setUserLocationButtonVisibility.
     */
    public var isUserLocationButtonVisible: Bool {
        didSet {
            mapView?.toggleUserLocationButton()
            mapView?.userLocationButton.isEnabled = false
        }
    }
    
    /**
     Indicates whether user location is enabled. Set by setUserLocationEnabled.
     */
    internal var isUserLocationEnabled: Bool {
        didSet {
            
        }
    }
    
    
    
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
    public var isPanEnabled: Bool
    public var isPinchEnabled: Bool
    public var isRotateEnabled: Bool
    public var isTiltEnabled: Bool
    public var is3DbuildingsEnabled: Bool?
    private var maxZoomLevel: Float
    private var minZoomLevel: Float
    internal var currentLocationGem: MFTMarker?
    internal var accuracyCircle: MFTMarker?
    internal var directionPointer: MFTMarker?
    internal var lastLocation: CLLocation?
    internal var lastAccuracy: CLLocationAccuracy?
    private var firstRun: Int = 0
    internal var accuracyCircleTimer = Timer()
    internal var pointerTimer = Timer()
    internal var lastHeading: CLHeading?
    internal var accuracy: MFTLocationAccuracy?
    
    /// Location
    internal let locationManager: LocationManagerProtocol
    internal var locEngine = LocationCorrectionEngine()
    /// Receiver for location updates
    public weak var userLocationDelegate: LocationUpdateDelegate?
    let coreLocationManager = CLLocationManager()
    private var accuracyCircleDrawOrder = 2100
    private var userLocationDrawOrder = 2110
    
    
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
        self.mapTheme = theme
        try? mapView?.loadMapfitThemeAsync(theme)
    }
    
    public func setCustomTheme(_ customTheme: String){
        
       self.mapTheme = .custom
       try? mapView?.loadCustomThemeAsync(customTheme)
    
        
    }
    
    
    public func getTheme()->MFTMapTheme {
        return self.mapTheme
    }

    
    /**
     Sets zoom controls visibility.
     - parameter show: True or False value inidicating zoom visibility.
     */
    
    
    public func setUserLocationButtonVisibility(_ show: Bool){
        isUserLocationButtonVisible = show 
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
        self.locationManager.startUpdatingHeading()
    }
    

    internal init(mapView: MFTMapView){
        self.isCompassVisible = false
        self.isZoomControlVisible = false
        self.isRecenterControlVisible = false
        self.isUserLocationButtonVisible = false
        self.mapTheme = .day
        self.cameraType = TGCameraType.flat
        self.isPanEnabled = true
        self.isPinchEnabled = true
        self.isRotateEnabled = true
        self.isTiltEnabled = true
        self.is3DbuildingsEnabled = true
        self.isUserLocationEnabled = false
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
        self.isUserLocationButtonVisible = false
        self.mapTheme = .day
        self.cameraType = TGCameraType.flat
        self.isPanEnabled = true
        self.isPinchEnabled = true
        self.isRotateEnabled = true
        self.isTiltEnabled = true
        self.is3DbuildingsEnabled = true
        self.isUserLocationEnabled = false
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
    
    public func headingDidUpdate(_ heading: CLHeading) {
        
        if isCompassVisible {
            mapView?.updateCompass()
        }
        lastHeading = heading
    }
    
    @objc private func updatePointer(){
        guard let image = UIImage(named: "directionPointer", in: Bundle.houseStylesBundle(), compatibleWith: nil) else { return }
        
        if let heading = lastHeading?.trueHeading.degreesToRadians {
            let newImage = image.image(withRotation: CGFloat(heading))
            
            self.directionPointer?.setIcon(newImage)
  
        }
        
        
    }

    
    /**
     Sets compass control visibility.
     - parameter show: True or False value inidicating compass visibility.
     */
    public func setUserLocationEnabled(_ show: Bool, accuracy: MFTLocationAccuracy){
        locEngine.delegate = self
        locationManager.delegate = self
        
        if locationManager.isInUseAuthorized() {
        
        if show {
     
            isUserLocationEnabled = true
            isUserLocationButtonVisible = true
            mapView?.userLocationButton.isEnabled = true
            if accuracy == .high {
                locationManager.coreLocationManager?.desiredAccuracy = kCLLocationAccuracyBest
            }else {
                locationManager.coreLocationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
            }
        
        } else {
            locEngine.delegate = nil
            locationManager.delegate = nil
            mapView?.userLocationButton.isEnabled = false
            isUserLocationEnabled = false
            }
        
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }

    
    public func alphaLocationManager(alphaLocation: CLLocation) {
        print("ALPHA LOCATION = \(alphaLocation.coordinate)")
        userLocationDelegate?.didRecieveLocationUpdate(alphaLocation)
        self.lastLocation = alphaLocation

        self.currentLocationGem?.setPositionWithEase(alphaLocation.coordinate)
        self.accuracyCircle?.setPositionWithEase(alphaLocation.coordinate)
        self.directionPointer?.setPositionWithEase(alphaLocation.coordinate)
        
    }
    
    
    
    public func locationDidUpdate(_ location: CLLocation) {
        print("Location Did update in Map Options: \(location.coordinate)")
        if firstRun == 0 {
            self.firstRun = 1
            guard let mapView = self.mapView else { return }
            self.accuracyCircle = mapView.addMarker(position: location.coordinate)
            
            
            if let circleImage = UIImage(named: "Radius", in: Bundle.houseStylesBundle(), compatibleWith: nil) {

                self.accuracyCircle?.setIcon(circleImage)
                self.accuracyCircle?.markerOptions?.setAnchorPosition(.center)
                self.accuracyCircle?.markerOptions?.setFlat(true)
                self.accuracyCircle?.markerOptions?.setDrawOrder(drawOrder: accuracyCircleDrawOrder)
                self.lastLocation = location
                adjustAccuracyCircle()
                
            }
            
            self.currentLocationGem = mapView.addMarker(position: location.coordinate)
            
            if let image = UIImage(named: "location", in: Bundle.houseStylesBundle(), compatibleWith: nil) {
                self.currentLocationGem?.setIcon(image)
                self.currentLocationGem?.markerOptions?.setAnchorPosition(.center)
                self.currentLocationGem?.markerOptions?.setDrawOrder(drawOrder: userLocationDrawOrder)
                self.currentLocationGem?.markerOptions?.setFlat(true)
                
            }
            
            self.directionPointer = mapView.addMarker(position: location.coordinate)
            
            if let image = UIImage(named: "directionPointer", in: Bundle.houseStylesBundle(), compatibleWith: nil) {
                self.directionPointer?.setIcon(image)
                self.directionPointer?.markerOptions?.setAnchorPosition(.center)
                self.directionPointer?.markerOptions?.setDrawOrder(drawOrder: userLocationDrawOrder)
                self.directionPointer?.markerOptions?.setFlat(true)
                
            }

            self.pointerTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updatePointer), userInfo: nil, repeats: true)
            self.accuracyCircleTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(adjustAccuracyCircle), userInfo: nil, repeats: true)
            
 
        }
        
        locEngine.addToSignalArray(location: location)
        self.lastLocation = location
        
    }

    
    @objc internal func adjustAccuracyCircle(){


    
       // DispatchQueue.global(qos: .background).sync {
            guard let lastLocation = self.lastLocation else {return}
            guard let zoom = self.mapView?.getZoom() else { return }
            
            
            let pixelMeterValue = self.getPixelPerMeter(lat: lastLocation.coordinate.latitude, zoom: zoom)
            
            
            if lastLocation.horizontalAccuracy == 0 {
                guard let accuracy = lastAccuracy else { return }
                let sideLength = Int(accuracy / 2 * pixelMeterValue)
                self.accuracyCircle?.markerOptions?.updateSize(height: sideLength, width: sideLength)
            }else {
                lastAccuracy = lastLocation.horizontalAccuracy
                let sideLength = Int(lastLocation.horizontalAccuracy / 2 * pixelMeterValue)
                self.accuracyCircle?.markerOptions?.updateSize(height: sideLength, width: sideLength)
            }


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
        self.setUserLocationEnabled(true, accuracy: accuracy ?? .low)
        mapView?.userLocationButton.isEnabled = true
        firstRun = 0
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
        
        guard let accuracyMarker = accuracyCircle else { return }
        mapView?.removeMarker(accuracyMarker)

        mapView?.userLocationButton.isEnabled = false
        
        return
    }

}






