//
//  MapViewGestures.swift
//  iOS.SDK
//
//  Created by Zain N. on 12/11/17.
//  Copyright © 2017 Mapfit. All rights reserved.
//

import Foundation
import TangramMap

/// Single Tap Gesture Delegate
public protocol MapSingleTapGestureDelegate : class {
    /**
     Asks the delegate if the map should recognize this single tap and perform default functionality (which is nothing currently).
     
     - parameter controller: The MFTMapView that wants to recognize the tap.
     - parameter recognizer: The recognizer that initially recognized the tap.
     - parameter location: The screen coordinates that the tap occured in relative to the bounds of the map.
     
     - returns: Return true for default functionality, or false if don't want it recognized (or plan on handling it yourself).
     */
    func mapView(_ view: MFTMapView, recognizer: UIGestureRecognizer, shouldRecognizeSingleTapGesture location: CGPoint) -> Bool
    
    /**
     Informs the delegate the map recognized a single tap gesture.
     
     - parameter controller: The MFTMapView that recognized the tap.
     - parameter recognizer: The recognizer that recognized the tap.
     - parameter location: The screen coordinates that the tap occured in relative to the bounds of the map.
     */
    func mapView(_ view: MFTMapView, recognizer: UIGestureRecognizer, didRecognizeSingleTapGesture location: CGPoint)
}

/// Double Tap Gesture Delegate
public protocol MapDoubleTapGestureDelegate : class {
    /**
     Asks the delegate if the map should recognize this double tap and perform default functionality (which is nothing, currently).
     
     - parameter controller: The MFTMapView that wants to recognize the tap.
     - parameter recognizer: The recognizer that initially recognized the tap.
     - parameter location: The screen coordinates that the tap occured in relative to the bounds of the map.
     
     - returns: Return true for default functionality, or false if don't want it recognized (or plan on handling it yourself).
     */
    func mapView(_ view: MFTMapView, recognizer: UIGestureRecognizer, shouldRecognizeDoubleTapGesture location: CGPoint) -> Bool
    
    /**
     Informs the delegate the map recognized a double tap gesture.
     
     - parameter controller: The MFTMapView that recognized the tap.
     - parameter recognizer: The recognizer that recognized the tap.
     - parameter location: The screen coordinates that the tap occured in relative to the bounds of the map.
     */
    func mapView(_ view: MFTMapView, recognizer: UIGestureRecognizer, didRecognizeDoubleTapGesture location: CGPoint)
}

/// Long Press Gesture Delegate
public protocol MapLongPressGestureDelegate : class {
    /**
     Asks the delegate if the map should recognize this long press gesture and perform default functionality (which is nothing, currently).
     
     - parameter controller: The MFTMapView that wants to recognize the press.
     - parameter recognizer: The recognizer that initially recognized the press.
     - parameter location: The screen coordinates that the press occured in relative to the bounds of the map.
     
     - returns: Return true for default functionality, or false if don't want it recognized (or plan on handling it yourself).
     */
    func mapView(_ view: MFTMapView, recognizer: UIGestureRecognizer, shouldRecognizeLongPressGesture location: CGPoint) -> Bool
    
    /**
     Informs the delegate the map recognized a long press gesture.
     
     - parameter controller: The MFTMapView that recognized the press.
     - parameter recognizer: The recognizer that recognized the press.
     - parameter location: The screen coordinates that the press occured in relative to the bounds of the map.
     */
    func mapView(_ view: MFTMapView, recognizer: UIGestureRecognizer, didRecognizeLongPressGesture location: CGPoint)
}

/// Map Pan Gesture Delegate
public protocol MapPanGestureDelegate : class {
    /**
     Informs the delegate the map just panned.
     
     - parameter controller: The MFTMapView that recognized the pan.
     - parameter displacement: The distance in pixels that the screen was moved by the gesture.
     */
    func mapView(_ view: MFTMapView, didPanMap displacement: CGPoint)
}

/// MapPinchGestureDelegate
public protocol MapPinchGestureDelegate : class {
    /**
     Informs the delegate the map just zoomed via a pinch gesture.
     
     - parameter controller: The MFTMapView that recognized the pinch.
     - parameter location: The screen coordinate the map was pinched at.
     */
    func mapView(_ view: MFTMapView, didPinchMap location: CGPoint)
}

/// MapRotateGestureDelegate
public protocol MapRotateGestureDelegate : class {
    /**
     Informs the delegate the map just rotated.
     
     - parameter controller: The MFTMapView that recognized the rotation.
     - parameter location: The screen coordinate the map was rotated at.
     */
    func mapView(_ view: MFTMapView, didRotateMap location: CGPoint)
}

/// MapShoveGestureDelegate
public protocol MapShoveGestureDelegate : class {
    /**
     Informs the delegate the map just shoved.
     
     - parameter controller: The MFTMapView that recognized the shove.
     - parameter displacement: The distance in pixels that the screen was moved by the gesture.
     */
    
    func mapView(_ view: MFTMapView, didShoveMap displacement: CGPoint)
}

/// MapFeatureSelectDelegate
internal protocol MapFeatureSelectDelegate : class {
    /**
     Informs the delegate a feature of the map was just selected.
     
     - parameter controller: The MFTMapView that recognized the selection.
     - parameter feature: Feature dictionary. The keys available are determined by the provided data in the upstream data source.
     - parameter atScreenPosition: The screen coordinates of the picked feature.
     */
    func mapView(_ view: MFTMapView, didSelectFeature feature: [String : String], atScreenPosition position: CGPoint)
}

/// MapLabelSelectDelegate
internal protocol MapLabelSelectDelegate : class {
    /**
     Informs the delegate a label of the map was just selected
     
     - parameter controller: The MFTMapView that recognized the selection.
     - parameter labelPickResult: A label returned as an instance of TGLabelPickResult.
     - parameter atScreenPosition: The screen coordinates of the picked label.
     */
    func mapView(_ view: MFTMapView, didSelectLabel labelPickResult: TGLabelPickResult, atScreenPosition position: CGPoint)
}

/// MapMarkerSelectDelegate
public protocol MapMarkerSelectDelegate : class {
    /**
     Informs the delegate a marker of the map was just selected
     
     - parameter controller: The MFTMapView that recognized the selection.
     - parameter markerPickResult: A marker selection returned as an instance conforming to GenericMarker.
     - parameter atScreenPosition: The screen coordinates of the picked marker.
     */
    func mapView(_ view: MFTMapView, didSelectMarker marker: MFTMarker, atScreenPosition position: CGPoint)
}


//MapPlaceInfoSelectDelegate
public protocol MapPlaceInfoSelectDelegate : class {

    func mapView(_ view: MFTMapView, didSelectPlaceInfoView marker: MFTMarker)
    
}

/// MapTileLoadDelegate
internal protocol MapTileLoadDelegate : class {
    /**
     Informs the delegate the map has completed loading tile data and is displaying the map.
     
     - parameter controller: The MFTMapView that just finished loading.
     */
    func mapViewDidCompleteLoading(_ controller: MFTMapView)
}

