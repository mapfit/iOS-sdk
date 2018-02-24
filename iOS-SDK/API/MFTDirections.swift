//
//  MFTDirections.swift
//  iOS.SDK
//
//  Created by Zain N. on 1/18/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import Foundation
import CoreLocation

/**
 API Class for getting directions to display on the map.
 */


public class MFTDirections {
    
    static let directionsHost = "https://api.mapfit.com/v1/directions"
    private let apiKey = MFTManager.sharedManager.apiKey
    public static let sharedInstance = MFTDirections()
    
    /**
     Directions POST request
     - parameter directionsType: defined in Constants - driving, cycling, walking
     - parameter origin: optional - starting location
     - parameter originAddress: optional - starting address
     - parameter destination: optional - end location
     - parameter destinationAddress: optional - end address
     - returns: completion with optional route and optional Error
     */
    
    public func route(origin: CLLocationCoordinate2D?, originAddress: String?, destination: CLLocationCoordinate2D?, destinationAddress: String?, directionsType: MFTDirectionsType, completion: @escaping (_ routeDict: Route?, _ error: Error?) -> Void) {
        
        //Check if there is a valid api key
        guard let key = apiKey else { return }
        
        let session = URLSession.init(configuration: .default)
        
        let escapedPath = "\(MFTDirections.directionsHost)?api_key=\(key)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        let url = URL.init(string: escapedPath!)
        
        var request = URLRequest.init(url: url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)

        var httpBody = ""
        
        if let givenOrigin = origin, let givenOriginAddress = originAddress, let givenDestination = destination, let givenDestinationAddress = destinationAddress {
             httpBody = "{\"source-address\":{\"address\":\"\(givenOriginAddress)\",\"lat\":\(givenOrigin.latitude),\"lon\":\(givenOrigin.longitude),\"type\":\"\("all-pedestrian")\"},\"destination-address\":{\"address\":\"\(givenDestinationAddress)\",\"lat\":\(givenDestination.latitude),\"lon\":\(givenDestination.longitude),\"type\":\"all-pedestrian\"},\"type\":\"\(directionsType.rawValue)\"}}"
        }  else if let givenOrigin = origin, let givenOriginAddress = originAddress, let givenDestination = destination {
            httpBody = "{\"source-address\":{\"address\":\"\(givenOriginAddress)\",\"lat\":\(givenOrigin.latitude),\"lon\":\(givenOrigin.longitude),\"type\":\"\("all-pedestrian")\"},\"destination-address\":{\"lat\":\(givenDestination.latitude),\"lon\":\(givenDestination.longitude),\"type\":\"all-pedestrian\"},\"type\":\"\(directionsType.rawValue)\"}}"
        }  else if let givenOrigin = origin, let givenDestination = destination, let givenDestinationAddress = destinationAddress {
             httpBody = "{\"source-address\":{\"lat\":\(givenOrigin.latitude),\"lon\":\(givenOrigin.longitude),\"type\":\"\("all-pedestrian")\"},\"destination-address\":{\"address\":\"\(givenDestinationAddress)\",\"lat\":\(givenDestination.latitude),\"lon\":\(givenDestination.longitude),\"type\":\"all-pedestrian\"},\"type\":\"\(directionsType.rawValue)\"}}"
        }  else if let givenOrigin = origin, let givenDestination = destination, let givenDestinationAddress = destinationAddress {
            httpBody = "{\"source-address\":{\"lat\":\(givenOrigin.latitude),\"lon\":\(givenOrigin.longitude),\"type\":\"\("all-pedestrian")\"},\"destination-address\":{\"address\":\"\(givenDestinationAddress)\",\"lat\":\(givenDestination.latitude),\"lon\":\(givenDestination.longitude),\"type\":\"all-pedestrian\"},\"type\":\"\(directionsType.rawValue)\"}}"
        }  else if let givenOrigin = origin, let givenDestinationAddress = destinationAddress{
            httpBody = "{\"source-address\":{\"lat\":\(givenOrigin.latitude),\"lon\":\(givenOrigin.longitude),\"type\":\"\("all-pedestrian")\"},\"destination-address\":{\"address\":\"\(givenDestinationAddress)\",\"type\":\"all-pedestrian\"},\"type\":\"\(directionsType.rawValue)\"}}"
        }  else if let givenOriginAddress = originAddress, let givenDestination = destination, let givenDestinationAddress = destinationAddress {
            httpBody = "{\"source-address\":{\"address\":\"\(givenOriginAddress)\",\"type\":\"\("all-pedestrian")\"},\"destination-address\":{\"address\":\"\(givenDestinationAddress)\",\"lat\":\(givenDestination.latitude),\"lon\":\(givenDestination.longitude)\",\"type\":\"all-pedestrian\"},\"type\":\"\(directionsType.rawValue)\"}}"
        }  else if let givenOriginAddress = originAddress, let givenDestination = destination {
            httpBody = "{\"source-address\":{\"address\":\"\(givenOriginAddress)\",\"type\":\"\("all-pedestrian")\"},\"destination-address\":{\"lat\":\(givenDestination.latitude),\"lon\":\(givenDestination.longitude),\"type\":\"all-pedestrian\"},\"type\":\"\(directionsType.rawValue)\"}}"
        }  else if let givenOriginAddress = originAddress, let givenDestinationAddress = destinationAddress {
            httpBody = "{\"source-address\":{\"address\":\"\(givenOriginAddress)\",\"type\":\"\("all-pedestrian")\"},\"destination-address\":{\"address\":\"\(givenDestinationAddress)\",\"type\":\"all-pedestrian\"},\"type\":\"\(directionsType.rawValue)\"}}"
        }  else if let givenOrigin = origin, let givenDestination = destination {
            httpBody = "{\"source-address\":{\"lat\":\(givenOrigin.latitude),\"lon\":\(givenOrigin.longitude),\"type\":\"\("all-pedestrian")\"},\"destination-address\":{\"lat\":\(givenDestination.latitude),\"lon\":\(givenDestination.longitude),\"type\":\"all-pedestrian\"},\"type\":\"\(directionsType.rawValue)\"}}"
        }
        
        
        request.httpBody = httpBody.data(using: .utf8)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                
                print("error=\(String(describing: error))")
                
                completion(nil, error)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            do { // try to parse JSON
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if JSONSerialization.isValidJSONObject(json) {
                    print("valid json")
                } else {
                    print("invalid json")
                }
                
                let route = try JSONDecoder().decode(Route.self, from: data)
                completion(route, nil)
                
                
                
            } catch let error as NSError {
                print("error getting directions: \(error.localizedDescription)")
                completion(nil, error)
            }
            
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
}


