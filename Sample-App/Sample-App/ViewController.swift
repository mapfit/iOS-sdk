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
    
     var orbitTrajectory = OrbitTrajectory()
     var orbitAnimation:  Cinematography? = nil
     var cameraAnimation: CameraAnimation? = nil
  
    

    
    func setupNav(){
        let leftButton = UIBarButtonItem(title: "Test 1", style: .plain, target: self, action: #selector(leftButtonTapped))
        let rightButton = UIBarButtonItem(title: "Test 2", style: .plain, target: self, action: #selector(rightButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.title = "Sample App"
        
    }
    
    @objc func leftButtonTapped(){

        
        let buildingOptions = MFTBuildingOptions()
            self.mapview?.extrudeBuildings(latLngs: [CLLocationCoordinate2D(latitude: 40.702238, longitude: -73.987440), CLLocationCoordinate2D(latitude: 40.701953719842678, longitude: -73.988017183898293)], buildingOptions: buildingOptions)
    }
    
    func setBounds(){
        
    }
    
    @objc func rightButtonTapped(){
        
        
        self.mapview?.flattenBuilding(latLngs: [CLLocationCoordinate2D(latitude: 40.702238, longitude: -73.987440), CLLocationCoordinate2D(latitude: 40.701953719842678, longitude: -73.988017183898293)])
        
//        let callBack: ()->AnimationCallback = {
//            struct c : AnimationCallback {
//                func onStart() {
//                    // invoked when the animation is started
//                }
//
//                func onFinish() {
//                    // invoked when the animation has ended
//                }
//            }
//
//            return c() as AnimationCallback
//        }
//
//        let pivotPosition = CLLocationCoordinate2D(latitude: 40.743502, longitude: -73.991667)
//        // define the options for the animation
//
//        orbitTrajectory.loop(loop: false)
//        orbitTrajectory.pivot(position: pivotPosition, centerToPivot: true, duration: 1, easeType: .quartIn)
//        orbitTrajectory.duration(duration: 10)
//        orbitTrajectory.tiltTo(angle: 2, duration: 4, easeType: .linear)
//        orbitTrajectory.zoomTo(zoomLevel: 15, duration: 2, easeType: .expInOut)
//        orbitTrajectory.speedMultiplier(multiplier: 2) /* positive values will rotate anti-clockwise whereas negative values will rotate clockwise */
//
//        // create the animation
//        if let mapview = self.mapview {
//            self.orbitAnimation = Cinematography(mapview)
//
//            self.cameraAnimation = self.orbitAnimation?.create(cameraOptions: orbitTrajectory, cameraAnimationCallback: callBack)
//            self.cameraAnimation?.start()
//
//            //stop the animation
//            //animation.stop()
//
//        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        if let path = Bundle.main.path(forResource: "day-theme", ofType: "yaml")  {
//            self.mapview = MFTMapView(frame: view.bounds, customMapStyle: "file://\(path)")
//        }
        
        self.mapview = MFTMapView(frame: view.bounds)
        
       
        setupNav()
        if let mapview = self.mapview {
            
    
            
            view.addSubview(mapview)
            mapview.setZoom(zoomLevel: 17)
            mapview.setCenter(position: CLLocationCoordinate2D(latitude: 40.702238, longitude: -73.987440))
        }
 

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}







    




