//
//  MFTMapOptions.swift
//  iOS.SDK
//
//  Created by Zain N. on 1/5/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import Foundation
import TangramMap

/**
 `MFTMapOptions` This is the class that controls options for MFTMapView.
 */
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

    
    public var mapTheme: MFTMapTheme
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
        guard let theme = styles[theme] else { print("Could not load theme")
            return
        }
        try? mapView?.loadMFTStyleSheetAsync(theme   ) { (style) in
           
        }
        
    }

    private func setTheme(filepath: String) {

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
    }
}

