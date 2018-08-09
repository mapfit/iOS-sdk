//
//  RouteEvaluator.swift
//  Mapfit
//
//  Created by Zain N. on 8/9/18.
//

import Foundation
import CoreLocation

public class RouteEvaluator {
    
    func evaluate(t: Float, startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let lat = startPoint.latitude + Double(t) * (endPoint.latitude - startPoint.latitude)
        let lng = startPoint.longitude + Double(t) * (endPoint.longitude - startPoint.longitude)
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    
}
