//
//  BundleExtension.swift
//  iOS.SDK
//
//  Created by Zain N. on 12/5/17.
//  Copyright © 2017 Mapfit. All rights reserved.
//

import Foundation

public extension Bundle {
    internal static func mapfitBundle() -> Bundle {
        return Bundle.init(for: MFTMapView.self)
    }
    
    public static func houseStylesBundle() -> Bundle? {
        guard let styleBundleUrl = Bundle.mapfitBundle().url(forResource: "houseStyles", withExtension: "bundle") else {
            return nil
        }
        return Bundle.init(url: styleBundleUrl)
    }
}
