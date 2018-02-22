//
//  APPLFrameworkExtentions.swift
//  iOS.SDK
//
//  Created by Zain N. on 12/5/17.
//  Copyright © 2017 Mapfit. All rights reserved.
//

import UIKit

protocol ApplicationProtocol {
    func openURL(_ url: URL) -> Bool
}

extension UIApplication: ApplicationProtocol {}

protocol NotificationCenterProtocol {
    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?)
    func removeObserver(_ observer: Any)
}

extension NotificationCenter: NotificationCenterProtocol {}
