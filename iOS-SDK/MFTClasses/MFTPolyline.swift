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
    //The stroke color of the polyline -- pixels
    public var strokeWidth: Int {
        didSet {
            mapView?.updatePolylineStyle(self)
        }
    }
    
    //The stroke outline width of the polyline -- pixels
    public var strokeOutlineWidth: Int {
        didSet {
            mapView?.updatePolylineStyle(self)
        }
    }
    
    //The stroke color of the polyline -- pixels
    public var strokeColor: String {
        didSet {
            mapView?.updatePolylineStyle(self)
        }
    }
    
    
    //The fill color for the polyline
    public var strokeOutlineColor: String {
        didSet {
            mapView?.updatePolylineStyle(self)
        }
    }
    
    // Sets the draw order for the polyline. The draw order is relative to other annotations. Note that higher values are drawn above lower ones.
    public var drawOrder: Int {
        didSet {
            mapView?.updatePolylineStyle(self)
        }
    }
    
    public var lineCapType: MFTLineCapType {
        didSet {
            mapView?.updatePolylineStyle(self)
        }
    }
    
    public var lineJoinType: MFTLineJoinType {
        didSet {
            mapView?.updatePolylineStyle(self)
        }
    }
    
    
    
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
            guard let tg  = tgPolyline else { return }
            for point in points {
                tg.add(TGGeoPoint(longitude: point.longitude, latitude: point.latitude))
            }
            
            tgMarker?.polyline = tg
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
    public var points: [CLLocationCoordinate2D] = []
    
    
    public func addPoints(_ points: [CLLocationCoordinate2D]){
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
        for coordinate in self.points{
                latLngBounds.add(latLng: coordinate)
        }
        
        return latLngBounds.build()
    }
    
    public func updateProperties() {
        guard let mapView = self.mapView else { return }
        mapView.updatePolylineStyle(self)
    }
    
    
    
    public init(polylineOptions: MFTPolylineOptions) {
        self.strokeWidth = polylineOptions.strokeWidth
        self.strokeColor = polylineOptions.strokeColor
        self.strokeOutlineColor = polylineOptions.strokeOutlineColor
        self.strokeOutlineWidth = polylineOptions.strokeOutlineWidth
        self.drawOrder = polylineOptions.drawOrder
        self.lineJoinType = polylineOptions.lineJoinType
        self.lineCapType = polylineOptions.lineCapType
        self.style = MFTAnnotationStyle.polyline
        self.points = polylineOptions.points
        self.uuid = UUID()
        self.isVisible = true
        super.init()
    }
    
}


