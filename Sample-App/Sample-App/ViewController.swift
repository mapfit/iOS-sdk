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
    var mapview = MFTMapView()
    
    func setupNav(){
        let leftButton = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(leftButtonTapped))
        let rightButton = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(rightButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.title = "Sample App"  
    }
    
    @objc func leftButtonTapped(){
        
        //Scene updates
        //
        //let update = MFTSceneUpdate(path: "global.show_3d_buildings", value: "true")
        //mapview.updateScene(updates: [update])
        
       // mapview.mapOptions.setGesturesEnabled(enabled: true)
        
       //setBounds()
        
        let polygonOptions = MFTPolygonOptions()
        polygonOptions.strokeColor = "#32b3ff"
        
        let markerOptions = MFTMarkerOptions()
        markerOptions.setIcon(.active)
        markerOptions.setStreetAddress(streetAddress: "119 w 24th street new york, NY", geocode: true)
        markerOptions.addBuildingPolygon(true, options: polygonOptions)
        
        mapview.addMarker(markerOptions) { (marker, error) in


        }
        
        


        
    }
    
    func setBounds(){
        var builder = MFTLatLngBounds.Builder()
        
        builder.add(latLng: CLLocationCoordinate2D(latitude: 40.7368876593604, longitude: -73.9785409464787))
        builder.add(latLng: CLLocationCoordinate2D(latitude: 40.7313501345546, longitude: -73.982556292978))
        builder.add(latLng: CLLocationCoordinate2D(latitude:  40.7344347901369, longitude: -73.9899029597005))
        builder.add(latLng: CLLocationCoordinate2D(latitude: 40.7354082589172, longitude: -73.9898742137078))
        builder.add(latLng: CLLocationCoordinate2D(latitude: 40.7433247184166, longitude: -73.9840748526015))
        builder.add(latLng: CLLocationCoordinate2D(latitude:  40.7419697680819, longitude:-73.9808596541241))
        builder.add(latLng: CLLocationCoordinate2D(latitude: 40.739498439778, longitude: -73.9826675979102))
        builder.add(latLng:  CLLocationCoordinate2D(latitude: 40.7375539536562, longitude: -73.9780522649762))
        builder.add(latLng: CLLocationCoordinate2D(latitude: 40.7368876593604, longitude: -73.9785409464787))
        
        let bounds = builder.build()
        let paddingPercentage = Float(1)
        
        mapview.setLatLngBounds(bounds: bounds, padding: paddingPercentage, duration: 0.5)
        
    }
    
    @objc func rightButtonTapped(){
       
        mapview.mapOptions.setGesturesEnabled(enabled: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapview.markerSelectDelegate = self
        mapview.singleTapGestureDelegate = self
        mapview.frame = self.view.bounds
        
        setupNav()
//        if let path = Bundle.main.path(forResource: "mapfit-day", ofType: "yaml")  {
//             self.mapview = MFTMapView(frame: self.view.bounds, customMapStyle: "file:///\(path)")
//        }
       
        
        view.addSubview(mapview)
        mapview.setZoom(zoomLevel: 5)
        mapview.setCenter(position: CLLocationCoordinate2D(latitude: 40, longitude: -73))

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController : MapMarkerSelectDelegate {
    
    func mapView(_ view: MFTMapView, didSelectMarker marker: MFTMarker, atScreenPosition position: CGPoint) {
        
        let latLng = mapview.screenPositionToLatLng(position)
        let point = mapview.LatLngToScreenPosition(latLng)
        
        print(point)
        print(latLng)
    
    }
    
    
}

extension ViewController : MapSingleTapGestureDelegate {
    
    
    func mapView(_ view: MFTMapView, recognizer: UIGestureRecognizer, shouldRecognizeSingleTapGesture location: CGPoint) -> Bool {
        return true
    }
    
    func mapView(_ view: MFTMapView, recognizer: UIGestureRecognizer, didRecognizeSingleTapGesture location: CGPoint) {
        let latLng = mapview.screenPositionToLatLng(location)
        print(latLng)
    }
    
    
    
}


    




