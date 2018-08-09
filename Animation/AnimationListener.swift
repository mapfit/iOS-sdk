//
//  AnimationListener .swift
//  Mapfit
//
//  Created by Zain N. on 8/8/18.
//

import Foundation


public protocol AnimationListener {
    
    /**
     * Invoked on animation start.
     */
     func onStart(animatable: Animatable)
    
    
    /**
     * Invoked on animation end.
     */
     func onFinish(animatable: Animatable)
    
}
