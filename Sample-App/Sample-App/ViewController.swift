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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        MFTManager.sharedManager.apiKey = "591dccc4e499ca0001a4c6a4abab8998a9ec4e0d8efce03e489a00ea"
        let mapview = MFTMapView(frame: view.bounds)
        self.view.addSubview(mapview)
        mapview.addMarker(address: "119 w 24th street ny ny") { (marker, error) in
            
        }
        
        MFTDirections.sharedInstance.route(origin: nil, originAddress: "72 smith street hicksville, ny 11801", destination: nil, destinationAddress: "119 w 24th street, NY, NY", directionsType: .cycling) { (route, error) in
            
            if error != nil {
                return
            }
            
            
            mapview.directionsOptions.drawRoute(route: route!, completion: { (polyline, error) in
                
            })
            
            
        }

        mapview.polygonSelectDelegate = self
        mapview.polylineSelectDelegate = self
        
        
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

extension ViewController : MapPolygonSelectDelegate {
    func mapView(_ view: MFTMapView, didSelectPolygon polygon: MFTPolygon, atScreenPosition position: CGPoint) {
        
    }
    
    
}

extension ViewController : MapPolylineSelectDelegate {
    func mapView(_ view: MFTMapView, didSelectPolyline polygon: MFTPolyline, atScreenPosition position: CGPoint) {
        
    }
    
    
}
