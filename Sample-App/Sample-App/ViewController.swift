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
    var mapview: MFTMapView?
    var polygon: MFTPolygon?

    
    func setupNav(){
        let leftButton = UIBarButtonItem(title: "Test 1", style: .plain, target: self, action: #selector(leftButtonTapped))
        let rightButton = UIBarButtonItem(title: "Test 2", style: .plain, target: self, action: #selector(rightButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.title = "Sample App"
        
    }
    
    @objc func leftButtonTapped(){
        let markerOptions = MFTMarkerOptions()
        markerOptions.setStreetAddress(streetAddress: "119 w 24th street ny, ny", geocode: true)
        markerOptions.setIcon(.airport)
        mapview?.addMarker(markerOptions, completion: { (marker, error) in
        
        })
    }
    
    func setBounds(){
        
    }
    
    @objc func rightButtonTapped(){
        if !(mapview?.mapOptions.getTheme() == .night){
            self.mapview?.mapOptions.setTheme(theme: .night)
        }else{
            self.mapview?.mapOptions.setTheme(theme: .day)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.mapview = MFTMapView(frame: view.bounds)
        mapview?.markerSelectDelegate = self
        mapview?.singleTapGestureDelegate = self
        
        
        setupNav()

       
        if let mapview = self.mapview {
            view.addSubview(mapview)
            mapview.setZoom(zoomLevel: 15)
            mapview.setCenter(position: CLLocationCoordinate2D(latitude: 40, longitude: -73))
        }
 

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController : MapMarkerSelectDelegate {
    
    func mapView(_ view: MFTMapView, didSelectMarker marker: MFTMarker, atScreenPosition position: CGPoint) {
        if let mapview = self.mapview {
        
        }
    }
    
    
}

extension ViewController : MapSingleTapGestureDelegate {
    
    
    func mapView(_ view: MFTMapView, recognizer: UIGestureRecognizer, shouldRecognizeSingleTapGesture location: CGPoint) -> Bool {
        return true
    }
    
    func mapView(_ view: MFTMapView, recognizer: UIGestureRecognizer, didRecognizeSingleTapGesture location: CGPoint) {

    }
    
    
    
}


    




