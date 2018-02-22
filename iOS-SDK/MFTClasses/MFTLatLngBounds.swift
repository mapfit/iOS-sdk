//
//  MFTLatLngBounds.swift
//  iOS.SDK
//
//  Created by Zain N. on 1/4/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import Foundation
import CoreLocation

public class MFTLatLngBounds {
    
    public var northEast: CLLocationCoordinate2D = CLLocationCoordinate2D()
    public var southWest: CLLocationCoordinate2D = CLLocationCoordinate2D()
    lazy public var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    func getNorthEast()->CLLocationCoordinate2D{
        return northEast
    }
    
    func getSouthWest()->CLLocationCoordinate2D{
        return southWest
    }
    
    func getCenter()->CLLocationCoordinate2D{
        return center
    }
    
   public struct Builder {
    
        public var latLngList = [CLLocationCoordinate2D]()
        
        public mutating func add(latLng: CLLocationCoordinate2D){
            latLngList.append(latLng)
        }
        
        public func build()-> MFTLatLngBounds{
            return MFTLatLngBounds(builder: self)
        }
    
    public init(){
        
    }

    }
    
    public init (builder: Builder) {
        var south: Double?
        var west: Double?
        var north: Double?
        var east: Double?
        
        for latlng in builder.latLngList {
            if (south == nil || south! > latlng.latitude) {
                south = latlng.latitude
            }
            
            if (west == nil || west! > latlng.longitude) {
                west = latlng.longitude
            }
            
            if (north == nil || north! < latlng.latitude) {
                north = latlng.latitude
            }
            
            if (east == nil || east! < latlng.longitude) {
                east = latlng.longitude
            }
            
        }
        
        northEast = CLLocationCoordinate2D(latitude : north!, longitude : east!)
        southWest = CLLocationCoordinate2D(latitude: south!, longitude: west!)
        
    }
    
    public init(){
        
    }
    
    
    public init(northEast: CLLocationCoordinate2D, southWest:CLLocationCoordinate2D) {
        self.northEast = northEast
        self.southWest = southWest
        self.center = getCenterLatlng(geoCoordinates: [northEast, southWest])

    }
    
    public func getCenterLatlng(geoCoordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
   
    if (geoCoordinates.count == 1) {
    return geoCoordinates.first!
    }
    
    var x = 0.0
    var y = 0.0
    var z = 0.0
    
        for latLng in geoCoordinates {
            let latitude = latLng.latitude.degreesToRadians
            let longitude = latLng.longitude.degreesToRadians
            
            x += cos(latitude) * cos(longitude)
            y += cos(latitude) * sin(longitude)
            z += sin(latitude)
        }
    
    let total = geoCoordinates.count
    
    x /= Double(total)
    y /= Double(total)
    z /= Double(total)
    
    let centralLongitude = atan2(y, x)
    let centralSquareRoot = sqrt(x * x + y * y)
    let centralLatitude = atan2(z, centralSquareRoot)
    
    return CLLocationCoordinate2DMake(centralLatitude.radiansToDegrees, centralLongitude.radiansToDegrees)
    
    }
    
    public func getVisibleBounds(viewWidth: Float, viewHeight: Float, padding: Float)-> (CLLocationCoordinate2D, Float){
        
//        func latRad(lat: Double)-> Double{
//            let vSin = sin(lat * Double.pi / 180)
//            let radX2 = log((1 + vSin)) / 2
//            return max(min(radX2, Double.pi), -Double.pi) / 2
//        }
//
//        func zoom(_ mapPx: Double, _ worldPx: Double, _ fraction: Double)-> Double{
//            return floor(log(mapPx / worldPx / fraction) / 0.693)
//        }
//
//        let latFraction = (latRad(lat: northEast.latitude) - latRad(lat: southWest.latitude) / Double.pi)
//        var lngDiff = northEast.longitude - southWest.longitude
//
//        if (lngDiff < 0) {
//            lngDiff += 360
//        }
//
//        let lngFraction = lngDiff / 360
//        let latZoom = zoom(Double(viewHeight * padding), 256 * Double(UIScreen.main.scale), latFraction)
//        let lngZoom = zoom(Double(viewWidth * padding), 256 * Double(UIScreen.main.scale), lngFraction)
//
//
//        let result = min(latZoom, lngZoom)
//        return (center, Float(result))
        
        
        let ry1 = log((sin(southWest.latitude.degreesToRadians) + 1) / cos(southWest.latitude.degreesToRadians))
        let ry2 = log((sin(northEast.latitude.degreesToRadians)) + 1) / cos(northEast.latitude.degreesToRadians)
        let ryc = (ry1 + ry2) / 2
        let centerX = atan(sinh(ryc)).radiansToDegrees

        let resolutionHorizontal = (northEast.longitude - southWest.longitude) / Double(viewWidth)

        let vy0 = log(tan(Double.pi * (0.25 + centerX / 360)))
        let vy1 = log(tan(Double.pi * (0.25 + northEast.latitude / 360)))

        let viewHeightHalf = Double(viewHeight) / 2.0

        let zoomFactorPowered = Double(viewHeightHalf) / (40.7436654315252 * (vy1 - vy0))
        let resolutionVertical = 360.0 / (zoomFactorPowered * 256)


        let paddingFactor = 1.6 + Double(padding)
        let resolution = max(resolutionHorizontal, resolutionVertical) * paddingFactor

        let zoom = logC(val: 360 / (resolution * 512), forBase: 2.0)

        return(center, Float(zoom))
        
    }
    
    func logC(val: Double, forBase base: Double) -> Double {
        return log(val)/log(base)
    }
    
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}


