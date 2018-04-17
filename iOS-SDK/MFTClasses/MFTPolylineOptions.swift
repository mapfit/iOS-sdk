//
//  MFTPolylineOptions.swift
//  iOS-GL-Test
//
//  Created by Zain N. on 4/9/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import Foundation

@objc(MFTPolylineOptions)
public class MFTPolylineOptions : NSObject, MFTPolyPointOptions{
    
    //The stroke width of the marker -- pixels
    public var strokeWidth: Int {
        didSet {
            self.polyline.updateProperties()
        }
    }
    //The stroke outline width of the marker -- pixels
    public var strokeOutlineWidth: Int {
        didSet {
            self.polyline.updateProperties()
        }
    }
    //The stroke color of the polyline -- pixels
    public var strokeColor: String {
        didSet {
            self.polyline.updateProperties()
        }
    }
    
    //The fill color for the polyline
    public var strokeOutlineColor: String {
        didSet {
            self.polyline.updateProperties()
        }
    }
    
    // Sets the draw order for the polyline. The draw order is relative to other annotations. Note that higher values are drawn above lower ones.
    public var drawOrder: Int {
        didSet {
            self.polyline.updateProperties()
        }
    }
    
    public var lineCapType: MFTLineCapType {
        didSet {
            self.polyline.updateProperties()
        }
    }
    
    public var lineJoinType: MFTLineJoinType {
        didSet {
            self.polyline.updateProperties()
        }
    }
    
    internal var polyline: MFTPolyline
    
    //Default Init
    internal init(_ polyline: MFTPolyline) {
        self.polyline = polyline
        strokeWidth = -1
        strokeColor = "default"
        strokeOutlineColor = "default"
        strokeOutlineWidth = -1
        drawOrder = Int.min
        lineJoinType = .miter
        lineCapType = .bound
        super.init()
        
    }
}

