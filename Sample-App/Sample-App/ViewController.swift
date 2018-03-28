//
//  ViewController.swift
//  Sample-App
//
//  Created by Zain N. on 2/21/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import UIKit
import Mapfit
import CoreLocation

class ViewController: UIViewController {

    let mapview = MFTMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MFTManager.sharedManager.apiKey = "591dccc4e499ca0001a4c6a4abab8998a9ec4e0d8efce03e489a00ea"
        let mapview = MFTMapView(frame: view.bounds)
        mapview.mapOptions.setTheme(theme: .grayScale)
        
        self.view.addSubview(mapview)
        mapview.setZoom(zoomLevel: 8)
        mapview.setCenter(position: CLLocationCoordinate2D(latitude: 40.74405, longitude: -73.99324))
        
        mapview.mapOptions.setUserLocationButtonVisibility(true)
        mapview.mapOptions.setCompassVisibility(true)
        mapview.mapOptions.setUserLocationEnabled(true, accuracy: .low)
        //mapview.mapOptions.setRecenterVisibility(true)

        mapview.addMarker(address: "119 w 24th street NY NY") { (marker, error) in
            guard let marker =  marker else { return }

        }

        mapview.polygonSelectDelegate = self
        mapview.polylineSelectDelegate = self
        mapview.markerSelectDelegate = self
        mapview.mapOptions.userLocationDelegate = self
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController : MapRotateGestureDelegate {
    func mapView(_ view: MFTMapView, didRotateMap location: CGPoint) {
        
    }
}


extension ViewController : LocationUpdateDelegate {
    func didRecieveLocationUpdate(_ location: CLLocation) {
        print("User has location : \(location.coordinate)")
    }
    
}

extension ViewController: MapMarkerSelectDelegate {
    func mapView(_ view: MFTMapView, didSelectMarker marker: MFTMarker, atScreenPosition position: CGPoint) {
        
    }
}

extension ViewController : MapPolygonSelectDelegate {
    func mapView(_ view: MFTMapView, didSelectPolygon polygon: MFTPolygon, atScreenPosition position: CGPoint) {
        
    } 
}

extension ViewController : MapPolylineSelectDelegate {
    func mapView(_ view: MFTMapView, didSelectPolyline polygon: MFTPolyline, atScreenPosition position: CGPoint) {
        
    }
    
    
}

