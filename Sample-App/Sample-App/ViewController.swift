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
        let leftButton = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(leftButtonTapped))
        let rightButton = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(rightButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.title = "Sample App"  
    }
    
    @objc func leftButtonTapped(){
        
        //Scene updates
        //
        self.polygon?.strokeColor = "#FFFFFF"
        self.polygon?.strokeWidth = 10
        self.polygon?.strokeOutlineColor = "#808000"

        
       
        let markerOptions = MFTMarkerOptions()
        markerOptions.setIcon(.active)
        
        //sets address with geocoder true
        markerOptions.setStreetAddress(streetAddress: "119 w 24th street new york, NY", geocode: true)
        markerOptions.addBuildingPolygon(true, options: MFTPolygonOptions())
        //position and street address assigned to marker
        //CHECK
        
        //set address with geocoder false
        //markerOptions.setStreetAddress(streetAddress: "119 w 24th street new york, NY", geocode: false)
        //no marker
        //CHECK
        
        //marker with no street address
        //markerOptions.setPosition(position: CLLocationCoordinate2D(latitude: 40.744050000000001, longitude: -73.99324), reverseGeocode: false)
        //no street Address
        //positions
        //CHECK
        
        //marker with street address
        //markerOptions.setPosition(position: CLLocationCoordinate2D(latitude: 40.744050000000001, longitude: -73.99324), reverseGeocode: true)
        //street Address
        //position
        //CHECK
        //mapview?.mapOptions.setUserLocationEnabled(true, accuracy: .high)
      
        mapview?.addMarker(markerOptions, completion: { (marker, error) in
            guard let mark = marker else { return }
            print("marker?.position")
            print(mark.position)
            print("marker?.streetAddress")
            print(mark.streetAddress)
            print("marker?.address")
            print(mark.address)
            
            self.mapview?.setCenter(position: mark.position)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.mapview?.setCenterWithOffset(latLng: mark.position, offsetX: 100, offsetY: 100, duration: 2)
            })
            
            
        })
    
//        mapview?.addMarker(markerOptions) { (marker, error) in
//        guard let mark = marker else { return }
//
//            print(marker?.position)
//
//
//        }

        let polylineOptions = MFTPolylineOptions()
        polylineOptions.addPoints([[CLLocationCoordinate2D(latitude:40.729877, longitude:-74.000588),
                                   CLLocationCoordinate2D(latitude:40.729171, longitude:-74.001191),
                                   CLLocationCoordinate2D(latitude:40.728103, longitude:-74.002099),
                                   CLLocationCoordinate2D(latitude:40.728248, longitude:-74.002396),
                                   CLLocationCoordinate2D(latitude:40.728382, longitude:-74.002663),
                                   CLLocationCoordinate2D(latitude:40.72845, longitude:-74.002793),
                                   CLLocationCoordinate2D(latitude:40.728519, longitude:-74.002755),
                                   CLLocationCoordinate2D(latitude:40.728691, longitude:-74.002671),
                                   CLLocationCoordinate2D(latitude:40.728908, longitude:-74.002564),
                                   CLLocationCoordinate2D(latitude:40.729602, longitude:-74.002244),
                                   CLLocationCoordinate2D(latitude:40.729694, longitude:-74.002198),
                                   CLLocationCoordinate2D(latitude:40.729881, longitude:-74.002091),
                                   CLLocationCoordinate2D(latitude:40.730461, longitude:-74.001755),
                                   CLLocationCoordinate2D(latitude:40.730579, longitude:-74.001687),
                                   CLLocationCoordinate2D(latitude:40.73059, longitude:-74.001679),
                                   CLLocationCoordinate2D(latitude:40.730827, longitude:-74.001549),
                                   CLLocationCoordinate2D(latitude:40.73101, longitude:-74.001442),
                                   CLLocationCoordinate2D(latitude:40.731063, longitude:-74.001412),
                                   CLLocationCoordinate2D(latitude:40.731124, longitude:-74.001374),
                                   CLLocationCoordinate2D(latitude:40.731338, longitude:-74.001214),
                                   CLLocationCoordinate2D(latitude:40.731643, longitude:-74.001),
                                   CLLocationCoordinate2D(latitude:40.731704, longitude:-74.000954),
                                   CLLocationCoordinate2D(latitude:40.731769, longitude:-74.000908),
                                   CLLocationCoordinate2D(latitude:40.731853, longitude:-74.000847),
                                   CLLocationCoordinate2D(latitude:40.732315, longitude:-74.000512),
                                   CLLocationCoordinate2D(latitude:40.732929, longitude:-74.000069),
                                   CLLocationCoordinate2D(latitude:40.733169, longitude:-73.999886),
                                   CLLocationCoordinate2D(latitude:40.733573, longitude:-73.999589),
                                   CLLocationCoordinate2D(latitude:40.733661, longitude:-73.999527),
                                   CLLocationCoordinate2D(latitude:40.73376, longitude:-73.999451),
                                   CLLocationCoordinate2D(latitude:40.734088, longitude:-73.999222),
                                   CLLocationCoordinate2D(latitude:40.734134, longitude:-73.999192),
                                   CLLocationCoordinate2D(latitude:40.734214, longitude:-73.999131),
                                   CLLocationCoordinate2D(latitude:40.734783, longitude:-73.998711),
                                   CLLocationCoordinate2D(latitude:40.734989, longitude:-73.998566),
                                   CLLocationCoordinate2D(latitude:40.735031, longitude:-73.998543),
                                   CLLocationCoordinate2D(latitude:40.735389, longitude:-73.998276),
                                   CLLocationCoordinate2D(latitude:40.73603, longitude:-73.997803),
                                   CLLocationCoordinate2D(latitude:40.736293, longitude:-73.997612),
                                   CLLocationCoordinate2D(latitude:40.736667, longitude:-73.997338),
                                   CLLocationCoordinate2D(latitude:40.737361, longitude:-73.996842),
                                   CLLocationCoordinate2D(latitude:40.737934, longitude:-73.996422),
                                   CLLocationCoordinate2D(latitude:40.738044, longitude:-73.996338),
                                   CLLocationCoordinate2D(latitude:40.738685, longitude:-73.9958729999999),
                                   CLLocationCoordinate2D(latitude:40.739273, longitude:-73.9954459999999),
                                   CLLocationCoordinate2D(latitude:40.73986, longitude:-73.9950189999999),
                                   CLLocationCoordinate2D(latitude:40.74044, longitude:-73.9945909999999),
                                   CLLocationCoordinate2D(latitude:40.741031, longitude:-73.9941639999999),
                                   CLLocationCoordinate2D(latitude:40.741615, longitude:-73.9937369999999),
                                   CLLocationCoordinate2D(latitude:40.742233, longitude:-73.9932939999999),
                                   CLLocationCoordinate2D(latitude:40.7429, longitude:-73.9928059999999),
                                   CLLocationCoordinate2D(latitude:40.743568, longitude:-73.9923179999999),
                                   CLLocationCoordinate2D(latitude:40.744186, longitude:-73.9918749999999),
                                   CLLocationCoordinate2D(latitude:40.745384, longitude:-73.9947059999999),
                                   CLLocationCoordinate2D(latitude:40.744766, longitude:-73.9951629999999),
                                   CLLocationCoordinate2D(latitude:40.74398, longitude:-73.9932939999999)]])

        let polyline = mapview?.addPolyline(options: polylineOptions)

//
//        let polygon
        
        
 
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
        
        mapview?.setLatLngBounds(bounds: bounds, padding: paddingPercentage, duration: 0.5)
        
    }
    
    @objc func rightButtonTapped(){
        if mapview!.mapOptions.isTransitLayerEnabled{
            mapview?.mapOptions.isTransitLayerEnabled = false
        }else {
            mapview?.mapOptions.isTransitLayerEnabled = true
        }
        
        if mapview!.mapOptions.is3DBuildingsEnabled{
            mapview?.mapOptions.is3DBuildingsEnabled = false
        }else {
            mapview?.mapOptions.is3DBuildingsEnabled = true
        }
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        if let path = Bundle.main.path(forResource: "mapfit-day", ofType: "yaml")  {
//            self.mapview = MFTMapView(frame: self.view.bounds, customMapStyle: "file:///\(path)")
//        }
        
        self.mapview = MFTMapView(frame: self.view.bounds)
        
        let polygonOptions = MFTPolygonOptions()
        polygonOptions.setLineCapType(.round)
        polygonOptions.setLineJoinType(.miter)
        polygonOptions.addPoints([[CLLocationCoordinate2D(latitude: 40.7368876593604, longitude: -73.9785409464787),
                                   CLLocationCoordinate2D(latitude: 40.7313501345546, longitude: -73.982556292978),
                                   CLLocationCoordinate2D(latitude:  40.7344347901369, longitude: -73.9899029597005),
                                   CLLocationCoordinate2D(latitude: 40.7354082589172, longitude: -73.9898742137078),
                                   CLLocationCoordinate2D(latitude: 40.7433247184166, longitude: -73.9840748526015),
                                   CLLocationCoordinate2D(latitude:  40.7419697680819, longitude:-73.9808596541241),
                                   CLLocationCoordinate2D(latitude: 40.739498439778, longitude: -73.9826675979102),
                                   CLLocationCoordinate2D(latitude: 40.7375539536562, longitude: -73.9780522649762),
                                   CLLocationCoordinate2D(latitude: 40.7368876593604, longitude: -73.9785409464787)
            ]])
        
        self.polygon = mapview?.addPolygon(options: polygonOptions)
        
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


    




