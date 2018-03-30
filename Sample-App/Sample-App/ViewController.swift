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
        mapview.mapOptions.setTheme(theme: .day)
        
        mapview.mapOptions.setUserLocationEnabled(true, accuracy: .high)
        
        mapview.addMarker(address: "119 w 24th street, NY") { (marker, error) in
            marker?.title = "1111"
        }
        
        
        self.view.addSubview(mapview)

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

