//
//  OrbitAnimation.swift
//  Mapfit
//
//  Created by Zain N. on 7/12/18.
//

import Foundation

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
            DispatchQueue.global().async {
                while self.orbitTrajectory.loop && self.running {
                    usleep(150000)
                    DispatchQueue.main.sync {
                        self.animate()
                    }
                }
            }
            
        } else {
            let repeatCount = Int(Float(self.orbitTrajectory.duration - (self.playedDuration)) / (Float(self.stepDuration) / 1000))
            
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
            let spCenter = mapfitMap.getCenter().toPoint(zoomLevel: mapfitMap.getZoom())
            let spPivot = orbitTrajectory.pivotPosition.toPoint(zoomLevel: mapfitMap.getZoom())
            let newX = Double(spCenter.x) + Double(spPivot.x - spCenter.x) *  cos(Double(rotation)) - Double(spPivot.y - spCenter.y) * sin(Double(rotation))
            let newY = Double(spCenter.y) + Double(spPivot.x - spCenter.x) * sin(Double(rotation)) + Double(spPivot.y - spCenter.y) * cos(Double(rotation))
            let newPoint = CGPoint(x: newX, y: newY)
            mapfitMap.setCenter(position: newPoint.toCLLocationCoordinate2D(zoomLevel: mapfitMap.getZoom()), duration: orbitTrajectory.centeringDuration, easeType: orbitTrajectory.centeringEaseType)
            
        }

    }
    
    private func setInitialZoom(){
        if !orbitTrajectory.zoomLevel.isNaN && (mapfitMap.getZoom() != orbitTrajectory.zoomLevel){
            mapfitMap.setZoom(zoomLevel: orbitTrajectory.zoomLevel, duration: orbitTrajectory.zoomDuration, easeType: orbitTrajectory.zoomEaseType)
        }
    }
    
    
}
