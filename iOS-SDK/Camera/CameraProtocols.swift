//
//  CameraProtocols.swift
//  Mapfit
//
//  Created by Zain N. on 7/12/18.
//

import Foundation

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
