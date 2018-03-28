//
//  Themes.swift
//  iOS.SDK
//
//  Created by Zain N. on 12/5/17.
//  Copyright © 2017 Mapfit. All rights reserved.
//

import Foundation

/// An Enum showing map style
public enum MFTMapTheme: String {
    case day = "https://cdn.mapfit.com/v2-2/themes/mapfit-day.yaml"
    case night = "https://cdn.mapfit.com/v2-2/themes/mapfit-night.yaml"
    case grayScale = "https://cdn.mapfit.com/v2-2/themes/mapfit-grayscale.yaml"
    case custom = ""
}

internal enum GlobalStyleVars : String {
    case transitOverlay = "global.sdk_transit_overlay"
    case bikeOverlay = "global.sdk_bike_overlay"
    case pathOverlay = "global.sdk_path_overlay"
    case apiKey = "global.sdk_mapfit_api_key"
    case uxLanguage = "global.ux_language"
}


//@objc internal protocol MFTStyleSheet : class {
//    
//    @objc var fileLocation: URL? { get }
//    @objc var remoteFileLocation: URL? { get }
//    @objc var styleSheetRoot: String { get }
//    @objc var houseStylesRoot: String { get }
//    @objc var styleSheetFileName: String { get }
//    @objc var importString: String { get }
//    @objc var relativePath: String { get }
//    @objc var mapStyle: MFTMapTheme { get }
//    @objc var yamlString: String { get }
//    @objc var detailLevel: Int { get set }
//    @objc var labelLevel: Int { get set }
//    @objc var currentColor: String { get set }
//    
//    @objc var availableColors: [ String ] { get }
//    @objc var availableDetailLevels: Int { get }
//    @objc var availableLabelLevels: Int { get }
//}
//
//internal class MFTBaseStyle: NSObject, MFTStyleSheet {
//    
//    @objc open var detailLevel: Int = 0
//    @objc open var labelLevel: Int = 0
//    @objc open var currentColor: String = ""
//    
//    @objc open var mapStyle: MFTMapTheme {
//        get {
//            return .day
//        }
//    }
//    
//    @objc open var styleSheetFileName: String {
//        get {
//            return ""
//        }
//    }
//    
//    @objc open var styleSheetRoot: String {
//        get {
//            return ""
//        }
//    }
//    
//    @objc open var fileLocation: URL? {
//        get {
//            return Bundle.houseStylesBundle()?.url(forResource: relativePath, withExtension: "yaml")
//        }
//    }
//    
//    @objc open var remoteFileLocation: URL? {
//        get {
//            return nil
//        }
//    }
//    
//    @objc open var houseStylesRoot: String {
//        get {
//            return "houseStyles.bundle/"
//        }
//    }
//    
//    @objc open var importString: String {
//        get {
//            return "{ import: [ \(relativePath).yaml, \(yamlString) ] }"
//        }
//    }
//    
//    @objc open var relativePath: String {
//        get {
//            return "\(styleSheetFileName)"
//        }
//    }
//    
//    @objc open var yamlString: String {
//        get {
//            return ""
//        }
//    }
//    
//    @objc open var availableColors: [String] {
//        get {
//            return []
//        }
//    }
//    
//    @objc open var availableDetailLevels: Int {
//        get {
//            return 0
//        }
//    }
//    
//    @objc open var availableLabelLevels: Int {
//        get {
//            return 0
//        }
//    }
//}
//
//internal class MFTDayStyle: MFTBaseStyle {
//    public override init() {
//        super.init()
//        defer {
//            currentColor = ""
//            labelLevel = 5
//            detailLevel = 0
//        }
//    }
//    
//    @objc open override var mapStyle: MFTMapTheme {
//        get {
//            return .day
//        }
//    }
//    
//    @objc open override var styleSheetFileName: String {
//        get {
//            return "mapfit-day"
//        }
//    }
//    
//    @objc open override var styleSheetRoot: String {
//        get {
//            return "mapfit-day/"
//        }
//    }
//    
//    @objc override open var availableLabelLevels: Int {
//        get {
//            return 12
//        }
//    }
//    
//    @objc override open var yamlString: String {
//        get {
//            return "\(styleSheetRoot)themes/label-\(labelLevel).yaml"
//        }
//    }
//}
//
//internal class MFTNightStyle: MFTBaseStyle {
//    public override init() {
//        super.init()
//        defer {
//            currentColor = ""
//            labelLevel = 5
//            detailLevel = 0
//        }
//    }
//    
//    @objc open override var mapStyle: MFTMapTheme {
//        get {
//            return .night
//        }
//    }
//    
//    @objc open override var styleSheetFileName: String {
//        get {
//            return "mapfit-night"
//        }
//    }
//    
//    @objc open override var styleSheetRoot: String {
//        get {
//            return "mapfit-night/"
//        }
//    }
//    
//    @objc override open var availableLabelLevels: Int {
//        get {
//            return 12
//        }
//    }
//    
//    @objc override open var yamlString: String {
//        get {
//            return "\(styleSheetRoot)themes/label-\(labelLevel).yaml"
//        }
//    }
//}
//
//internal class MFTGreyScaleStyle: MFTBaseStyle {
//    public override init() {
//        super.init()
//        defer {
//            currentColor = ""
//            labelLevel = 5
//            detailLevel = 0
//        }
//    }
//    
//    @objc open override var mapStyle: MFTMapTheme {
//        get {
//            return .grayScale
//        }
//    }
//    
//    @objc open override var styleSheetFileName: String {
//        get {
//            return "mapfit-grayscale"
//        }
//    }
//    
//    @objc open override var styleSheetRoot: String {
//        get {
//            return "mapfit-grayscale/"
//        }
//    }
//    
//    @objc override open var availableLabelLevels: Int {
//        get {
//            return 12
//        }
//    }
//    
//    @objc override open var yamlString: String {
//        get {
//            return "\(styleSheetRoot)themes/label-\(labelLevel).yaml"
//        }
//    }
//}
//




