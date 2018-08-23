//
//  MFTPlaceInfo.swift
//  iOS.SDK
//
//  Created by Zain N. on 2/2/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import Foundation
import UIKit

internal class MFTPlaceInfo {
    internal var infoView: UIView
    internal var marker: MFTMarker

    init(view: UIView, marker: MFTMarker) {
        self.infoView = view
        self.marker = marker
    }

}
