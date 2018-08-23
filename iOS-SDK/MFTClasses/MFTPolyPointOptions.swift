//
//  MFTPolyPointOptions.swift
//  Mapfit
//
//  Created by Zain N. on 5/18/18.
//

import Foundation
import CoreLocation

public protocol MFTPolyPointOptions {
    func setStrokeWidth(_ width: Int)
    func setOutlineWidth(_ width: Int)
    func setStrokeColor(_ color: String)
    func setStrokeOutlineColor(_ color: String)
    func setDrawOrder(_ order: Int)
    func setLineCapType(_ type: MFTLineCapType)
    func setLineJoinType(_ type: MFTLineJoinType)
    func addPoints(_ points: [[CLLocationCoordinate2D]])
}
