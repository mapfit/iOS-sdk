//
//  BuildingExtruder.swift
//  Mapfit
//
//  Created by Zain N. on 8/2/18.
//

import Foundation
import CoreLocation
import TangramMap


internal class MFTBuilding{
    
    var position: CGPoint = CGPoint()
    var latLng: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var id: String = ""
    var rootId: String = ""
    public var uuid: UUID
    
    init(screenPostion: CGPoint = CGPoint(x: 0, y: 0), latLng: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0), id: String = "", rootId: String = "" ) {
        self.position = screenPostion
        self.latLng = latLng
        self.id = id
        self.rootId = rootId
        self.uuid = UUID()
        
    }
}

extension MFTBuilding : Equatable {
    public static func ==(lhs: MFTBuilding, rhs: MFTBuilding) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}


internal class BuildingExtruder{
    
    
    init(mapView: MFTMapView){
        self.mapView = mapView
    }
    static let extrude = "extrude"
    static let flatten = "flatten"
    private var buildings = [MFTBuilding]()
    private var extrudeQueue = [MFTBuilding]()
    private var flattenQueue = [MFTBuilding]()
    private var extrudedBuildingCount = 0
    private var flattenedBuildingCount = 0
    private var stringBuilder = ""
    private var styleSceneUpdates = [MFTSceneUpdate]()
    var mapView: MFTMapView!
    
    func flatten(latLngs: [CLLocationCoordinate2D]) {
        var alreadyExtruded = [MFTBuilding]()
        
    
        for latLng in latLngs {
            if let first = buildings.first(where: { (it) -> Bool in
                it.latLng.latitude == latLng.latitude && it.latLng.longitude == it.latLng.longitude
            }) {
                alreadyExtruded.append(first)
            }
            
        }
        
        
        if (alreadyExtruded.isEmpty){
            addToQueue(latLngs: latLngs, queue: &flattenQueue)
        }else{
            alreadyExtruded.forEach { (it) in
                if let index = buildings.index(of: it){
                    buildings.remove(at: index)
                }
            }
            
            refreshStringBuilder()
            updateScene(filterFunction: getFilterFunction())
        }
        
    }
        
        
        
    
    
    func extrude(latlngs: [CLLocationCoordinate2D], buildingOptions: MFTBuildingOptions) {
        addToQueue(latLngs: latlngs, queue: &extrudeQueue)
        
        styleSceneUpdates.removeAll()
        styleSceneUpdates = styleSceneUpdates + bundleSceneUpdates(buildingOptions: buildingOptions)
    }
    
    private func bundleSceneUpdates(buildingOptions: MFTBuildingOptions)-> [MFTSceneUpdate] {
        var styleSceneUpdates = [MFTSceneUpdate]()
        
        if (!buildingOptions.fillColor.isEmpty) {
            styleSceneUpdates.append(MFTSceneUpdate(
                path: "layers.buildings_extruded.draw.sdk-extruded-building-overlay.color",
                value: "'\(buildingOptions.fillColor)'"
                )
            )
        }
        if (buildingOptions.drawOrder != Int.min) {
            styleSceneUpdates.append(
                MFTSceneUpdate(
                    path: "layers.buildings_extruded.draw.sdk-extruded-building-overlay.order",
                    value: "'\(buildingOptions.drawOrder)'"
                )
            )
        }
        if (buildingOptions.strokeWidth != Int.min) {
            styleSceneUpdates.append(
                MFTSceneUpdate(
                    path: "layers.buildings_extruded.draw.sdk-line-overlay.width",
                    value: "'\(buildingOptions.strokeWidth)'"
                )
            )
        }
        if (!buildingOptions.strokeColor.isEmpty) {
            styleSceneUpdates.append(
                MFTSceneUpdate(
                    path: "layers.buildings_extruded.draw.sdk-line-overlay.color",
                    value: "'\(buildingOptions.strokeColor)'"
                )
            )
        }
        if (buildingOptions.lineJoinType != MFTLineJoinType.miter) {
            styleSceneUpdates.append(
                MFTSceneUpdate(
                    path: "layers.buildings_extruded.draw.sdk-line-overlay.join",
                    value: "'\(buildingOptions.lineJoinType.rawValue)'"
                )
            )
            styleSceneUpdates.append(
                MFTSceneUpdate(
                    path: "layers.buildings_extruded.draw.sdk-line-overlay.outline.join",
                    value: "'\(buildingOptions.lineJoinType.rawValue)'"
                )
            )
        }
        if (!buildingOptions.strokeOutlineColor.isEmpty) {
            styleSceneUpdates.append(
                MFTSceneUpdate(
                    path: "layers.buildings_extruded.draw.sdk-line-overlay.outline.color",
                    value: "'\(buildingOptions.strokeOutlineColor)'"
                )
            )
        }
        if (buildingOptions.strokeOutlineWidth != Int.min) {
            styleSceneUpdates.append(
                MFTSceneUpdate(
                    path: "layers.buildings_extruded.draw.sdk-line-overlay.outline.width",
                    value: "'\(buildingOptions.strokeOutlineWidth)'"
                )
            )
        }
        
        return styleSceneUpdates
    }
    
    
    
    

    
    
    private func addToQueue(latLngs: [CLLocationCoordinate2D],  queue: inout [MFTBuilding]){

    for latLng in latLngs{
    
    let screenPosition = mapView.latLngToScreenPosition(latLng)
    
        queue.append(MFTBuilding(screenPostion: screenPosition, latLng: latLng))
    
        mapView.tgMapView.pickFeature(at: screenPosition)
    }
    
        clearQueueAfterDelay()
    }
    
    
    internal func handleFeature(properties: [String : String]){
        if (!flattenQueue.isEmpty) {
            handleFlattening(properties)
        }else if (!extrudeQueue.isEmpty) {
            handleExtruding(properties)
        }
    }
    
    
    private func clearQueueAfterDelay(){
        DispatchQueue.main.async {
                 let postponeDuration = self.flattenQueue.count * 100 + self.extrudeQueue.count * 100
            
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(postponeDuration), execute: {
                self.flattenQueue.removeAll()
                self.extrudeQueue.removeAll()
            })
        }
   
        

        
        
    }
    
    
    private func handleFlattening(_ properties: [String : String]) {
        
        let (rootId, id) = extractIds(properties)
        
        let existingBuilding: MFTBuilding? =
            
            buildings.first { (it) -> Bool in
                (it.id != "" && it.id == id) || (it.rootId != "" && it.rootId == rootId)
        }
        
        if let building = existingBuilding {
            if let indexOfExisting  = buildings.index(of: building) {
                buildings.remove(at: indexOfExisting)
            }
        }
        
        flattenQueue.removeAll()
        
        if flattenQueue.isEmpty && flattenedBuildingCount > 0 {
            refreshStringBuilder()
            updateScene(filterFunction: getFilterFunction())
        }
        
    }
    
    
    private func handleExtruding(_ properties: [String : String]) {
            
            let building = self.extrudeQueue.removeFirst()
                
            
                self.addBuildingToExtrude(properties, building)
            
            
            if self.extrudeQueue.isEmpty && self.extrudedBuildingCount > 0 {
                self.updateScene(filterFunction: self.getFilterFunction())
            }

    }
    
    
    private func refreshStringBuilder() {
        stringBuilder = ""
        
        buildings.forEach { (it) in
            if (it.id != "") {
                appendId(it.id)
            }
            
            if (it.rootId != ""){
                appendRootId(it.rootId)
            }
        }
        
        
    }
    
    private func updateScene(filterFunction: String){
        var sceneUpdates = [MFTSceneUpdate(path: "layers.buildings_extruded.filter", value: "function() { return \(filterFunction); }")]
        
        
        if (styleSceneUpdates.count > 0){
            for update in styleSceneUpdates {sceneUpdates.append(update)}
            
        }
        mapView.updateSceneAsync(sceneUpdates)
        
        extrudedBuildingCount = 0
        flattenedBuildingCount = 0
    }

    private func getFilterFunction()-> String {
        
        var function = stringBuilder
        
        if (function.hasPrefix(" || ")) {
            function = String(function.dropFirst(4))
        }
        return function
    }
    
    
    
    
    
    private func addBuildingToExtrude(_ properties: [String : String], _ building: MFTBuilding) {
    let (rootId, id) = extractIds(properties)
    
    var buildingExist = false
    
    // check if the building is already extruded
    for obj in buildings {
    if (obj.id != "" && obj.id == id || obj.rootId != "" && obj.rootId == rootId) {
    buildingExist = true
    }
    }
    
    if (buildingExist) {
    return
    }
    
    if (id != "") {
    appendId(id)
    appendRootId(id)
    building.id = id
    building.rootId = id
    }
    
    buildings.append(building)
    extrudedBuildingCount += 1
    
    }
    
    
    
    
    
    
    private func extractIds(_ properties: [String : String]) -> (String, String) {
        var rootId = ""
        var id = ""
        
        if let root = properties["root_id"] {
            
            rootId = root
            
        } else if let unwrappedId = properties["id"] {
            
            id = unwrappedId
            
        }
        return (rootId, id)
    }

    
    
    
    


    private func appendId(_ id: String) {
        stringBuilder.append(" || feature.id == \(id)")
    }
    
    private func appendRootId(_ rootId: String) {
        stringBuilder.append(" || feature.root_id == \(rootId)")
    }
    
    

    
    
    
 
    
}
