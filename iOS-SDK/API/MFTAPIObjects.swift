//
//  APIObjects.swift
//  iOS.SDK
//
//  Created by Zain N. on 1/18/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import Foundation

public struct Address : Decodable {
   public var streetAddress: String?
   public var responseType: Double?
   public var adminArea: String?
   public var locality: String?
   public var neighborhood: String?
   public var entrances: [Location]?
   public var postalCode: String?
   public var building: Building?
   public var country: String?
   public var location: Location?
    public var viewport: Viewport?
    
    private enum CodingKeys: String, CodingKey {
        case streetAddress = "street_address", adminArea = "admin_1", responseType = "response_type", postalCode = "postal_code", locality, neighborhood, entrances, building, country, location, viewport
    }
    
}

public struct Viewport: Decodable {
    public var southwest : Location?
    public var northeast : Location?
}




public struct Building: Decodable {
   public var coordinates : [[[Double]]]?
   public var type: String?
    
}

public struct Route : Decodable {
   public var trip: Trip?
   public var sourceLocation: [Double]?
   public var destinationLocation: [Double]?
    
}

 public struct Trip: Decodable {
   public var locations: [Location]?
   public var language: String?
   public var status: Int?
   public var statusMessage: String?
   public var units: String?
   public var summary: Summary?
   public var legs: [Leg]?
    
    private enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message", language, status, locations, units, legs, summary
    }
}

 public struct Location: Decodable {
   public var lng: Double?
   public var lat: Double?
   public var placeType: String?
   public var sideOfStreet: String?
   public var entranceType: String?
   public var type: String?
    
    
    private enum CodingKeys: String, CodingKey {
        case placeType = "place-type", entranceType = "entrance_type", lng = "lon", lat, sideOfStreet = "side_of_street", type
    }
}

 public struct Leg: Decodable {
   public var shape: String?
   public var summary: Summary?
   public var maneuvers: [Manuever]?
}

 public struct Summary : Decodable {
    
   public var maxLat: Double?
   public var minLat: Double?
   public var maxLon: Double?
   public var minLon: Double?
   public var legnth: Double?
   public var time: Int?
    
    private enum CodingKeys: String, CodingKey {
        case maxLat = "max_lat", minLon = "min_lon", minLat = "min_lat", maxLon = "max_lon", legnth, time
    }
}

public struct Manuever : Decodable {
   public var beginShapeIndex: Int?
   public var endShapeIndex: Int?
   public var travelType: String?
   public var instruction: String?
   public var travelMode: String?
   public var verbalPreTransitionInstruction: String?
   public var legnth: Double?
   public var time: Int?
   public var type: Int?
   public var streetNames: [String]?
    
    //var sign: [String: Any]?
    //clarify what is included in sign object
    
   public var verbalTransitionAlertInstruction: String?
   public var verbalPostTransitionInstruction: String?
    
    private enum CodingKeys: String, CodingKey {
        case beginShapeIndex = "begin_shape_index", endShapeIndex = "end_shape_index", travelType = "travel_type", verbalPreTransitionInstruction = "verbal_pre_transition_instruction", streetNames = "street_names", legnth, time, type, instruction, travelMode = "travel_mode", verbalPostTransitionInstruction = "verbal_post_transition_instruction", verbalTransitionAlertInstruction = "verbal_transition_Alert_instruction"
    }
}






