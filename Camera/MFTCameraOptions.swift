//
//  MFTCameraOptions.swift
//  Mapfit
//
//  Created by Zain N. on 6/29/18.
//

import Foundation
import TangramMap
import CoreLocation

/**
 * Defines options for a [CameraAnimation].
 */
open class MFTCameraOptions {
    
    internal var duration: Float = 0
    internal var tiltAngle: Float = Float.nan
    internal var tiltDuration: Float = 0
    internal var tiltEaseType = MFTEaseType.quartInOut
    internal var rotateAngle: Float = Float.nan
    internal var rotationDuration: Float = 0
    internal var rotationEaseType = MFTEaseType.quartInOut
    internal var zoomLevel: Float = Float.nan
    internal var zoomDuration: Float = 0
    internal var zoomEaseType = MFTEaseType.quartInOut
    
    /**
     * Sets duration for the animation.
     *
     * @param duration
     */
    public func duration(duration: Float) {
        self.duration = duration
    }
    
    /**
     * Sets the tilting animation options for the camera.
     *
     * @param angle angle in radians, 0 is to straight down
     * @param duration of the animation
     * @param easeType for the animation
     */
    
   public func tiltTo(angle: Float, duration: Float, easeType: MFTEaseType) {
        self.tiltAngle = angle
        self.tiltDuration = duration
        self.tiltEaseType = easeType
    }
    
    /**
     * Sets the rotation animation options for the camera.
     *
     * @param angle angle in radians, 0 is facing north
     * @param duration of the animation
     * @param easeType for the animation
     */
    
    public func rotateTo(angle: Float, duration: Float = 0, easeType: MFTEaseType) {
        self.rotateAngle = angle
        self.rotationDuration = duration
        self.rotationEaseType = easeType
    }
    
    /**
     * Sets the zoom animation options for the camera.
     *
     * @param zoomLevel
     * @param duration of the animation
     * @param easeType for the animation
     */

    public func zoomTo(zoomLevel: Float, duration: Float = 0, easeType: MFTEaseType) {
        self.zoomLevel = zoomLevel
        self.zoomDuration = duration
        self.zoomEaseType = easeType
    }
}
