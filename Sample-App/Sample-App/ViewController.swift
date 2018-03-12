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
        mapview.mapOptions.setTheme(customTheme: "https://cdn.mapfit.com/v2/themes/mapfit-grayscale.yaml")
        self.view.addSubview(mapview)
        
        mapview.addMarker(address: "119 w 24th street ny ny") { (marker, error) in
            
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

