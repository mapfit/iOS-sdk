//
//  Cinematography.swift
//  Mapfit
//
//  Created by Zain N. on 7/12/18.
//

import Foundation


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
