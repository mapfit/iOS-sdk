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
 * Creates an animation with the given [CameraOptions].
 *
 * @param cameraOptions options for camera animation
 * @param cameraAnimationCallback callback to listen to animation events
 */
public class Cinematography {
    var mapView: MFTMapView!
    init(mapfitMap: MFTMapView) {
        self.mapView = mapfitMap
    }
    
    func create(cameraOptions: MFTCameraOptions, cameraAnimationCallback: CameraAnimationCallback? = nil) -> CameraAnimation {
        if type(of: cameraOptions) == OrbitTrajectory.self {
            return OrbitAnimation(orbitTrajectory: cameraOptions as! OrbitTrajectory, map: mapView, cameraAnimationCallback: cameraAnimationCallback!)
        }else{
            return AnyObject.self as! CameraAnimation
        }
    }
}

public class OrbitTrajectory : MFTCameraOptions {

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
    func pivot(position: CLLocationCoordinate2D, centerToPivot: Bool = true, duration: Float = 0, easeType: MFTEaseType = .quartInOut) {
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
    func loop(loop: Bool){
        self.loop = loop
    }
    
    /**
     * Sets the multiplier for rotation speed. For half speed, you can set `0.5f` where `1` is default
     * speed. Positive values will rotate anti-clockwise whereas negative values will rotate
     * clockwise.
     *
     * @param multiplier
     */
    func speedMultiplier(multiplier: Float){
        self.speedMultiplier = multiplier
    }
    
}

public class OrbitAnimation : CameraAnimation {

    var orbitTrajectory: OrbitTrajectory
    var mapfitMap: MFTMapView
    var cameraAnimationCallback: CameraAnimationCallback
    
    private var stepDuration: Int = 150
    private var rotation: Float = Float.nan
    private var running = false
    private var playedDuration: Float = 0
    private var runInitialAnimations = true
   
    private var rotationDegrees: Float {
        return 1.0 * orbitTrajectory.speedMultiplier
    }
    
    init(orbitTrajectory: OrbitTrajectory, map: MFTMapView, cameraAnimationCallback: CameraAnimationCallback) {
        self.orbitTrajectory = orbitTrajectory
        self.mapfitMap = map
        self.cameraAnimationCallback = cameraAnimationCallback
    }

    func start() {
        running = true
        
        if orbitTrajectory.loop {
            while orbitTrajectory.loop && running {
                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(stepDuration)) {
                    self.animate()
                }
            }
        } else {
            let repeatCount = Int(orbitTrajectory.duration - playedDuration) / stepDuration
            
            for i in 1...repeatCount {
                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(stepDuration)) {
                    self.playedDuration += Float(self.stepDuration)
                    self.animate()
                    
                    if (i == repeatCount - 1){
                        
                        self.cameraAnimationCallback.onFinish()
                    }
                    
                    if (!self.running){
                        //retrun@
                    }
            }
                
            }
            
        }
    }
    
    private func animate(){
        if runInitialAnimations {
            runInitialAnimations = false
            
            setInitialTilt()
            setInitialZoom()
            setInitialCenter()
            
        }
        
        rotation = Float(Int(rotation + Float(rotationDegrees).degreesToRadians) % 360)
        mapfitMap.setRotation(rotationValue: rotation, duration: Float(stepDuration), easeType: .quartIn)
    }
    
    
    
    func isRunning() -> Bool {
        return self.running
    }
    
    func stop() {
        running = false
    }

        private func setInitialTilt() {
            if !orbitTrajectory.tiltAngle.isNaN && mapfitMap.getTilt() != orbitTrajectory.tiltAngle {
                mapfitMap.setTilt(tiltValue: orbitTrajectory.tiltAngle, duration: orbitTrajectory.tiltDuration, easeType: orbitTrajectory.tiltEaseType)
                
            }
        }
    
    private func setInitialCenter(){
        if orbitTrajectory.centerToPivot {
            orbitTrajectory.centerToPivot = false
            
            let spCenter = mapfitMap.getCenter().toPoint(zoomLevel: mapfitMap.getZoom())
            let spPivot = orbitTrajectory.pivotPosition.toPoint(zoomLevel: mapfitMap.getZoom())
            
            let newXeq = Double(spCenter.x) + Double(spPivot.x - spCenter.x) * sin(Double(rotation))
            let newX = Double(newXeq) + Double(spPivot.y - spCenter.y) * cos(Double(rotation))
            
            let newYeq = Double(spCenter.y) + Double(spPivot.x - spCenter.x)
            let newY = newYeq * sin(Double(rotation)) + Double(spPivot.y - spCenter.y) * cos(Double(rotation))
            let newPoint = CGPoint(x: newX, y: newY)
            
            
            mapfitMap.setCenter(position: newPoint.toCLLocationCoordinate2D(zoomLevel: mapfitMap.getZoom()), duration: orbitTrajectory.centeringDuration, easeType: orbitTrajectory.centeringEaseType)
    
        }
        

    }
    
    private func setInitialZoom(){
        if (!orbitTrajectory.zoomLevel.isNaN && mapfitMap.getZoom() != orbitTrajectory.zoomLevel){
            mapfitMap.setZoom(zoomLevel: orbitTrajectory.zoomLevel, duration: orbitTrajectory.zoomDuration, easeType: orbitTrajectory.zoomEaseType)
        }
    }
    
    
}

protocol CameraAnimation : Animatable {}


protocol CameraAnimationCallback {
    
    /**
     * Invoked on animation start.
     */
    func onStart()
    
    
    /**
     * Invoked on animation end.
     */
    func onFinish()
    
}

protocol Animatable {
    
    /**
     * Returns if the animation is running.
     *
     * @return true if animation is running
     */
    func isRunning() -> Bool
    
    /**
     * Starts the animation.
     */
    func start()
    
    /**
     * Stops the animation.
     */
    func stop()
    
}

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
    func duration(duration: Float) {
        self.duration = duration
    }
    
    /**
     * Sets the tilting animation options for the camera.
     *
     * @param angle angle in radians, 0 is to straight down
     * @param duration of the animation
     * @param easeType for the animation
     */
    
    func tiltTo(angle: Float, duration: Float, easeType: MFTEaseType) {
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
    
    func rotateTo(angle: Float, duration: Float = 0, easeType: MFTEaseType) {
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

    func zoomTo(zoomLevel: Float, duration: Float = 0, easeType: MFTEaseType) {
        self.zoomLevel = zoomLevel
        self.zoomDuration = duration
        self.zoomEaseType = easeType
    }
}
