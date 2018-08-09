//  AnimationOptions.swift
//  Mapfit
//
//  Created by Zain N. on 8/8/18.
//

import Foundation

public class AnimationOptions{
    
    internal var duration: Int = 2
    internal var interpolator: Interpolator = Interpolator()
    internal var listener: AnimationListener? = nil
    
    
    
    /**
     * Sets the duration of the animation.
     *
     * @param duration in milliseconds
     */
    public func duration<T>(_ duration: Int) -> T {
    self.duration = duration
        return self as! T
    }
    
    /**
     * Sets the interpolator for the animation.
     *
     * @param interpolator
     */
    public func interpolator<T>(_ interpolator: Interpolator) -> T {
    self.interpolator = interpolator
    return self as! T
    }
    
    /**
     * Sets [AnimationListener] for animation events.
     *
     * @param listener
     */
    public func animationListener<T>(_ listener: AnimationListener)-> T {
    self.listener = listener
    return self as! T
    }


    
  
}
