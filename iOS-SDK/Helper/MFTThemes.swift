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
    case day = "https://cdn.mapfit.com/v3-0/themes/mapfit-day.yaml"
    case night = "https://cdn.mapfit.com/v3-0/themes/mapfit-night.yaml"
    case grayScale = "https://cdn.mapfit.com/v3-0/themes/mapfit-grayscale.yaml"
    case custom = ""
}


internal enum GlobalStyleVars : String {
    case transitOverlay = "global.sdk_transit_overlay"
    case bikeOverlay = "global.sdk_bike_overlay"
    case pathOverlay = "global.sdk_path_overlay"
    case apiKey = "global.sdk_mapfit_api_key"
    case uxLanguage = "global.ux_language"
}




