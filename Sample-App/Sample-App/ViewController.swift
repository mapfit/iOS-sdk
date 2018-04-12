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
        self.navigationItem.title = "GL Test"
        
        
    }
    
    @objc func leftButtonTapped(){
        self.mapview.mapOptions.is3DBuildingsEnabled = true
    }
    
    @objc func rightButtonTapped(){
        self.mapview.mapOptions.is3DBuildingsEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        MFTManager.sharedManager.apiKey = "591dccc4e499ca0001a4c6a4abab8998a9ec4e0d8efce03e489a00ea"
        mapview.frame = self.view.bounds
        mapview.polygonSelectDelegate = self
        
        if let filePath = Bundle.houseStylesBundle()?.path(forResource: "mapfit-day", ofType: "yaml") {
            mapview.mapOptions.setCustomTheme("file://\(filePath)")
        }
        
        
        //mapview.mapOptions.setUserLocationEnabled(true, accuracy: .high)
        mapview.setZoom(zoomLevel: 15)
        
        
        
//                mapview.directionsOptions.setOrigin("119 w 24th street, New York, NY 10010")
//                mapview.directionsOptions.setDestination("81 pearl street, brooklyn, ny")
//                mapview.directionsOptions.showDirections { (polyline, error) in
//                    polyline?.polylineOptions?.strokeOutlineWidth = 5
//                    polyline?.polylineOptions?.strokeWidth = 5
//                    polyline?.polylineOptions?.strokeOutlineColor = HexColor.darkRed.rawValue
//                    polyline?.polylineOptions?.strokeColor = HexColor.blue.rawValue
//
//                }
        
        
                MFTDirections.sharedInstance.route(origin: nil, originAddress: "175 5th Ave, New York, NY 10010", destination: nil, destinationAddress: "81 pearl street, brooklyn, ny", directionsType: .driving) { (route, error) in

                    guard let route = route else{ return }
                    self.mapview.directionsOptions.drawRoute(route: route, completion: { (polyline, error) in
                        polyline?.polylineOptions?.strokeOutlineWidth = 5
                        polyline?.polylineOptions?.strokeWidth = 5
                        polyline?.polylineOptions?.strokeOutlineColor = HexColor.darkRed.rawValue
                        polyline?.polylineOptions?.strokeColor = HexColor.blue.rawValue
                        polyline?.polylineOptions?.drawOrder = 9
                        
                        


                    })
                }

        mapview.addMarker(address: "175 5th Ave, New York, NY 10010") { (marker, error) in
            guard let marker = marker else { return }
            marker.title = "1111"
            let buildingPolygon = marker.getBuildingPolygon()
            buildingPolygon?.polygonOptions?.strokeWidth = 3
            buildingPolygon?.polygonOptions?.strokeOutlineWidth = 5
            buildingPolygon?.polygonOptions?.strokeOutlineColor = HexColor.darkRed.rawValue
            buildingPolygon?.polygonOptions?.fillColor = HexColor.blue.rawValue
            buildingPolygon?.polygonOptions?.strokeColor = HexColor.green.rawValue
            self.mapview.setCenter(position: marker.position)
            self.mapview.setZoom(zoomLevel: 18)


        }
        
        
        let polyline = mapview.addPolyline([[CLLocationCoordinate2D(latitude: 40.744120, longitude: -73.992900),
                                           CLLocationCoordinate2D(latitude: 40.743502, longitude: -73.991667),
                                           CLLocationCoordinate2D(latitude:  40.744762, longitude: -73.990250)
            ]])

        guard let polylineOptions = polyline?.polylineOptions else { return }

        polylineOptions.strokeOutlineWidth = 8
        polylineOptions.strokeWidth = 3
        polylineOptions.strokeColor = "#4353ff"
        polylineOptions.strokeOutlineColor = "#4c4353ff"
        polylineOptions.lineJoinType = .round
        polylineOptions.lineCapType = .round
        
        
        

        let polygon = mapview.addPolygon([[CLLocationCoordinate2D(latitude: 40.744120, longitude: -73.992900),
                                           CLLocationCoordinate2D(latitude: 40.743502, longitude: -73.991667),
                                           CLLocationCoordinate2D(latitude:  40.744762, longitude: -73.990250),
                                           CLLocationCoordinate2D(latitude: 40.745875, longitude: -73.991823),
                                           CLLocationCoordinate2D(latitude: 40.744120, longitude: -73.992900)
            ]])

        guard let polygonOptions = polygon?.polygonOptions else { return }

        polygonOptions.strokeOutlineWidth = 8
        polygonOptions.strokeWidth = 3
        polygonOptions.strokeColor = "#32b3ff"
        polygonOptions.strokeOutlineColor = "#5932b3ff"
        polygonOptions.fillColor = "#2732b3ff"
        polygonOptions.lineJoinType = .round
        polygonOptions.lineCapType = .round
        
                let triangle = mapview.addPolygon([[ CLLocationCoordinate2D(latitude: 40.715736, longitude: -74.024254),
                    CLLocationCoordinate2D(latitude: 40.693539, longitude: -74.008469), CLLocationCoordinate2D(latitude: 40.711315, longitude: -73.972669), CLLocationCoordinate2D(latitude: 40.715736, longitude:  -74.024254)]])
        
                triangle?.polygonOptions?.fillColor = HexColor.green.rawValue
                triangle?.polygonOptions?.strokeColor = HexColor.red.rawValue
                triangle?.polygonOptions?.drawOrder = 10
        
        
        self.view.addSubview(mapview)
        self.setupNav()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


enum HexColor : String {
    //working colors
    case blue = "#0000FF"
    case red = "#FF0000"
    case white = "#FFFFFF" // clear
    case green = "#329B24"
    case yellow = "#FFFF00"
    case purple = "#800080"
    case darkRed = "#A52A2A"
    case orange = "#FFA500"
}
extension ViewController : MapPolygonSelectDelegate {
    func mapView(_ view: MFTMapView, didSelectPolygon polygon: MFTPolygon, atScreenPosition position: CGPoint) {
        print("Clicked a polygon")
    }
    
    
}



