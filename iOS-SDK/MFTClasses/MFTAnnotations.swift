//
//  MFTAnnotation.swift
//  iOS.SDK
//
//  Created by Zain N. on 1/10/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import Foundation

/**
 `MFTAnnotationSyle` default style for polylines, polygons and markers.
 */
public enum MFTAnnotationStyle : String {
    case point = "{ style: 'sdk-point-overlay', anchor: top, color: 'white', size: [55px, 45px], order: 20000, interactive: true, collide: false }"
    case polyline = "{ style: 'lines', color: '#dc3983', width: 5px, order: 2000 }"
    case polygon = "{ style: 'polygons', color: '#06a6d4', width: 5px, order: 2000 }"
}



/**
 `MFTAnnotation` Base protocol for polylines, polygons and markers.
 */

public protocol MFTAnnotation {

    /**
     Unique Identifier for the annotation.
     */
    var uuid: UUID { get set }
   
    /**
     Visibility of annotation. Can only be changed by calling 'setVisibility(show: Bool)'.
     */
    var isVisible: Bool { get set }
    
    
    /**
    Style of the annotation.
     */
     var style: MFTAnnotationStyle { get set }
    
    
    /**
     Sets visibility of the annotation.
     - parameter show: True or False value indicating the visibility.
     */
    func setVisibility(show: Bool)
    
}
