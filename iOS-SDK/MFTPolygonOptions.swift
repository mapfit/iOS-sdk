//
//  MFTPolygonOptions.swift
//  iOS-GL-Test
//
//  Created by Zain N. on 4/9/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import Foundation

@objc(MFTPolygonOptions)
public class MFTPolygonOptions : NSObject{
    //The stroke width of the marker -- pixels
    internal var strokeWidth: Int
    //The stroke outline width of the marker -- pixels
    internal var strokeOutlineWidth: Int
    //The stroke color of the polygon -- pixels
    internal var strokeColor: String
    //The fill color for the polygon
    internal var fillColor: String
    
    //The fill color for the polygon
    internal var strokeOutlineColor: String
    
    // Sets the draw order for the polygon. The draw order is relative to other annotations. Note that higher values are drawn above lower ones.
    public var drawOrder: Int
    //The polygon object to apply options
    internal var polygon: MFTPolygon
    
    
    /**
     Sets stroke width of polygon.
     
     - parameter width: width of polygon.
     */
    public func setStrokeWidth(_ width: Int){
        self.strokeWidth = width
        self.polygon.updateProperties()
        
    }
    
    /**
     gets stroke width of polygon.
     
     - return: width of polygon.
     */
    
    public func getStrokeWidth() -> Int{
        return strokeWidth
        
    }
    
    /**
     Sets stroke outline width of polygon.
     
     - parameter width: stroke outline width of polygon.
     */
    public func setStrokeOutlineWidth(_ width: Int){
        self.strokeOutlineWidth = width
        self.polygon.updateProperties()
        
    }
    
    /**
     gets stroke outline width of polygon.
     
     - return: stroke outline width of polygon.
     */
    
    public func getStrokeOutlineWidth() -> Int{
        return strokeOutlineWidth
        
        
    }
    
    /**
     Sets stroke color of polygon.
     
     - parameter color: stroke color of polygon.
     */
    public func setStrokeColor(_ color: String){
        self.strokeColor = color
        self.polygon.updateProperties()
        
    }
    
    /**
     gets stroke color of polygon.
     
     - return: stroke color of polygon.
     */
    
    public func getStrokeColor() -> String{
        return self.strokeColor
        
    }
    
    /**
     Sets fill color of polygon.
     
     - parameter color: fill color of polygon.
     */
    public func setFillColor(_ color: String){
        self.fillColor = color
        self.polygon.updateProperties()
        
    }
    
    
    /**
     gets stroke width of polygon.
     
     - return: fill color of polygon.
     */
    
    public func getFillColor() -> String{
        return self.fillColor
        
    }
    
    /**
     Sets stroke outline color of polygon.
     
     - parameter color: sets stroke outline color of polygon.
     */
    public func setStrokeOutlineColor(_ color: String){
        self.strokeOutlineColor = color
        self.polygon.updateProperties()
    }
    
    /**
     gets stroke outline color of polygon.
     
     - return: stroke outline color of polygon.
     */
    
    public func getStrokeOutlineColor() -> String{
        return self.strokeOutlineColor
        
    }
    
    
    /**
     Sets the color for the marker icon.
     
     - parameter color: color of marker icon.
     */
    
    public func setDrawOrder(drawOrder: Int){
        self.drawOrder = drawOrder
        
    }
    
    /**
     Sets the color for the marker icon.
     
     - parameter color: color of marker icon.
     */
    public func getDrawOrder() -> Int {
        return drawOrder
        
    }
    
    //Default Init
    internal init(_ polygon: MFTPolygon) {
        self.polygon = polygon
        strokeWidth = -1
        strokeColor = "default"
        fillColor = "default"
        strokeOutlineColor = "default"
        strokeOutlineWidth = -1
        drawOrder = 2000
        super.init()
        
    }
}
