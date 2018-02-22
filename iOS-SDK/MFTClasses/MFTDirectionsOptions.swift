  //
//  MFTDirectionsOptions.swift
//  iOS.SDK
//
//  Created by Zain N. on 2/9/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import Foundation
import CoreLocation
import TangramMap

  /**
   `MFTDirectionsType` public enum used in to determine the transit type of a route.
   */
  
  public enum MFTDirectionsType : String {
    case cycling = "cycling"
    case driving = "driving"
    case walking = "walking"
  }

/**
 `MFTDirectionsOptions` This is the class that controls directions on the mapview.
 */
public class MFTDirectionsOptions {
   public  var isVisible: Bool
   private var origin: CLLocationCoordinate2D?
   private var destination: CLLocationCoordinate2D?
    private var originAddress: String?
    private var destinationAddress: String?
   public var directionsType: MFTDirectionsType
   public var mapView: MFTMapView?

    /**
     Sets origin point for the directions view.
     - parameter position: The origin coordinate for the directions view.
     */
    public func setOrigin(_ position: CLLocationCoordinate2D){
        self.origin = position
    }
    
    /**
     Sets origin point for the directions view given an address.
     - parameter address: The string representation of the address to be geocoded.
     */
    public func setOrigin(_ address: String){
        self.originAddress = address
    }
    
    /**
     Sets destination point for the directions view.
     - parameter position: The destination coordinate for the directions view.
     */
    public func setDestination(_ position: CLLocationCoordinate2D){
        self.destination = position
    }
    
    
    /**
     Sets destination point for the directions view given an address. Returns a marker initialized with that position.
     - parameter address: The string representation of the address to be geocoded.
     - returns: The marker that has been added to the map at the destination point.
     */
    public func setDestination(_ address: String){
       self.destinationAddress = address
    }

    
    /**
     Sets transit type of the route that will be drawn on the directions view.
     - parameter type: The transit type of the route.
     */
    public func setType(_ type: MFTDirectionsType){
        self.directionsType = type
    }
    
    /**
     Shows route from origin to destination points. Note: The destination and origin must be set.
     - returns: Optional polyline object or optional error.
     */
    
    public func showDirections(completion:@escaping (_ polyline: MFTPolyline?, _ error: Error?)->Void){
            MFTDirections.sharedInstance.route(origin: origin, originAddress: originAddress, destination: destination, destinationAddress: destinationAddress, includesBuilding: true, directionsType: directionsType) { (routeObject, error) in
                if error == nil {
                    guard let route = routeObject else { return }
                    self.drawRoute(route: route, completion: { (polyline, error) in
                        if error == nil {
                            completion(polyline, nil)
                        }
                    })
                } else {
                    completion(nil, error)
                }
            }
    }

    /**
     Draws route givin a route object.
     - returns: Optional polyline object or optional error.
     */
    
    public func drawRoute(route: RouteObject, completion:@escaping (_ polyline: MFTPolyline?, _ error: Error?)->Void){
        
        guard let trip = route.trip else { return }
        guard let legs = trip.legs else { return }
        guard let shape = legs[0].shape else { return }
        guard let path = decodePolyline(shape) else { return }
        

        let polyline = mapView?.addPolyline([path])
        completion(polyline, nil)
        
    }
    
    
    public func setVisibility(_ visible: Bool){
        self.isVisible = visible
    }

    internal func setMapView(_ mapView: MFTMapView) {
        self.mapView = mapView
    }
    
    internal init(){
        self.isVisible = true
        self.directionsType = .driving
        
    }
    
}
