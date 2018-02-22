//
//  MFTPlaceInfoAdapter.swift
//  iOS.SDK
//
//  Created by Zain N. on 2/2/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import Foundation
import UIKit

public protocol MFTPlaceInfoAdapter {
    
    /**
     * Called when a place info will be shown after a marker click.
     *
     * @param marker The marker the user clicked on.
     * @return View to be shown as a place info. If null is returned the default
     * info window will be shown.
     */
    func getMFTPlaceInfoView(marker: MFTMarker)-> UIView
}


