//
//  MFTPolygonOptions.swift
//  iOS-GL-Test
//
//  Created by Zain N. on 4/9/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import Foundation
import CoreLocation

public enum MFTLineCapType : String {
    case bound = "0"
    case square = "2"
    case round = "6"
}

public enum MFTLineJoinType : String {
    case miter = "0"
    case bevel = "1"
    case round = "5"
}

@objc(MFTPolygonOptions)
public class MFTPolygonOptions : NSObject, MFTPolyPointOptions{

    
    //The stroke color of the polygon -- pixels
    internal var strokeWidth: Int
    //The stroke outline width of the polygon -- pixels
    internal var strokeOutlineWidth: Int
    //The stroke color of the polygon -- pixels
    internal var strokeColor: String
    //The fill color for the polygon
    internal var fillColor: String
    //The fill color for the polygon
    internal var strokeOutlineColor: String
    // Sets the draw order for the polygon. The draw order is relative to other annotations. Note that higher values are drawn above lower ones.
    internal var drawOrder: Int
    internal var lineCapType: MFTLineCapType
    internal var lineJoinType: MFTLineJoinType
    internal var points: [[CLLocationCoordinate2D]]
    
    public func setStrokeWidth(_ width: Int){
        self.strokeWidth = width
    }


    public func setOutlineWidth(_ width: Int){
        self.strokeOutlineWidth = width
    }
    

    public func setStrokeColor(_ color: String) {
        self.strokeColor = color
    }
    

    public func setFillColor(_ color: String) {
        self.fillColor = color
    }

    public func setStrokeOutlineColor(_ color: String) {
        self.strokeOutlineColor = color
    }

    public func setDrawOrder(_ order: Int){
        self.drawOrder = order
    }
    

    public func setLineCapType(_ type: MFTLineCapType){
        self.lineCapType = type
    }
    
    public func setLineJoinType(_ type: MFTLineJoinType){
        self.lineJoinType = type
    }
    
    /**
     Adds new point to the polygon.
     - parameter point: The new point to be drawn in the polygon.
     */
    public func addPoints(_ points: [[CLLocationCoordinate2D]]){
        self.points = points
    }

   override public init (){
        strokeWidth = 3
        strokeColor = "#32b3ff"
        fillColor = "#2732b3ff"
        strokeOutlineColor = "#5932b3ff"
        strokeOutlineWidth = 3
        drawOrder = 501
        lineCapType = .bound
        lineJoinType = .round
        points = [[]]
        super.init()
    }
}

