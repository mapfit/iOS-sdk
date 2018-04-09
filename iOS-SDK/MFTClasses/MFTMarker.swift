//
//  NEWMFTMarker.swift
//  iOS.SDK
//
//  Created by Zain N. on 12/19/17.
//  Copyright © 2017 Mapfit. All rights reserved.
//

import Foundation
import TangramMap
import CoreLocation

public enum MFTAnchorPosition : String {
    case top = "top"
    case bottom = "bottom"
    case center = "center"
}

@objc(MFTMarkerOptions)
public class MFTMarkerOptions : NSObject{
    //set width of the marker -- pixels
    public var width: Int
    //set height of the marker -- pixels
    public var height: Int
    //Marker for map options
    internal var marker: MFTMarker
    // Sets the draw order for the marker. The draw order is relative to other annotations. Note that higher values are drawn above lower ones.
    public var drawOrder: Int
    internal var color: String
    public var flat: Bool
    internal var interactive: Bool
    
    
    // Set Anchor
    public var anchorPosition: MFTAnchorPosition
    
    /**
     Sets the height for the marker icon.
     
     - parameter height: height of marker icon.
     */
    public func setHeight(
        height: Int){
        self.height = height
        marker.setStyle()
    }
    
    /**
     Sets anchor position of marker.
     
     - parameter position: position of marker icon.
     */
    internal func setAnchorPosition(_ position: MFTAnchorPosition){
        self.anchorPosition = position
        marker.setStyle()
    }
    
    /**
     Sets the width for the marker icon.
     
     - parameter width: width of marker icon.
     */
    
    public func setWidth(width: Int){
        self.width = width
        marker.setStyle()
    }
    /**
     Sets the color for the marker icon.
     
     - parameter color: color of marker icon.
     */
    
    public func setDrawOrder(drawOrder: Int){
        self.drawOrder = drawOrder
        marker.tgMarker?.drawOrder = drawOrder
    }
    /**
     Sets the color for the marker icon.
     
     - parameter color: color of marker icon.
     */
    internal func setColor(color: String) {
        self.color = color
        marker.setStyle()
    }
    
    internal func setFlat(_ flat: Bool) {
        self.flat = flat
        marker.setStyle()
    }
    
    
    
    internal func updateSize(height: Int, width: Int){
        self.height = height
        self.width = width
        marker.setStyle()
    }
    
    internal func setInteractivity(_ interactive: Bool){
        self.interactive = interactive
        marker.setStyle()
    }
    
    //Default Init
    internal init(_ marker: MFTMarker) {
        height = 59
        width = 55
        drawOrder = 2000
        anchorPosition = .top
        color = "white"
        flat = false
        interactive = true
        self.marker = marker
        
        super.init()
        
    }
}



/**
 `MFTMarker` A marker is an icon placed at a particular position on the map.
 */
@objc(MFTMarker)
public class MFTMarker : NSObject, MFTAnnotation {
    
    public var uuid: UUID
    public var mapView: MFTMapView?
    
    /**
     Title of Marker.
     */
    
    lazy public var title: String = ""
    
    /**
     First subtitle for Marker.
     */
    
    lazy public var subtitle1: String = ""
    
    /**
     Second subtitle for Marker.
     */
    
    lazy public var subtitle2: String = ""
    
    internal var subAnnotations: [String : MFTAnnotation]?
    
    public var buildingPolygon: MFTPolygon?
    
    internal var tgMarker: TGMarker?  {
        didSet {
            tgMarker?.visible = isVisible
            tgMarker?.point = TGGeoPoint(coordinate: position)
            tgMarker?.drawOrder = 2000
            setStyle()
        }
        
    }
    
    /**
     Options used to set style for marker.
     */
    
    
    public var markerOptions: MFTMarkerOptions? {
        didSet {
            setStyle()
        }
    }
    
    /**
     Initial style set for marker.
     */
    
    public var style: MFTAnnotationStyle {
        didSet {
            setStyle()
        }
    }
    
    /**
     Visibility of marker. Can only be changed by calling 'setVisibility(show: Bool)'.
     */
    
    public var isVisible: Bool
    
    
    /**
     Position of marker. Can only be changed by calling 'setPosition(position: CLLocationCoordinate2D)'.
     */
    
    public var position: CLLocationCoordinate2D
    
    
    /**
     Icon of marker. Can only be changed by calling one of the 'setIcon' methods.
     */
    public var icon: UIImage?
    
    /**
     Changes the coordinate of the marker.
     - parameter position: The coordinate of the marker.
     */
    
    private var workItem: DispatchWorkItem?
    
    public func setPosition(_ position: CLLocationCoordinate2D){
        self.position = position
        tgMarker?.point = TGGeoPoint(coordinate: position)
    }
    
    /**
     Returns the coordinate of the marker.
     - returns: The coordinate of the marker.
     */
    
    public func getPosition()->CLLocationCoordinate2D{
        return position
    }
    
    internal func getScreenPosition()->CGPoint {
        if let mapView = self.mapView {
            return mapView.mapView.lngLat(toScreenPosition: TGGeoPointMake(self.getPosition().longitude, self.getPosition().latitude))
        } else {
            return CGPoint(x: 0, y: 0)
        }
    }
    
    /**
     Sets the icon image for the marker.
     - parameter image: image for marker icon.
     */
    public func setIcon(_ image: UIImage){
        workItem?.cancel()
        self.icon = image
        tgMarker?.icon = image
    }
    
    internal func showAnchor(){
        DispatchQueue.main.async {
            let anchor = UIImage(named: "anchor.png", in: Bundle.houseStylesBundle(), compatibleWith: nil)
            self.tgMarker?.icon = anchor!
        }
    }
    
    internal func restoreIcon(){
        DispatchQueue.main.async {
            
            guard let icon = self.icon else { return }
            self.tgMarker?.icon = icon
        }
    }
    
    /**
     Sets the icon image for the marker.
     - parameter urlString: URL for marker icon.
     */
    public func setIcon(_ urlString: String){
        workItem?.cancel()
        workItem = DispatchWorkItem { self.loadImage(urlString) }
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: workItem!)
    }
    
    /**
     Sets the icon image for the marker.
     - parameter mapfitMarker: MapfitMarker that will be used for the marker icon.
     */
    public func setIcon(_ mapfitMarker: MFTMarkerImage){
        workItem?.cancel()
        workItem = DispatchWorkItem { self.loadImage(mapfitMarker.rawValue) }
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: workItem!)
        
    }
    
    
    //private function for loading image from URLString
    private func loadImage(_ imageString: String) {
        guard let url = URL(string: imageString) else { print("No link provided for image")
            return}
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { print("No image located at this link")
                return
            }//make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                
                if let image = UIImage(data: data) {
                    self.setIcon(image)
                }
                
            }
        }
    }
    
    /**
     Sets the style for the marker based on the markerOptions.
     */
    @objc public func setStyle() {
        guard let marker = tgMarker else { return }
        if let options = markerOptions {
            marker.stylingString = generateStyle(options)
        } else {
            marker.stylingString =  style.rawValue
        }
        
    }
    
    private func generateStyle(_ markerOptions: MFTMarkerOptions) -> String{
        return "{ style: 'sdk-point-overlay', color: \(markerOptions.color), anchor: \(markerOptions.anchorPosition.rawValue), size: [\(markerOptions.width)px, \(markerOptions.height)px], interactive: \(markerOptions.interactive), collide: false, flat: \(markerOptions.flat)}"
    }
    
    /**
     Sets the visibility of the marker.
     parameter show: True or False value setting markers visibility.
     */
    
    @objc public func setVisibility(show: Bool) {
        tgMarker?.visible = show
    }
    
    @objc public func getVisibility()->Bool {
        return tgMarker?.visible ?? false
    }
    
    
    
    internal init(position: CLLocationCoordinate2D, mapView: MFTMapView) {
        self.position = position
        self.isVisible = true
        self.style = MFTAnnotationStyle.point
        self.uuid = UUID()
        self.mapView = mapView
        super.init()
        self.setIcon(.defaultPin)
        self.markerOptions = MFTMarkerOptions(self)
        
        
    }
    
    internal init(address: String, mapView: MFTMapView) {
        self.position = CLLocationCoordinate2DMake(0.0, 0.0)
        self.isVisible = true
        self.style = MFTAnnotationStyle.point
        self.uuid = UUID()
        self.mapView = mapView
        super.init()
        self.setIcon(.defaultPin)
        self.getPositionFromAddress(Address: address)
        self.markerOptions = MFTMarkerOptions(self)
        
    }
    
    internal init(position: CLLocationCoordinate2D, icon: MFTMarkerImage, mapView: MFTMapView) {
        self.position = position
        self.isVisible = true
        self.style = MFTAnnotationStyle.point
        self.uuid = UUID()
        self.mapView = mapView
        super.init()
        self.markerOptions = MFTMarkerOptions(self)
        self.setIcon(icon)
        
    }
    
    private func getPositionFromAddress(Address: String){
        MFTGeocoder.sharedInstance.geocode(address: Address, includeBuilding: true) { (addressesObject, error) in
            if error == nil {
                guard let addressObject = addressesObject else { return }
                
                if let entrances = addressObject[0].entrances {
                    guard let lat = entrances[0].lat else { return }
                    guard let lon = entrances[0].lng else { return }
                    self.setPosition(CLLocationCoordinate2DMake(lat, lon))
                }
                
                if let location = addressObject[0].location {
                    guard let lat = location.lat else { return }
                    guard let lon = location.lng else { return }
                    self.setPosition(CLLocationCoordinate2DMake(lat, lon))
                }
                
            }
        }
        
    }
    
    
    public func getBuildingPolygon()->MFTPolygon? {
        return subAnnotations?["building"] as? MFTPolygon
    }
    
    internal func setPositionWithEase(_ position: CLLocationCoordinate2D) {
        tgMarker?.pointEased(TGGeoPointMake(position.longitude, position.latitude), seconds: 0.01, easeType: .cubic)
        
    }
    
}


/**
 Animates the marker from its current coordinates to the ones given.
 
 - parameter coordinates: Coordinates to animate the marker to
 - parameter seconds: Duration in seconds of the animation.
 - parameter ease: Easing to use for animation.
 */
//    public func setPointEased(_ coordinates: TGGeoPoint, seconds: Float, easeType ease: TGEaseType) -> Bool {
//        tgMarker?.pointEased(coordinates, seconds: seconds, easeType: ease)
//        //TODO: Add error management back in here once we're doing it everywhere correctly.
//        return true



/**
 Default icons provided by Mapfit.
 */


public enum MFTMarkerImage : String {
    
    case defaultPin = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/default.png"
    case active = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/active.png"
    case airport = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/airport.png"
    case arts = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/arts.png"
    case auto = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/auto.png"
    case finance = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/finance.png"
    case commercial = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/commercial.png"
    case cafe = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/cafe.png"
    case conference = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/conference.png"
    case sports = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/sports.png"
    case education = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/education.png"
    case market = "lhttps://cdn.mapfit.com/m1/assets/images/markers/pngs/ighttheme/market/png"
    case cooking = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/cooking.png"
    case gas = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/gas.png"
    case homegarden = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/homegarden.png"
    case hospital = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/hospital.png"
    case hotel = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/hotel.png"
    case law = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/law.png"
    case medical = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/medical.png"
    case bar = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/bar.png"
    case park = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/park.png"
    case pharmacy = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/pharmacy.png"
    case community = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/community.png"
    case religion = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/religion.png"
    case restaurant = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/restaurant.png"
    case shopping = "https://cdn.mapfit.com/m1/assets/images/markers/pngs/lighttheme/shopping.png"
    
}

