//
//  MFTPolylineOptions.swift
//  iOS-GL-Test
//
//  Created by Zain N. on 4/9/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import Foundation

@objc(MFTPolylineOptions)
public class MFTPolylineOptions : NSObject{
    //The stroke width of the marker -- pixels
    internal var strokeWidth: Int
    //The stroke outline width of the marker -- pixels
    internal var strokeOutlineWidth: Int
    //The stroke color of the polyline -- pixels
    internal var strokeColor: String
    //The fill color for the polyline
    internal var fillColor: String

    //The fill color for the polyline
    internal var strokeOutlineColor: String
    
    // Sets the draw order for the polyline. The draw order is relative to other annotations. Note that higher values are drawn above lower ones.
    public var drawOrder: Int
    //The polyline object to apply options
    internal var polyline: MFTPolyline
    
    
    /**
     Sets stroke width of polyline.
     
     - parameter width: width of polyline.
     */
    public func setStrokeWidth(_ width: Int){
        self.strokeWidth = width
        self.polyline.updateProperties()
        
    }
    
    /**
     gets stroke width of polyline.
     
     - return: width of polyline.
     */
    
    public func getStrokeWidth() -> Int{
        return strokeWidth
       
    }
    
    /**
     Sets stroke outline width of polyline.
     
     - parameter width: stroke outline width of polyline.
     */
    public func setStrokeOutlineWidth(_ width: Int){
        self.strokeOutlineWidth = width
        self.polyline.updateProperties()
        
    }
    
    /**
     gets stroke outline width of polyline.
  
     - return: stroke outline width of polyline.
     */
    
    public func getStrokeOutlineWidth() -> Int{
        return strokeOutlineWidth
       
        
    }
    
    /**
     Sets stroke color of polyline.
     
     - parameter color: stroke color of polyline.
     */
    public func setStrokeColor(_ color: String){
        self.strokeColor = color
        self.polyline.updateProperties()
        
    }
    
    /**
     gets stroke color of polyline.
     
     - return: stroke color of polyline.
     */
    
    public func getStrokeColor() -> String{
        return self.strokeColor
        
    }
    
    /**
     Sets fill color of polyline.
     
     - parameter color: fill color of polyline.
     */
    public func setFillColor(_ color: String){
        self.fillColor = color
        self.polyline.updateProperties()
        
    }

    
    /**
     gets stroke width of polyline.
     
     - return: fill color of polyline.
     */
    
    public func getFillColor() -> String{
        return self.fillColor
        
    }

    /**
     Sets stroke outline color of polyline.
     
     - parameter color: sets stroke outline color of polyline.
     */
    public func setStrokeOutlineColor(_ color: String){
        self.strokeOutlineColor = color
        self.polyline.updateProperties()
    }
    
    /**
     gets stroke outline color of polyline.
     
     - return: stroke outline color of polyline.
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
    internal init(_ polyline: MFTPolyline) {
        self.polyline = polyline
        strokeWidth = -1
        strokeColor = "default"
        fillColor = "default"
        strokeOutlineColor = "default"
        strokeOutlineWidth = -1
        drawOrder = 2000
        super.init()
        
    }
}
