 //
 //  MFTPolygon.swift
 //  iOS.SDK
 //
 //  Created by Zain N. on 2/12/18.
 //  Copyright © 2018 Mapfit. All rights reserved.
 //
 
 import Foundation
 import TangramMap
 import CoreLocation
 
 
 
 /**
  `MFTPolygon` This is the class for a polygon that exists on the map.
  */
 
 @objc(MFTPolygon)
 public class MFTPolygon : NSObject, MFTAnnotation {
    //The stroke color of the polygon -- pixels
    public var strokeWidth: Int {
        didSet {
            mapView?.updatePolygonStyle(self)
        }
    }
    //The stroke outline width of the polygon -- pixels
    public var strokeOutlineWidth: Int {
        didSet {
            mapView?.updatePolygonStyle(self)
        }
    }
    //The stroke color of the polygon -- pixels
    public var strokeColor: String {
        didSet {
            mapView?.updatePolygonStyle(self)
        }
    }    //The fill color for the polygon
    public var fillColor: String {
        didSet {
            mapView?.updatePolygonStyle(self)
        }
    }
    //The fill color for the polygon
    public var strokeOutlineColor: String {
        didSet {
            mapView?.updatePolygonStyle(self)
        }
    }
    // Sets the draw order for the polygon. The draw order is relative to other annotations. Note that higher values are drawn above lower ones.
    public var drawOrder: Int {
        didSet {
            mapView?.updatePolygonStyle(self)
        }
    }
    public var lineCapType: MFTLineCapType {
        didSet {
            mapView?.updatePolygonStyle(self)
        }
    }
    public var lineJoinType: MFTLineJoinType {
        didSet {
            mapView?.updatePolygonStyle(self)
        }
    }
    
    /**
     Initial style of the annotation(polyine, polygon, or marker).
     */
    public var style: MFTAnnotationStyle
    
    /**
     Unique identifier for the polygon.
     */
    
    public var polygonOptions: MFTPolygonOptions?
    
    internal var mapView: MFTMapView?
    
    
    public var uuid: UUID
    
    internal var tgMarker: TGMarker? {
        didSet {
            if let polygon = tgPolygon { tgMarker?.polygon = polygon }
            tgMarker?.visible = isVisible
            tgMarker?.stylingPath = ""
            tgMarker?.stylingString = style.rawValue
        }
    }
    
    /// The polygon that should be displayed on the map.
    internal var tgPolygon: TGGeoPolygon?  {
        didSet {
            guard let tg = tgPolygon else { return }
            
            for point in points[0]  {
                tg.add(TGGeoPoint(longitude: point.longitude, latitude: point.latitude))
            }
            
            tgMarker?.polygon = tg
            setStyle()
        }
    }
    
    
    /**
     Visibility of polygon. Can only be changed by calling 'setVisibility(show: Bool)'.
     */
    
    public var isVisible: Bool
    
    
    /**
     Returns an array of the points defining the polyline outline.
     */
    public var points: [[CLLocationCoordinate2D]] = [[]]
    
    
    /**
     Adds new point to the polygon.
     - parameter point: The new point to be drawn in the polygon.
     */
    public func addPoints(_ points: [[CLLocationCoordinate2D]]){
        self.points = points
    }
    
    public func addPoint(_ point: CLLocationCoordinate2D){
        self.points[0].append(point)
    }
    
    
    /**
     Sets the style for the marker based on the markerOptions.
     */
    
    @objc public func setStyle() {
        guard let marker = tgMarker else { return }
        marker.stylingString =  style.rawValue
    }
    
    
    /**
     Sets the visibility of the polygon.
     parameter show: True or False value setting polygons visibility.
     */
    
    public func setVisibility(show: Bool) {
        isVisible = show
        tgMarker?.visible = show
    }
    
    /**
     gets the visibility of the polygon.
     */
    
    public func getVisibility()-> Bool{
        return isVisible
    }
    
    public func remove(){
        tgPolygon?.removeAll()
        
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
        mapView.updatePolygonStyle(self)
    }
    
    
    public init(polygonOptions: MFTPolygonOptions) {
        self.strokeWidth = polygonOptions.strokeWidth
        self.strokeColor = polygonOptions.strokeColor
        self.strokeOutlineColor = polygonOptions.strokeOutlineColor
        self.strokeOutlineWidth = polygonOptions.strokeOutlineWidth
        self.fillColor = polygonOptions.fillColor
        self.drawOrder = polygonOptions.drawOrder
        self.lineJoinType = polygonOptions.lineJoinType
        self.lineCapType = polygonOptions.lineCapType
        self.style = MFTAnnotationStyle.polygon
        self.points = polygonOptions.points
        
        self.uuid = UUID()
        self.isVisible = true
        super.init()
    }
    
    
 }

