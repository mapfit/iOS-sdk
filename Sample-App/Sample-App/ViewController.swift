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

class ViewController: UIViewController, CLLocationManagerDelegate  {

    let mapview = MFTMapView()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapview.frame = view.bounds
        mapview.mapOptions.setTheme(theme: .grayScale)
        
        self.view.addSubview(mapview)
        mapview.setZoom(zoomLevel: 8)
        
        mapview.addMarker(address: "244 w 24th street ny ny") { (marker, error) in
            guard let marker = marker else { return }
            self.mapview.setCenter(position: marker.getPosition())
            
        }

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .restricted, .denied:
        // Disable your app's location features
        
        break
        
    case .authorizedWhenInUse:
        // Enable only your app's when-in-use features.
        mapview.mapOptions.setUserLocationEnabled(true, accuracy: .low)
        mapview.mapOptions.userLocationDelegate = self
        
        break
        
    case .authorizedAlways:
        // Enable any of your app's location services.
        mapview.mapOptions.setUserLocationEnabled(true, accuracy: .low)
        mapview.mapOptions.userLocationDelegate = self
        break
        
    case .notDetermined:
        break
        }
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


