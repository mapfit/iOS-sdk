//
//  MFTManager.swift
//  iOS.SDK
//
//  Created by Zain N. on 12/5/17.
//  Copyright © 2017 Mapfit. All rights reserved.
//

import Foundation
import UIKit

protocol MFTManagerProtocol {
    var apiKey: String? { set get }
}

/**
 `MFTManager` is a singleton object used for managing state between the various dependencies. Right now, it only manages the API key system.
 */

open class MFTManager: NSObject, MFTManagerProtocol {
    /// The single object to be used for all access
    open static let sharedManager = MFTManager()
    static let SDK_VERSION_KEY = "sdk_version"
    
    /// The Mapfit API key. If this is not set, exceptions will get raised by the various objects in use.
    @objc dynamic open var apiKey: String?
    
    fileprivate override init(){
        super.init()
    }
    
    //MARK: - Http Headers
    func httpHeaders() -> [String:String] {
        var headers = [String:String]()
        headers["User-Agent"] = buildUserAgent()
        headers["Cache-Control"] = "608400"
        
        
        return headers
    }
    
    fileprivate func buildUserAgent() -> String {
        let systemVersion = UIDevice.current.systemVersion
        var sdkVersion = "0"
        //Now for the fun - we grab the current bundle
        let bundle = Bundle(for: MFTManager.self)
        // Assuming cocoapods did its thing and ran setup_version.swift, there will be a version.plist in our bundle
        if let pathForVersionPlist = bundle.path(forResource: "version", ofType: "plist") {
            if let versionDict = NSDictionary(contentsOfFile: pathForVersionPlist) {
                if let version = versionDict[MFTManager.SDK_VERSION_KEY] {
                    sdkVersion = version as! String
                }
            }
        }
        return "ios-sdk;\(sdkVersion),\(systemVersion)"
    }
}

@objc public enum MFTError: Int {
    case generalError, annotationDoesNotExist, apiKeyNotSet, routeDoesNotExist
}
