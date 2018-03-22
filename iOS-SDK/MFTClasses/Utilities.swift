//
//  Utilities.swift
//  GeoFiSDK
//
//  Created by Randall Lee on 4/20/17.
//  Copyright © 2017 Parkour Method. All rights reserved.
//

import UIKit
import CoreLocation



 // MARK: FKA PKCalc
public class Utilities: NSObject {
    static let PKPi = 3.14159265358979323 // 84626433832795028841971693993
    
    
    public func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    /**
     Radians from degrees
     - parameter coordinate: coordinate to convert
     - returns: radians as Double
     */
    func rfd(degrees: Double) -> Double {
        return (degrees * 0.01745329251)
    }
    
    /**
     Degrees from radians
     - parameter coordinate: coordinate to convert
     - returns: degrees as Double
     */
    func dfr(radians: Double) -> Double {
        return (radians * 57.2957795131)
    }
    
    /**
     Recompute ellipsoidal r for each new coordinate's latitude
     - parameter datum: coordinate latitude
     - returns: recomputed ellipsoidal radius as Double
     */
    func geoRadius(datum: Double) -> Double {
        let l = datum
        let a = Double(6378137)
        let b = 6356752.314245
        let An = a*a*cos(l)
        let Bn = b*b*sin(l)
        let Ad = a*cos(l)
        let Bd = b*sin(l)
        
        return sqrt((An*An + Bn*Bn)/(Ad*Ad + Bd*Bd))
    }
    
    /**
     Azimuth - horizontal angle or direction of a compass bearing.
     - parameter locOne: first location object to calculate azimuth from
     - parameter locTwo: second location object to calculate azimuth from
     - returns: azimuth as Double
     */
    func azimuth(locOne: CLLocation, locTwo: CLLocation) -> Double {
        var b2 = locOne.coordinate.latitude
        var b3 = locTwo.coordinate.latitude
        var c2 = locOne.coordinate.longitude
        var c3 = locTwo.coordinate.longitude
        if ((b2 == 0) || (b3 == 0) || (c2 == 0) || (c3 == 0)) { return 1.111 }
        
        b2 = rfd(degrees: b2)
        b3 = rfd(degrees: b3)
        c2 = rfd(degrees: c2)
        c3 = rfd(degrees: c3)
        
        let azimuth = fmod(dfr(radians: (atan2(sin((c3)-(c2))*cos(b3),cos(b2)*sin(b3)-sin(b2)*cos(b3)*cos((c3)-(c2))))+360), 360)
        return azimuth
    }
    
    /**
     equirectangular approximation for distance
     - parameter locOne: first location to get distance from.
     - parameter locTwo: second location to get distance from.
     - returns: distance as double
     */
    func distanceCalc(locOne: CLLocation, locTwo: CLLocation) -> Double {
        let theR = geoRadius(datum: locOne.coordinate.latitude)
        let dLat = (rfd(degrees: locOne.coordinate.latitude) - rfd(degrees: locTwo.coordinate.latitude))
        let dLon = (rfd(degrees: locOne.coordinate.longitude) - rfd(degrees: locTwo.coordinate.longitude))
        
        let x = dLon * cos((rfd(degrees: locOne.coordinate.latitude) + rfd(degrees: locTwo.coordinate.latitude)) / 2)
        let distance = sqrt((x*x) + (dLat*dLat)) * theR
        
        return fabs(distance)
    }
    
    /**
     Convert array of converted location objects into an alpha location object (must be converted to a core location before use)
     - parameter signals: Array of converted location objects.
     - returns: alpha location object
     */
    func alphaPoint(signals: [PositionObject]) -> PositionObject {
        var ps = 0.0,pc = 0.0,ph = 0.0,pv = 0.0,vpx = 0.0,vpy = 0.0,vpz = 0.0
        var vwHrA = 0.0
        
        for var point in signals {
            if (point.pHa < 1) { point.pHa = 1 }
            vwHrA += (1/point.pHa)
            vpx += (point.pX*(1/point.pHa))
            vpy += (point.pY*(1/point.pHa))
            vpz += (point.pZ*(1/point.pHa))
            ps += point.pVe
            pc += point.pC
            ph += point.pHa
            pv += point.pVa
        }
        
        var alpha = PositionObject()
        if (vwHrA < 0.0001) { vwHrA = 1.0 }
        alpha.pX = vpx/vwHrA
        alpha.pY = vpy/vwHrA
        alpha.pZ = vpz/vwHrA
        alpha.pHa = 2
        alpha.pVa = 2
        alpha.pVe = signals.last!.pVe
        alpha.pT = signals.last!.pT
        /*PZDEBUG*/// NSLog(@"returning alpha...");
        return alpha
    }
    
    /**
     Convert CLLocation to PositionObject after recomputing the earth's ellipsoidal radius for the new latitude
     - parameter location: core location object
     - returns: converted location object as PositionObject
     */
    public func locationToCartesian(location: CLLocation) -> PositionObject {
        let pRad = geoRadius(datum: location.coordinate.latitude)
        let pXtt = rfd(degrees: location.coordinate.latitude)
        let pYtt = rfd(degrees: location.coordinate.longitude)
        
        var pObj = PositionObject()
        pObj.pX = pRad*cos(pXtt)*cos(pYtt)
        pObj.pT = location.timestamp.timeIntervalSince1970 * 1000
        pObj.pY = pRad*cos(pXtt)*sin(pYtt)
        pObj.pZ = pRad*sin(pXtt)
        pObj.pHa = location.horizontalAccuracy
        if (pObj.pHa == 0) { pObj.pHa = -1 }
        pObj.pVa = location.verticalAccuracy
        if (pObj.pVa == 0) { pObj.pVa = -1 }
        pObj.pVe = location.speed
        
        return pObj
    }
    
    /**
     PositionObject to CLLocation calculation
     - FKA export
     - parameter pObj: PositionObject to convert back to a core location object
     - returns: corrected core location object
     */
    func cartesianToLocation(pObj: PositionObject) -> CLLocation {
        let lat = dfr(radians: (atan2(pObj.pZ, (sqrt((pObj.pX * pObj.pX) + (pObj.pY * pObj.pY))))))
        let lon = dfr(radians: (atan2(pObj.pY, pObj.pX)))
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let location = CLLocation.init(coordinate: coordinate, altitude: pObj.pA, horizontalAccuracy: pObj.pHa, verticalAccuracy: pObj.pVa, course: pObj.pC, speed: pObj.pVe, timestamp: Date())
        
        return location
    }
}













