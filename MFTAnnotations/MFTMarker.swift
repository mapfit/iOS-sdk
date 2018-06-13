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

/**
 `MFTMarker` A marker is an icon placed at a particular position on the map.
 */
@objc(MFTMarker)
public class MFTMarker : NSObject, MFTAnnotation {
    
    public var uuid: UUID
    public var mapView: MFTMapView?
    public var width: Int
    public var height: Int
    public var address: Address?
    public var streetAddress: String
    public var anchor: MFTAnchorPosition
    public var building: Bool
    
    /**
     Position of marker. Can only be changed by calling 'setPosition(position: CLLocationCoordinate2D)'.
     */
    
    public var position: CLLocationCoordinate2D

    public var tag: Any
    public var buildingPolygon: MFTPolygon?
    
    public var drawOrder: Int {
        didSet {
            createStyle()
        }
    }
    /**
     Visibility of marker. Can only be changed by calling 'setVisibility(show: Bool)'.
     */

    public var isVisible: Bool {
        didSet {
            createStyle()
        }
    }
    
    public var isFlat: Bool{
        didSet {
            createStyle()
        }
    }
    public var isInteractive: Bool{
        didSet {
            createStyle()
        }
    }
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
    
    internal var tgMarker: TGMarker?  {
        didSet {
            tgMarker?.visible = isVisible
            tgMarker?.point = TGGeoPoint(coordinate: position)
            tgMarker?.drawOrder = drawOrder
            restoreIcon()
            createStyle()
        }
        
    }
    
    /**
     Initial style set for marker.
     */
    
    public var style: MFTAnnotationStyle

    /**
     Icon of marker. Can only be changed by calling one of the 'setIcon' methods.
     */
    public var icon: UIImage?
    
    /**
     Changes the coordinate of the marker.
     - parameter position: The coordinate of the marker.
     */

    
    
    
    public init(markerOptions: MFTMarkerOptions){

        self.uuid = UUID()
        self.style = .point
        self.width = markerOptions.width
        self.height = markerOptions.height
        self.address = markerOptions.address
        self.streetAddress = markerOptions.streetAddress
        self.position = markerOptions.position ?? CLLocationCoordinate2DMake(0.0, 0.0)
        self.tag = markerOptions.tag as Any
        self.anchor = markerOptions.anchorPosition
        self.building = markerOptions.building
        self.buildingPolygon = MFTPolygon(polygonOptions: markerOptions.buildingPolygonOptions ?? MFTPolygonOptions())
        self.drawOrder = markerOptions.drawOrder
        self.isVisible = markerOptions.visible
        self.isFlat = markerOptions.flat
        self.isInteractive = markerOptions.interactive
        super.init()
        self.title = markerOptions.title
        self.subtitle1 = markerOptions.subTitle1
        self.subtitle2 = markerOptions.subTitle2
        self.handleIconSetting(markerOptions)
        self.createStyle()
    }
    
    internal func setMapView(_ mapView: MFTMapView){
        self.mapView = mapView
    }
    
    
    internal func geocode(completion:@escaping (_ marker: MFTMarker?, _ errror: Error?)->Void){
        MFTGeocoder.sharedInstance.geocode(address: streetAddress, includeBuilding: building) { (addresses, error) in
            if error == nil {
                guard let addressObject = addresses else { return }
                
                let response = MFTGeocoder.sharedInstance.parseAddressObjectForPosition(addressObject: addressObject)
                guard let position = response.0 else { return }
                self.position = position
                
                DispatchQueue.main.async {
                    let address = addressObject[0]

                        if let streetAddress = address.streetAddress{
                            self.streetAddress = streetAddress
                        }
                    
                    self.address = address
                    
                    //add building polygon
                    if let building = address.building{
                        if let _ = building.coordinates {
                            guard let polygonCoordinates = building.coordinates else { return }
                            for point in polygonCoordinates[0]{
                                self.buildingPolygon?.addPoint(CLLocationCoordinate2DMake(point[1], point[0]))
                            }

                            if var annotations = self.subAnnotations {
                                annotations["building"] = self.buildingPolygon
                            }else{
                                self.subAnnotations = ["building" : self.buildingPolygon as! MFTAnnotation]
                            }
                            
                        }
                    }
                    completion(self, nil)
                }
                
                
            } else {
                completion(nil, error)
            }
            
        }
    }
    
    
    internal func reverseGeocode(completion:@escaping (_ marker: MFTMarker?, _ errror: Error?)->Void){
        MFTGeocoder.sharedInstance.reverseGeocode(latLng: position, includeBuilding: true) { (addresses, error) in
            if error == nil {
                guard let addressObject = addresses else { return }
                
                let response = MFTGeocoder.sharedInstance.parseAddressObjectForPosition(addressObject: addressObject)
                guard let position = response.0 else { return }
                self.position = position
                
                DispatchQueue.main.async {
                    let address = addressObject[0]
                    
                        if let streetAddress = address.streetAddress{
                            self.streetAddress = streetAddress
                        }
                    
                    self.address = address
                    
                    //add building polygon
                    if let building = address.building{
                        if let _ = building.coordinates {
                            guard let polygonCoordinates = building.coordinates else { return }
                            for point in polygonCoordinates[0]{
                                self.buildingPolygon?.addPoint(CLLocationCoordinate2DMake(point[1], point[0]))
                            }
                            
                            if var annotations = self.subAnnotations {
                                annotations["building"] = self.buildingPolygon
                            }else{
                                self.subAnnotations = ["building" : self.buildingPolygon as! MFTAnnotation]
                            }
                            
                        }
                    }
                    completion(self, nil)
                
                }
            }else {
                    completion(nil, error)

            }
            
        }
    }
    
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
            return mapView.tgMapView.lngLat(toScreenPosition: TGGeoPointMake(self.getPosition().longitude, self.getPosition().latitude))
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
    
    /**
     Sets the icon image for the marker.
     - parameter mapfitMarker: MapfitMarker that will be used for the marker icon.
     */
    public func setSize(width: Int, height: Int){
        self.height = height
        self.width = width
        createStyle() 
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
    
    
    private func createStyle(){
        guard let marker = tgMarker else { return }
        marker.stylingString = "{ style: sdk-point-overlay, anchor: \(self.anchor.rawValue), size: [\(self.width)px, \(self.height)px], interactive: \(self.isInteractive), collide: false, flat: \(self.isFlat)}"
    }

    
    private func handleIconSetting(_ markerOptions: MFTMarkerOptions){
        if let url = markerOptions.imageURL {
            self.setIcon(url)
        }
        
        if let mapfitMarker = markerOptions.mapfitMarker {
            self.setIcon(mapfitMarker)
        }
        
        if let image = markerOptions.image {
            self.setIcon(image)
        }

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

