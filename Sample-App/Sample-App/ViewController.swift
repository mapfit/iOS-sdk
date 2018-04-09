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
            marker?.title = "Mapfit HQ"
        }
        
        
        mapview.directionsOptions.setOrigin("119 w 24th street, new york, ny")
        mapview.directionsOptions.setDestination("81 pearl street, brooklyn, ny")
        mapview.directionsOptions.showDirections { (polyline, error) in
            
            polyline?.polylineOptions?.setStrokeWidth(5)
            polyline?.polylineOptions?.setStrokeOutlineWidth(5)
            polyline?.polylineOptions?.setStrokeOutlineColor("#12ff0000")
            polyline?.polylineOptions?.setStrokeColor("#1200ff00")
            
        }
        
        
        mapview.addMarker(address: "175 5th Ave, New York, NY 10010") { (marker, error) in
            guard let marker = marker else { return }
            marker.title = "1111"
            
            let buildingPolygon = marker.getBuildingPolygon()
            
            buildingPolygon?.polygonOptions?.setStrokeOutlineColor("#12339933") //green
            
            buildingPolygon?.polygonOptions?.setFillColor("#12FFFFFF") //orange --- this is the fill color
            
            buildingPolygon?.polygonOptions?.setStrokeColor("#12008000") // blue
            
            buildingPolygon?.polygonOptions?.setStrokeWidth(4)
            buildingPolygon?.polygonOptions?.setStrokeOutlineWidth(4)
            
            
            
            
            mapview.setCenter(position: marker.position)
            mapview.setZoom(zoomLevel: 18)
            
            
        }
        
        
        self.view.addSubview(mapview)

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

