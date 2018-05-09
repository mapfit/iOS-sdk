//
//  ViewController.swift
//  iOS-GL-Test
//
//  Created by Zain N. on 4/3/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import UIKit
import CoreLocation
import Mapfit

class ViewController: UIViewController {
    
    let button: UIButton = UIButton()
    let mapview = MFTMapView()
    
    func setupNav(){
        let leftButton = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(leftButtonTapped))
        let rightButton = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(rightButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.title = "Sample App"
        
        
    }
    
    @objc func leftButtonTapped(){
        
        //Scene updates
        
        //let update = MFTSceneUpdate(path: "global.show_3d_buildings", value: "true")
        //mapview.updateScene(updates: [update])
        
        mapview.mapOptions.setGesturesEnabled(enabled: true)

    }
    
    @objc func rightButtonTapped(){
       
        mapview.mapOptions.setGesturesEnabled(enabled: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupNav()
        mapview.frame = self.view.bounds
        view.addSubview(mapview)
        
        mapview.addMarker(address: "119 w 24th street new york, ny") { (marker, error) in
            
            
            //access the markers options through marker.markerOptions
            
            
        }
        
        
        
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



    




