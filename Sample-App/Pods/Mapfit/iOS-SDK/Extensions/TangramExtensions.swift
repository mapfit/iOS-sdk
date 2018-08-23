//
//  TangramExtensions.swift
//  iOS.SDK
//
//  Created by Zain N. on 12/5/17.
//  Copyright © 2017 Mapfit. All rights reserved.
//


import Foundation
import TangramMap
import CoreLocation


/// Convenience extension to convert between the different coordinate systems in use
internal extension TGGeoPoint {
    /**
     Creates a TGGeoPoint from a CoreLocation coordinate struct.
     
     - parameter coordinate: The CLLocationCoordinate2D struct to use.
     - returns: A TGGeoPoint structure.
     */
    internal init(coordinate: CLLocationCoordinate2D) {
        self.init(longitude: coordinate.longitude, latitude: coordinate.latitude)
    }
    
    
    /**
     Create a TGGeoPoint from a CoreLocation location object
     
     - parameter location: The location object to use
     - returns: A TGGeoPoint structure.
     */
    internal init(location: CLLocation) {
        self.init(coordinate: location.coordinate)
    }
}

//internal extension TGGeoPoint: Equatable {
//    internal static func == (lhs: TGGeoPoint, rhs: TGGeoPoint) -> Bool {
//        return
//            lhs.latitude == rhs.latitude &&
//                lhs.longitude == rhs.longitude
//    }
//}




