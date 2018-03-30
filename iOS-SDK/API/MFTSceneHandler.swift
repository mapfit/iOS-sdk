//
//  MFTSceneHandler.swift
//  Mapfit
//
//  Created by Zain N. on 3/29/18.
//

import Foundation

public class MFTSceneHandler {

    public static let sharedInstance = MFTSceneHandler()
    

    public func getScene(urlString: String, completion: @escaping (_ localString: String?) -> Void) {
        
        
        let session = URLSession.init(configuration: .default)
        
        let escapedPath = "\(urlString)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        let url = URL.init(string: escapedPath!)
        
        var request = URLRequest.init(url: url!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 15)
        
        if (URLCache.shared.cachedResponse(for: request) != nil){
            print("there is a cached response")
        }else {
            print("there is no cached response")
        }
        
        
        request.httpMethod = "GET"

        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
            }
            
            do { // try to parse JSON
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if JSONSerialization.isValidJSONObject(json) {
                    
                } else {
                    
                }

            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
            }
            
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
