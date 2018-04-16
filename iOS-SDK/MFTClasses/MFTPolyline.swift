//
//  MFTPolyline.swift
//  iOS.SDK
//
//  Created by Zain N. on 2/4/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import Foundation
import TangramMap
import CoreLocation

/**
 `MFTPolyline` This is the class for a polyline that exists on the map.
 */

@objc(MFTPolyline)
public class MFTPolyline : NSObject, MFTAnnotation {
    
    internal var dataLayer: TGMapData?
    
    internal var mapView: MFTMapView?
    
    /**
     Initial style of the annotation(polyine, polygon, or marker).
     */
    public var style: MFTAnnotationStyle
    
    /**
     Unique identifier for the polyline.
     */
    
    public var uuid: UUID
    
    public var polylineOptions: MFTPolylineOptions?
    
    
    internal var tgMarker: TGMarker? {
        didSet {
            if let line = tgPolyline { tgMarker?.polyline = line }
            tgMarker?.visible = isVisible
            tgMarker?.stylingPath = "layers.mz_route_line.draw.ux-route-line-overlay"
            setStyle()
        }
    }
    
    /// The polyline that should be displayed on the map.
    internal var tgPolyline: TGGeoPolyline?  {
        didSet {
            guard let l  = tgPolyline else { return }
            tgMarker?.polyline = l
            setStyle()
        }
    }
    
    
    
    /**
     Visibility of marker. Can only be changed by calling 'setVisibility(show: Bool)'.
     */
    
    public var isVisible: Bool
    
    /**
     Adds new point to the polyline.
     - parameter point: The new point to be drawn in the polyline.
     */
    
    
    
    /**
     Returns an array of the points defining the polyline outline.
     */
    public var points: [[CLLocationCoordinate2D]] = [[]]
    
    
    public func addPoints(_ points: [[CLLocationCoordinate2D]]){
        self.points = points
    }
    
    /**
     Sets the style for the marker based on the markerOptions.
     */
    
    @objc public func setStyle() {
        guard let marker = tgMarker else { return }
        marker.stylingString =  style.rawValue
    }
    
    
    
    /**
     Sets the visibility of the polyline.
     parameter show: True or False value setting polylines visibility.
     */
    
    public func setVisibility(show: Bool) {
        isVisible = show
        tgMarker?.visible = show
    }
    
    
    public func getLatLngBounds()->MFTLatLngBounds{
        var latLngBounds = MFTLatLngBounds.Builder()
        for point in self.points{
            for coordinate in point {
                latLngBounds.add(latLng: coordinate)
            }
        }
        
        return latLngBounds.build()
    }
    
    public func updateProperties() {
        guard let mapView = self.mapView else { return }
        mapView.updatePolylineStyle(self)
    }
    
    
    
    override init() {
        self.isVisible = true
        self.style = MFTAnnotationStyle.polyline
        self.uuid = UUID()
        
        super.init()
        self.polylineOptions = MFTPolylineOptions(self)
        
    }
    
    init(mapView: MFTMapView) {
        self.isVisible = true
        self.style = MFTAnnotationStyle.polyline
        self.uuid = UUID()
        self.mapView = mapView
        super.init()
        self.polylineOptions = MFTPolylineOptions(self)
        
    }
    
}


