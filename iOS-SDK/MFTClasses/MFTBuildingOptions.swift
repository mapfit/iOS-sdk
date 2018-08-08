//
//  MFTBuildingOptions.swift
//  Mapfit
//
//  Created by Zain N. on 7/23/18.
//

import Foundation
import CoreLocation

public class MFTBuildingOptions : NSObject, MFTPolyPointOptions {

    internal var fillColor: String
    internal var extrudeOutline: Bool = false
    
    //The stroke color of the polyline -- pixels
    internal var strokeWidth: Int
    //The stroke outline width of the polyline -- pixels
    internal var strokeOutlineWidth: Int
    //The stroke color of the polyline -- pixels
    internal var strokeColor: String
    
    //The fill color for the polyline
    internal var strokeOutlineColor: String
    // Sets the draw order for the polyline. The draw order is relative to other annotations. Note that higher values are drawn above lower ones.
    internal var drawOrder: Int

    internal var lineJoinType: MFTLineJoinType
    internal var points: [[CLLocationCoordinate2D]]
    
    
    func extrudeOutline(_ extrude: Bool) {
        
    }
    
    public func setFillColor(_ color: String) {
        self.fillColor = color
    }
    
    public func setStrokeWidth(_ width: Int) {
        self.strokeWidth = width
    }
    
    public func setOutlineWidth(_ width: Int) {
        self.strokeOutlineWidth = width
    }
    
    public func setStrokeColor(_ color: String) {
        self.strokeColor = color
    }
    
    public func setStrokeOutlineColor(_ color: String) {
        self.strokeOutlineColor = color
    }
    
    public func setDrawOrder(_ order: Int) {
        self.drawOrder = order
    }

    public func addPoints(_ points: [[CLLocationCoordinate2D]]) {
        self.points = points
    }
    
    
    public func setLineJoinType(_ type: MFTLineJoinType) {
        
    }
    
    public func setLineCapType(_ type: MFTLineCapType) {
        
    }

    override public init (){
        strokeWidth = Int.min
        strokeColor = ""
        fillColor = ""
        strokeOutlineColor = ""
        strokeOutlineWidth = Int.min
        drawOrder = Int.min
        points = [[]]
        lineJoinType = .miter
        super.init()
    }
    
    
}
