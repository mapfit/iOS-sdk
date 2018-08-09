//
//  SnakeAnimation.swift
//  Mapfit
//
//  Created by Zain N. on 8/8/18.
//

import Foundation
import CoreLocation

public class Interpolator{
    
}



public class MFTAnimator{
    
    var interpolator: Interpolator? = nil
    var routeEvaluator: RouteEvaluator
    var latLngs: [CLLocationCoordinate2D]
    var target: Any
    var propertyName: String
    
    public func cancel(){
        
    }
    
    public init(ofObject target: Any!, propertyName: String, routeEvaluator:RouteEvaluator, latLngs: [CLLocationCoordinate2D]){
        self.target = target
        self.propertyName = propertyName
        self.routeEvaluator = routeEvaluator
        self.latLngs = latLngs
    }
    
    
}
public class SnakeAnimation : PolylineAnimation {
    
    private lazy var duration: Int = Int()
    private var listener: AnimationListener!
    private lazy var polylinePoints: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    private lazy var evaluatedLatLngs: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    private lazy var smoothingPolylines: [MFTPolyline] = [MFTPolyline]()
    private lazy var routeAnimator: MFTAnimator? =  nil
    private var overlappingPolylineCount = 4
    private var smoothingIndex = 0
    private var animationOptions: AnimationOptions
    
    
    
    public init(_ animationOptions: SnakeAnimationOptions) {
         self.animationOptions = animationOptions
         super.init()
        self.duration = animationOptions.duration
        self.listener = animationOptions.listener
       
    }
    
    override public func start() {
        if let poly = polyline {
            if poly.points.count < 2 { print("SnakeAnimation couldnt be executed with less than 2 points. You need at least 2 points to animate.") }
        } else {
             print("SnakeAnimation couldn't be executed without a polyline. Did you bind the animation to a polyline?")
            
        }
        
        animatePath()
    }
    
    override public func stop() {
        DispatchQueue.main.async {
            self.routeAnimator?.cancel()
        }
    }
    
    private func animatePath(){
        
        if let poly = polyline {
            polylinePoints = poly.points
        }
    }
    
    
    private func getRouteAnimator() -> MFTAnimator? {
    
        let points = polyline?.points ?? [CLLocationCoordinate2D]()
        
        let routeAnimator = MFTAnimator(ofObject: self, propertyName: "evaluatedLatLng", routeEvaluator: RouteEvaluator(), latLngs: points)
        routeAnimator.interpolator = animationOptions.interpolator
        
        return routeAnimator
        
    }
    
    private func dispose(){
        polyline?.points = polylinePoints
        if let poly = polyline {
              poly.mapView?.removePolyline(poly)
        }
        
        
      
    }
    
    func setEvaluatedLatLng(evaluatedLatLng: CLLocationCoordinate2D){
        if (CLLocationCoordinate2DIsValid(evaluatedLatLng)){
           if !evaluatedLatLngs.isEmpty{
                evaluatedLatLngs.append(evaluatedLatLng)
                smoothingPolylines[smoothingIndex.quotientAndRemainder(dividingBy: overlappingPolylineCount).remainder].points = evaluatedLatLngs
                 smoothingIndex += 1
            
            
            }
        }
    }
    
    
    private func getPointsToIndex(index: Int)-> [CLLocationCoordinate2D] {
        var points = [CLLocationCoordinate2D]()
        
        var tIndex = index
        while tIndex >= 0 {
            points.append(polylinePoints[tIndex])
            tIndex = tIndex - 1
        }
        
        return points
        
    }
    
    override public func isRunning() -> Bool {
        return running
    }
    
}
