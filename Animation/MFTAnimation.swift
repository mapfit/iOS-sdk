//
//  Animation.swift
//  Mapfit
//
//  Created by Zain N. on 8/8/18.
//

import Foundation

public class MFTAnimation : Animatable {
    public func isRunning() -> Bool {
        return false
    }
    
    public func start() {
        
    }
    
    public func stop() {
        
    }
    
    
    var running: Bool = false
    var paused: Bool = false
    var canceled: Bool = false
    var finished: Bool = false
}
