//
//  ViewController.swift
//  Sample-App
//
//  Created by Zain N. on 2/21/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import UIKit
import Mapfit_iOS_SDK
import CoreLocation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MFTManager.sharedManager.apiKey = "591dccc4e499ca0001a4c6a41a2ed1be54804856508265221862231b"
        let mapview = MFTMapView(frame: view.bounds)
        
        mapview.mapOptions.setTheme(theme: .day)
        self.view.addSubview(mapview)
        
        var builder = MFTLatLngBounds.Builder()
        
        
        
      //  builder.add(latLng: CLLocationCoordinate2D(latitude: 40.74405, longitude: -73.99324))
      //  builder.add(latLng: CLLocationCoordinate2D(latitude: 40.729913, longitude: -74.000664))
//        builder.add(latLng: CLLocationCoordinate2D(latitude:  40.7344347901369, longitude: -73.9899029597005))
//        builder.add(latLng: CLLocationCoordinate2D(latitude: 40.7354082589172, longitude: -73.9898742137078))
//        builder.add(latLng: CLLocationCoordinate2D(latitude: 40.7433247184166, longitude: -73.9840748526015))
//        builder.add(latLng: CLLocationCoordinate2D(latitude:  40.7419697680819, longitude:-73.9808596541241))
//        builder.add(latLng: CLLocationCoordinate2D(latitude: 40.739498439778, longitude: -73.9826675979102))
//        builder.add(latLng:  CLLocationCoordinate2D(latitude: 40.7375539536562, longitude: -73.9780522649762))
//        builder.add(latLng: CLLocationCoordinate2D(latitude: 40.7368876593604, longitude: -73.9785409464787))


//
//        _ = mapview.addPolygon([[CLLocationCoordinate2D(latitude: 40.7368876593604, longitude: -73.9785409464787),
//                             CLLocationCoordinate2D(latitude: 40.7313501345546, longitude: -73.982556292978),
//                             CLLocationCoordinate2D(latitude:  40.7344347901369, longitude: -73.9899029597005),
//                             CLLocationCoordinate2D(latitude: 40.7354082589172, longitude: -73.9898742137078),
//                             CLLocationCoordinate2D(latitude: 40.7433247184166, longitude: -73.9840748526015),
//                             CLLocationCoordinate2D(latitude:  40.7419697680819, longitude:-73.9808596541241),
//                             CLLocationCoordinate2D(latitude: 40.739498439778, longitude: -73.9826675979102),
//                             CLLocationCoordinate2D(latitude: 40.7375539536562, longitude: -73.9780522649762),
//                             CLLocationCoordinate2D(latitude: 40.7368876593604, longitude: -73.9785409464787),
//                             ]])
        
        
        //mapview.setCenter(position: CLLocationCoordinate2D(latitude: 40.729913, longitude: -74.000664))
        //mapview.setCenter(position: CLLocationCoordinate2D(latitude: 40.74405, longitude: -73.99324))
        mapview.mapOptions.setMaxZoomLevel(zoomLevel: 17)
        mapview.mapOptions.setMinZoomLevel(zoomLevel: 10)
        
        mapview.setZoom(zoomLevel: 19)
        
//        mapview.mapOptions.setCompassVisibility(true)
//        mapview.mapOptions.setRecenterVisibility(true)
//        mapview.mapOptions.setZoomControlVisibility(true)
        
    
        //let marker = mapview.addMarker(position: CLLocationCoordinate2D(latitude: 40.729913, longitude: -74.000664))
        
        let marker = mapview.addMarker(address: "111 Macdougal Street NY, NY") { (marker, error) in
            marker?.title = "Artichoke Basille's Pizza & Brewery"
            marker?.subtitle1 = "111 Macdougal St (btwn Bleecker & W 3rd St)"
            marker?.subtitle2 = "Pizza, Italian"
            mapview.setCenter(position:  marker!.getPosition())
           
        }
        
//        let marker2 = mapview.addMarker(address: "119 W 24th Street new york ny") { (marker, error) in
//            marker?.title = "Artichoke Basille's Pizza & Brewery"
//            marker?.subtitle1 = "111 Macdougal St (btwn Bleecker & W 3rd St)"
//            marker?.subtitle2 = "Pizza, Italian"
//
//        }
        
        
        
       // mapview.directionsOptions.setOrigin(CLLocationCoordinate2D(latitude: 40.74405, longitude: -73.99324))
       // mapview.directionsOptions.setDestination(CLLocationCoordinate2D(latitude: 40.729913, longitude: -74.000664))
        
//        mapview.directionsOptions.setOrigin("111 Macdougal Street new york ny")
//        mapview.directionsOptions.setDestination("119 W 24th Street new york ny")
//
//
//
//        mapview.directionsOptions.setType(.driving)
//        mapview.directionsOptions.showDirections { (polyline, error) in
//
//
//            for point in polyline!.points {
//                for coordinate in point {
//                     builder.add(latLng: coordinate)
//                }
//            }
//
//
//            let bounds = builder.build()
//            let paddingPercentage = Float(0.8)
//
//            mapview.setLatLngBounds(bounds: bounds, padding: paddingPercentage)
//
//
//        }
//
        
        
        //marker.setIcon("https://cdn.stg.mapfit.com/v2/assets/images/markers/custom/example-custom-pin.png")
     
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

