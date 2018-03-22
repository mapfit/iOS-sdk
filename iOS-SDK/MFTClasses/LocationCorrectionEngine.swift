//
//  LocationCorrectionEngine.swift
//  MapfitSDK
//
//  Created by Randall Lee on 4/20/17.
//  Copyright © 2018 Mapfit Method. All rights reserved.
//

import UIKit
import CoreLocation

public struct PositionObject {
    var pX : Double = 0.0
    var pY : Double = 0.0
    var pZ : Double = 0.0
    var pVa : Double = 0.0
    var pHa : Double = 0.0
    var pVe : Double = 0.0
    var pA : Double = 0.0
    var pC : Double = 0.0
    var pT : Double = 0.0
}


public protocol LocationCorrectionEngineDelegate : class {
    func alphaLocationManager(alphaLocation: CLLocation)
}

//TODO: Add accuracy check

@objc public class LocationCorrectionEngine: NSObject {
    public var delegate : LocationCorrectionEngineDelegate?
    var signalArray = [PositionObject]()
    let util = Utilities()
    let maxSignals = 3 // max signals to add to signalArray before calculating alpha point
    
    /**
     Add to Signal Array holds up to th ree locations then converts locations to a more accurate alpha location.
     - parameter location: the location that is appended to signal array
     - signalArray: array holding CLLocations
    */
    public func addToSignalArray(location: CLLocation) {
        
        //if location isn't passable then return
        if locationPassable(location: location) {

        } else {
            return
        }
        
        
        let newObj = util.locationToCartesian(location: location)
        
        while signalArray.count > maxSignals { // remove any position objects when count is over x
            signalArray.remove(at: signalArray.count - 1)
        }
        
        signalArray.append(newObj)
        if signalArray.count >= maxSignals {
            if util.cartesianToLocation(pObj: signalArray.last!).distance(from: location) > 200 {
                //empty array if distance from the last location is over 200 meters
                signalArray.removeAll(keepingCapacity: true)
            } else {
                let alphaPoint = util.alphaPoint(signals: signalArray)
                let finalLoc = util.cartesianToLocation(pObj: alphaPoint)
                
                delegate?.alphaLocationManager(alphaLocation: finalLoc)
            }
        }
    }
    
    private func locationPassable(location: CLLocation) -> Bool {
        if location.horizontalAccuracy >= 100 {
            return false
        }
        
        return true
    }

}
