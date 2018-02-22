//
//  MFTLayer.swift
//  iOS.SDK
//
//  Created by Zain N. on 12/28/17.
//  Copyright © 2017 Mapfit. All rights reserved.
//

import Foundation
import TangramMap
import CoreLocation

/**
 `MFTLayer` This is a layer containing MFTAnnotations that can be added and removed from the map.
 */

public class MFTLayer  {
    /**
     Unique identifier for the layer.
     */
    public var uuid: UUID = UUID()
    
    public var isVisible: Bool
    
    /**
     Bounds for layer.
     */
    public var latLngBounds: MFTLatLngBounds?
    
    internal var drawOrder: Int
    
    internal var mapViews: [MFTMapView]
    
    public var annotations: [MFTAnnotation] = [MFTAnnotation]()

    /**
     Places layer on mapView
     
     - parameter mapView: mapView that will  display annotations in this layer.
     */

    public func bindToMap(mapView: MFTMapView){
        self.mapViews.append(mapView)
    }
    
    /**
     removes layer from a mapView
     
     - parameter mapView: mapView that will remove annotations in this layer.
     */

    
    public func removeFromMap(mapView: MFTMapView){
        mapView.removeLayer(layer: self)
        for (index, map) in mapViews.enumerated() {
            if map.uuid == mapView.uuid {
                self.mapViews.remove(at: index)
            }
        }
    }
    
    /**
     Sets the visibility of the layer.
     parameter show: True or False value setting layer's visibility.
     */
    
    public func setVisibility(show: Bool){
        isVisible = show
        for annotation in self.annotations {
            annotation.setVisibility(show: show)
        }
    }
    
    /**
     Sets the visibility of the layer.
     returns: True or False value of layer's visibility.
     */
    
    public func getVisibility()-> Bool {
        return self.isVisible
    }

    /**
     Adds annotation to the layer.
     -parameter annotation: Annotation to be added to the layer.
     */
    
    
    public func add(annotation: MFTAnnotation){
        annotations.append(annotation)
        for mapView in mapViews {
            mapView.addAnnotation(annotation)
        }
    }
    
    
    /**
     Adds annotations to the layer.
     -parameter annotations: Annotations to be added to the layer.
     */
    
    public func add(with annotations: [MFTAnnotation]){
        for annotation in annotations {
            self.annotations.append(annotation)
        }
        
        for mapView in mapViews {
            mapView.addAnnotations(annotations)
        }
    }
    
    
    /**
     removes annotation from the layer.
     -parameter annotation: Annotation to be removed from the layer.
     */
    public func remove(annotation: MFTAnnotation){
        
        for (index, ann) in annotations.enumerated() {
            if ann.uuid == annotation.uuid {
                self.annotations.remove(at: index)
            }
        }
        
        for mapView in mapViews {
            mapView.removeAnnotation(annotation)
        }
    }
    
    /**
     removes annotations from the layer.
     -parameter annotations: Annotations to be removed from the layer.
     */
    
    public func remove(with annotations: [MFTAnnotation]){
        for mapView in mapViews {
            mapView.removeAnnotations(self.annotations)
        }
    }
    

    /**
     Return current annotations in the layer.
     returns: Annotations inside the layer.
     */
    
    public func getAnnotations()->[MFTAnnotation]{
        return annotations
    }
    
    /**
     removes current annotations in the layer.
     */
    
     public func clear(){
        remove(with: self.annotations)
        self.annotations.removeAll()
    }
    
    /**
     Sets the draw order for the layer. The draw order is relative to other layers. Note that higher values are drawn above lower ones.
     - parameter index: The value for the draw order.
     */
    
    public func setDrawOrder(index : Int){
        self.drawOrder = index
    }
    
    /**
     Returns the draw order for the layer.
     - returns: The value for the draw order.
     */

    public func getDrawOrder() -> Int{
        return drawOrder
    }
    
    
//    public func getLatLngBounds() -> MFTLatLngBounds {
////        var latLngBounds = MFTLatLngBounds.Builder()
////        
////    
////        
////        
////        return latLngBounds.build()
//        
//    }
//    
    
    public init(){
        self.isVisible = true
        self.drawOrder = 100
        self.mapViews = []
    }
}

extension MFTLayer : Equatable {
    public static func ==(lhs: MFTLayer, rhs: MFTLayer) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}































