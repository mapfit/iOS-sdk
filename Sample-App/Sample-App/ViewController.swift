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
        
        MFTManager.sharedManager.apiKey = "591dccc4e499ca0001a4c6a41a2ed1be54804856508265221862231b"
        let mapview = MFTMapView(frame: view.bounds)
        
        mapview.mapOptions.setTheme(theme: .day)
        self.view.addSubview(mapview)
        
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


        let bounds = MFTLatLngBounds(builder: builder)
        mapview.setLatLngBounds(bounds: bounds, padding: 1)
        
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
//        mapview.mapOptions.setMaxZoomLevel(zoomLevel: 17)
//        mapview.mapOptions.setMinZoomLevel(zoomLevel: 10)
//
//        mapview.setZoom(zoomLevel: 19)
        
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
        
        
        
        mapview.directionsOptions.setOrigin(CLLocationCoordinate2D(latitude: 40.74405, longitude: -73.99324))
        mapview.directionsOptions.setDestination(CLLocationCoordinate2D(latitude: 40.729913, longitude: -74.000664))
        
        
        
        mapview.addPolyline([[CLLocationCoordinate2D(latitude:40.729877, longitude:-74.000588),
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
//                    print("CLLocationCoordinate2D(latitude:\(coordinate.latitude), longitude:\(coordinate.longitude)),")
//                }
//            }
//        }
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

