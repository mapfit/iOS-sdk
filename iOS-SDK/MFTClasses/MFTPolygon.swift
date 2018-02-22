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
        /**
         Initial style of the annotation(polyine, polygon, or marker).
         */
        public var style: MFTAnnotationStyle
        
        /**
         Unique identifier for the polygon.
         */
        
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
                guard let l  = tgPolygon else { return }
                tgMarker?.polygon = l
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
    
        override init() {
            self.isVisible = true
            self.style = MFTAnnotationStyle.polygon
            self.uuid = UUID()
            super.init()
        }

}
