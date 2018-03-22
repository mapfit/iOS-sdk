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
        

        MFTManager.sharedManager.apiKey = "591dccc4e499ca0001a4c6a4abab8998a9ec4e0d8efce03e489a00ea"
        let mapview = MFTMapView(frame: view.bounds)
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
        

        MFTDirections.sharedInstance.route(origin: nil, originAddress: "72 smith street hicksville, ny 11801", destination: nil, destinationAddress: "119 w 24th street, NY, NY", directionsType: .cycling) { (route, error) in
            
            if error != nil {
                return
            }
            
            
            self.mapview.directionsOptions.drawRoute(route: route!, completion: { (polyline, error) in
               self.mapview.directionsOptions.extendRoute(route: route!, addressOfExtension: "81 pearl street brooklyn", completion: { (polyline, error) in
                    
                })
            })
            
            
        }

        mapview.polygonSelectDelegate = self
        mapview.polylineSelectDelegate = self

        
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

extension ViewController : MapPolygonSelectDelegate {
    func mapView(_ view: MFTMapView, didSelectPolygon polygon: MFTPolygon, atScreenPosition position: CGPoint) {
        
    }
    
    
}

extension ViewController : MapPolylineSelectDelegate {
    func mapView(_ view: MFTMapView, didSelectPolyline polygon: MFTPolyline, atScreenPosition position: CGPoint) {
        
    }
    
    
}

