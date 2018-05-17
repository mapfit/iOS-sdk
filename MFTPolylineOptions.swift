//
//  MFTPolylineOptions.swift
//  iOS-GL-Test
//
//  Created by Zain N. on 4/9/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import Foundation
import CoreLocation

@objc(MFTPolylineOptions)
public class MFTPolylineOptions : NSObject, MFTPolyPointOptions{
    
    //The stroke color of the polyline -- pixels
    public var strokeWidth: Int
    //The stroke outline width of the polyline -- pixels
    public var strokeOutlineWidth: Int
    //The stroke color of the polyline -- pixels
    public var strokeColor: String

    //The fill color for the polyline
    public var strokeOutlineColor: String
    // Sets the draw order for the polyline. The draw order is relative to other annotations. Note that higher values are drawn above lower ones.
    public var drawOrder: Int
    public var lineCapType: MFTLineCapType
    public var lineJoinType: MFTLineJoinType
    public var points: [[CLLocationCoordinate2D]]
    
    public func addpoints(_ points: [[CLLocationCoordinate2D]]){
        self.points = points
    }

    public func setStrokeWidth(_ width: Int){
        self.strokeWidth = width
    }
    
    public func setOutlineWidth(_ width: Int){
        self.strokeOutlineWidth = width
    }
    
    
    public func setStrokeColor(_ color: String) {
        self.strokeColor = color
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

//Default Init
override public init() {
    strokeWidth = 3
    strokeColor = "#32b3ff"
    strokeOutlineColor = "#5932b3ff"
    strokeOutlineWidth = 8
    drawOrder = 501
    lineCapType = .bound
    lineJoinType = .round
    points = [[]]
    super.init()
    
}
}

