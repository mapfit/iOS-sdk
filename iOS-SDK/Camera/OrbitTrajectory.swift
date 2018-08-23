//
//  OrbitTrajectory.swift
//  Mapfit
//
//  Created by Zain N. on 7/12/18.
//

import Foundation
import CoreLocation

open class OrbitTrajectory : MFTCameraOptions {
    
    var speedMultiplier: Float = 1
    var centerToPivot: Bool = true
    lazy var pivotPosition: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var centeringEaseType: MFTEaseType = .quartInOut
    var centeringDuration: Float = 0
    var loop: Bool = true
    
    /**
     * Sets the pivot position for the camera to pan around of.
     *
     * @param position
     * @param centerToPivot set true to center to pivot
     * @param duration animation duration in milliseconds
     * @param easeType easing type for the animation
     */
    public func pivot(position: CLLocationCoordinate2D, centerToPivot: Bool = true, duration: Float = 0, easeType: MFTEaseType = .quartInOut) {
        self.pivotPosition = position
        self.centerToPivot = centerToPivot
        self.centeringDuration = duration
        self.centeringEaseType = easeType
    }
    
    /**
     * Sets if the camera animation will run infinitely.
     *
     * @param loop
     */
    public func loop(loop: Bool){
        self.loop = loop
    }
    
    /**
     * Sets the multiplier for rotation speed. For half speed, you can set `0.5f` where `1` is default
     * speed. Positive values will rotate anti-clockwise whereas negative values will rotate
     * clockwise.
     *
     * @param multiplier
     */
    public func speedMultiplier(multiplier: Float){
        self.speedMultiplier = multiplier
    }
    
    public override init() {
        
    }
    
}
