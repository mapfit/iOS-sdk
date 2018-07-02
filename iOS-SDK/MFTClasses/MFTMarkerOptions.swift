//
//  MFTMarkerOptions.swift
//  Mapfit
//
//  Created by Zain N. on 5/14/18.
//

import Foundation
import CoreLocation

@objc(MFTMarkerOptions)
public class MFTMarkerOptions : NSObject{
    //set width of the marker -- pixels
    internal var width: Int
    //set height of the marker -- pixels
    internal var height: Int
    //Marker for map options
    internal var address: Address?
    //Street address
    internal var streetAddress: String
    //Geocode Address
    internal var geocode: Bool
    
    internal var position: CLLocationCoordinate2D?
    
    internal var reverseGeocode: Bool
    
    internal var flat: Bool
    
    // Sets the draw order for the marker. The draw order is relative to other annotations. Note that higher values are drawn above lower ones.
    internal var drawOrder: Int
    
    internal var interactive: Bool
    
    internal var building: Bool
    
    internal var buildingPolygonOptions: MFTPolygonOptions?
    
    internal var visible: Bool
    
    internal var title: String
    
    internal var subTitle1: String
    
    internal var subTitle2: String
    
    internal var mapfitMarker: MFTMarkerImage?
    
    internal var image: UIImage?
    
    internal var imageURL: String?
    
    internal var tag: Any?
    
    internal var anchorPosition: MFTAnchorPosition
    
    /**
     Sets the height for the marker icon.
     - parameter height: height of marker icon.
     */
    public func setHeight(
        height: Int){
        self.height = height
    }
    
    /**
     Sets the width for the marker icon.
     - parameter width: width of marker icon.
     */
    
    public func setWidth(width: Int){
        self.width = width
    }
    
    /**
     Sets the street address for the marker icon.
     - parameter streetAddress: Street Address of marker icon.
     - parameter geocode: Bool that determines whether or not to geocode the street address.
     */
    public func setStreetAddress(streetAddress: String, geocode: Bool) {
        self.streetAddress = streetAddress
        self.geocode = geocode
    }
    
    /**
     Sets the position for the marker icon.
     - parameter position: position of marker icon.
     - parameter reverseGeocode: Bool that determines whether or not to reverse geocode the marker position.
     */
    public func setPosition(position: CLLocationCoordinate2D, reverseGeocode: Bool){
        self.position = position
        self.reverseGeocode = reverseGeocode
    }
    
    /**
     Sets whether or not the marker is flat.
     - parameter flat: Bool indicating whether maker will be flat.
     */
    public func setFlat(_ flat: Bool) {
        self.flat = flat
        
    }
    /**
     Sets tag for marker.
     - parameter flat: Bool indicating whether maker will be flat.
     */
    public func setTag(_ tag: Any) {
        self.tag = tag
    }
    /**
     Sets if the building polygon for the marker should be displayed.
     - parameter building: Bool indicating whether polygon will be displayed.
     - parameter options: Polygon options for building polygon.
     */
    public func addBuildingPolygon(_ building: Bool, options: MFTPolygonOptions) {
        self.building = building
        self.buildingPolygonOptions = options
    }
    
    /**
     Sets interactivity for the marker.
     - parameter interactive: Bool representing interactivity of the marker.
     */
    public func setInteractivity(_ interactive: Bool){
        self.interactive = interactive
    }
    
    /**
     Sets visibility of the marker.
     - parameter visible: Bool representing visibility of the marker.
     */
    public func setVisibility(_ visible: Bool){
        self.visible = visible
    }
    
    
    /**
     Sets anchor position of marker.
     - parameter position: anchor position of marker icon.
     */
    public func setAnchorPosition(_ position: MFTAnchorPosition){
        self.anchorPosition = position
    }
    /**
     Sets draw order of the marker.
     - parameter drawOrder: draw order of the marker icon.
     */
    public func setDrawOrder(drawOrder: Int){
        self.drawOrder = drawOrder
    }
    
    /**
     Sets the title for the place information.
     - parameter title: Title text.
     */
    public func setTitle(_ title: String) {
        self.title = title
    }
    
    /**
     Sets the first subtitle for the place information.
     - parameter subTitle1: Subtitle text.
     */
    public func setSubTitle1(_ subTitle1: String) {
        self.subTitle1 = subTitle1
    }
    
    /**
     Sets the second subtitle for the place information.
     - parameter subTitle2: Subtitle text.
     */
    public func setSubTitle2(_ subTitle2: String) {
        self.subTitle2 = subTitle2
    }
    
    /**
     Sets the icon image for the marker.
     - parameter mapfitMarker: MFTMarker image for marker icon.
     */
    public func setIcon(_ mapfitMarker: MFTMarkerImage){
        self.mapfitMarker = mapfitMarker
    }
    
    /**
     Sets the icon image for the marker.
     - parameter urlString: Url string for marker icon.
     */
    public func setIcon(_ urlString: String){
        self.imageURL = urlString
    }
    
    /**
     Sets the icon image for the marker.
     - parameter image: image for marker icon.
     */
    public func setIcon(_ image: UIImage){
        self.image = image
    }
    
    
    public override init(){
        height = 59
        width = 55
        drawOrder = 2000
        anchorPosition = .top
        streetAddress = ""
        title = ""
        subTitle1 = ""
        subTitle2 = ""
        flat = true
        interactive = true
        building = false
        visible = true
        geocode = false
        reverseGeocode = false
        flat = false
        interactive = true
        building = false
        visible = true
        self.tag = nil
        super.init()
    }
}
