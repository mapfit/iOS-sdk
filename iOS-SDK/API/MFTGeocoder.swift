//
//  MFTGeocoder.swift
//  iOS.SDK
//
//  Created by Zain N. on 1/18/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import Foundation
import CoreLocation

/**
 API class for geocoding an address and displaying a marker on the map.
 */

public class MFTGeocoder {
    
    static let geocodeHost = "https://api.mapfit.com/v2/geocode"
    static let reverseGeocodeHost = "https://api.mapfit.com/v2/reverse-geocode"
    private let apiKey = MFTManager.sharedManager.apiKey
    public static let sharedInstance = MFTGeocoder()

    /**
     Geocode Get request
     - parameter address: string address
     - parameter includes buildings: Bool to return building coordinates
     - returns: completion with optional address and optional Error
     */
    
    
    public func geocode(address: String, includeBuilding: Bool, completion: @escaping (_ address: [Address]?, _ error: Error?)->Void){
        
        //Check if there is a valid api key
        guard let key = apiKey else { return }
        
        let escapedPath = "\(MFTGeocoder.geocodeHost)?street_address=\(address)&building=\(includeBuilding.description)&api_key=\(key)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        let url = URL.init(string: escapedPath!)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                
                
                completion(nil, error!)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                
            }

            do {
                
                let address = try JSONDecoder().decode([Address].self, from: data)
                completion(address, nil)
                
            } catch {
                
                completion(nil, error)
            }
            
        }
        task.resume()
    }
    
     public func reverseGeocode(latLng: CLLocationCoordinate2D, includeBuilding: Bool, completion: @escaping (_ address: [Address]?, _ error: Error?)->Void){
        //Check if there is a valid api key
        guard let key = apiKey else { return }
        
        let escapedPath = "\(MFTGeocoder.reverseGeocodeHost)?lat=\(latLng.latitude)&lon=\(latLng.longitude)&building=\(includeBuilding.description)&api_key=\(key)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        let url = URL.init(string: escapedPath!)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                
                
                completion(nil, error!)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                
            }
            
            do {
                
                let address = try JSONDecoder().decode([Address].self, from: data)
                completion(address, nil)
                
            } catch {
                
                completion(nil, error)
            }
            
        }
        task.resume()
    }
    
        
    

    
    internal func getPositionFromAddress(address: String, completion: @escaping (_ position: CLLocationCoordinate2D?, _ error: Error?)->Void){
        MFTGeocoder.sharedInstance.geocode(address: address, includeBuilding: true) { (addressesObject, error) in
            if error == nil {
                guard let addressObject = addressesObject else { return }
                if let entrances = addressObject[0].entrances {
                    guard let lat = entrances[0].lat else { return }
                    guard let lng = entrances[0].lng else { return }
                    completion(CLLocationCoordinate2D(latitude: lat, longitude: lng), nil)
                    
                } else if let location = addressObject[0].location {
                    guard let lat = location.lat else { return }
                    guard let lng = location.lng else { return }
                    completion(CLLocationCoordinate2D(latitude: lat, longitude: lng), nil)
                }
                
            } else {
                completion(nil, error)
            }
        }
    
    }
    
    internal func parseAddressObjectForPosition(addressObject: [Address]) -> (CLLocationCoordinate2D?, MFTError?) {
        
        if let entrances = addressObject[0].entrances {
            guard let lat = entrances[0].lat else { return (nil, MFTError.generalError) }
            guard let lon = entrances[0].lng else { return (nil, MFTError.generalError) }
            return (CLLocationCoordinate2D(latitude: lat, longitude: lon), nil)
            
        } else if let location = addressObject[0].location {
            guard let lat = location.lat else { return (nil, MFTError.generalError) }
            guard let lon = location.lng else { return (nil, MFTError.generalError) }
            return (CLLocationCoordinate2D(latitude: lat, longitude: lon), nil)
        }
        
       return (nil, MFTError.generalError)
    }
    
}
