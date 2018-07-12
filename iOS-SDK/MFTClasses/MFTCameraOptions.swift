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
    public init(_ mapfitMap: MFTMapView) {
        self.mapView = mapfitMap
    }
    
    public func create(cameraOptions: MFTCameraOptions, cameraAnimationCallback: @escaping ()->AnimationCallback) -> CameraAnimation {
        if type(of: cameraOptions) == OrbitTrajectory.self {
            return OrbitAnimation(orbitTrajectory: cameraOptions as! OrbitTrajectory, map: mapView, cameraAnimationCallback: cameraAnimationCallback)
        }else{
            return AnyObject.self as! CameraAnimation
        }
    }
}

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

public class OrbitAnimation : NSObject, CameraAnimation{

    var orbitTrajectory: OrbitTrajectory
    var mapfitMap: MFTMapView
    var cameraAnimationCallback: ()->AnimationCallback
    
    private var stepDuration: Int = 150
    private var rotation: Float = Float.nan
    private var running = false
    private var playedDuration: Float = 0
    private var runInitialAnimations = true
   
    private var rotationDegrees: Float {
        return 1.0 * orbitTrajectory.speedMultiplier
    }
    
    init(orbitTrajectory: OrbitTrajectory, map: MFTMapView, cameraAnimationCallback: @escaping ()->AnimationCallback) {
        self.orbitTrajectory = orbitTrajectory
        self.mapfitMap = map
        self.cameraAnimationCallback = cameraAnimationCallback
    }

    public func start() {
        running = true
        
            self.cameraAnimationCallback().onStart()
            if self.orbitTrajectory.loop {
                
                while self.orbitTrajectory.loop && self.running {
                    DispatchQueue.global().async {
                        usleep(150000)
                        DispatchQueue.main.sync {
                            self.animate()
                        }
                    }
 
                  
                }
                
            } else {
                let repeatCount = Int(Float(self.orbitTrajectory.duration - (self.playedDuration / 1000)) / (Float(self.stepDuration) / 1000))
                
                DispatchQueue.global().async {
                    for i in 1...repeatCount {
                        usleep(150000)
                        DispatchQueue.main.sync(execute: {
                            self.playedDuration = Float(self.playedDuration / 1000) + Float(Float(self.stepDuration) / Float(1000))
                            self.animate()
                            if (i == repeatCount - 1){
                                self.cameraAnimationCallback().onFinish()
                            }
                            
                            if (!self.running){
                                
                            }
                        })
                    }
                }
            }
    }
    
    
    @objc private func animate(){
        let d = Date()
        let df = DateFormatter()
        df.dateFormat = "y-MM-dd H:m:ss.SSSS"
             print(df.string(from: d))
        
        rotation = mapfitMap.getRotation()
        
        if runInitialAnimations {
            runInitialAnimations = false
            
            DispatchQueue.main.async {
                let queue: OperationQueue = OperationQueue()
                queue.maxConcurrentOperationCount = (3)
                queue.addOperation({self.setInitialTilt()})
                queue.addOperation({self.setInitialZoom()})
                queue.addOperation({self.setInitialCenter()})

            }
  
        
        }
        
        rotation = Float((Double(rotation) + Double(rotationDegrees.degreesToRadians)).truncatingRemainder(dividingBy: 360))
        print("Rotation \(rotation)")
        
    
       self.mapfitMap.setRotation(rotationValue: self.rotation, duration: 0.15, easeType: .linear)
 
    }
    

    
    public func isRunning() -> Bool {
        return self.running
    }
    
    public func stop() {
        running = false
    }

        private func setInitialTilt() {
            if !orbitTrajectory.tiltAngle.isNaN && (mapfitMap.getTilt() != orbitTrajectory.tiltAngle) {
                mapfitMap.setTilt(tiltValue: orbitTrajectory.tiltAngle, duration: orbitTrajectory.tiltDuration, easeType: orbitTrajectory.tiltEaseType)
                
            }
        }
    
    private func setInitialCenter(){
        if orbitTrajectory.centerToPivot {
            orbitTrajectory.centerToPivot = false
            
            let spCenter = mapfitMap.tgMapView.lngLat(toScreenPosition: TGGeoPoint(coordinate: mapfitMap.getCenter()))
            let spPivot = mapfitMap.tgMapView.lngLat(toScreenPosition: TGGeoPoint(coordinate: orbitTrajectory.pivotPosition))
            
//            let spCenter = mapfitMap.getCenter().toPoint(zoomLevel: mapfitMap.getZoom())
//            let spPivot = orbitTrajectory.pivotPosition.toPoint(zoomLevel: mapfitMap.getZoom())
            
            let newX = Double(spCenter.x) + Double(spPivot.x - spCenter.x) *  cos(Double(rotation)) - Double(spPivot.y - spCenter.y) * sin(Double(rotation))
            //let newX = Double(newXeq) + Double(spPivot.y - spCenter.y) * cos(Double(rotation))
            
            let newY = Double(spCenter.y) + Double(spPivot.x - spCenter.x) * sin(Double(rotation)) + Double(spPivot.y - spCenter.y) * cos(Double(rotation))
//            let newY = newYeq * sin(Double(rotation)) +
            let newPoint = CGPoint(x: newX, y: newY)
            
          
            let tLatLng = mapfitMap.tgMapView.screenPosition(toLngLat: newPoint)
            let latLng = CLLocationCoordinate2D(latitude: tLatLng.latitude, longitude: tLatLng.longitude)
            
            mapfitMap.setCenter(position: latLng, duration: orbitTrajectory.centeringDuration, easeType: orbitTrajectory.centeringEaseType)
    
        }
        

    }
    
    private func setInitialZoom(){
        if !orbitTrajectory.zoomLevel.isNaN && (mapfitMap.getZoom() != orbitTrajectory.zoomLevel){
            mapfitMap.setZoom(zoomLevel: orbitTrajectory.zoomLevel, duration: orbitTrajectory.zoomDuration, easeType: orbitTrajectory.zoomEaseType)
        }
    }
    
    
}

public protocol CameraAnimation : Animatable {}


public protocol AnimationCallback {
    
    /**
     * Invoked on animation start.
     */
    func onStart()
    
    
    /**
     * Invoked on animation end.
     */
    func onFinish()
    
}

public protocol Animatable {
    
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
