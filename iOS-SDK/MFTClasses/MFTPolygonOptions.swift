//
//  MFTPolygonOptions.swift
//  iOS-GL-Test
//
//  Created by Zain N. on 4/9/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import Foundation

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

@objc(MFTPolyPointOptions)
public protocol MFTPolyPointOptions {
    var strokeWidth: Int { get set }
    var strokeOutlineWidth: Int { get set }
    var strokeColor: String { get set }
    var strokeOutlineColor: String { get set }
    var drawOrder: Int { get set }
}



@objc(MFTPolygonOptions)
public class MFTPolygonOptions : NSObject, MFTPolyPointOptions{
    //The stroke width of the marker -- pixels
    public var strokeWidth: Int {
        didSet {
            self.polygon.updateProperties()
        }
    }
    //The stroke outline width of the marker -- pixels
    public var strokeOutlineWidth: Int {
        didSet {
            self.polygon.updateProperties()
        }
    }
    //The stroke color of the polygon -- pixels
    public var strokeColor: String {
        didSet {
            self.polygon.updateProperties()
        }
    }
    //The fill color for the polygon
    public var fillColor: String {
        didSet {
            self.polygon.updateProperties()
        }
    }
    
    //The fill color for the polygon
    public var strokeOutlineColor: String {
        didSet {
            self.polygon.updateProperties()
        }
    }
    
    // Sets the draw order for the polygon. The draw order is relative to other annotations. Note that higher values are drawn above lower ones.
    public var drawOrder: Int {
        didSet {
            self.polygon.updateProperties()
        }
    }
    
    public var lineCapType: MFTLineCapType {
        didSet {
            self.polygon.updateProperties()
        }
    }
    
    public var lineJoinType: MFTLineJoinType {
        didSet {
            self.polygon.updateProperties()
        }
    }
    //The polygon object to apply options
    public var polygon: MFTPolygon
    
    //Default Init
    internal init(_ polygon: MFTPolygon) {
        self.polygon = polygon
        strokeWidth = -1
        strokeColor = "default"
        fillColor = "default"
        strokeOutlineColor = "default"
        strokeOutlineWidth = -1
        drawOrder = Int.min
        lineCapType = .bound
        lineJoinType = .miter
        super.init()
        
    }
}

