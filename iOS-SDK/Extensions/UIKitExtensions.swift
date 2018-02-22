//
//  UIColorExtension.swift
//  iOS.SDK
//
//  Created by Zain N. on 12/5/17.
//  Copyright © 2017 Mapfit. All rights reserved.
//

import UIKit
import CoreGraphics

internal extension UIColor {
    func hexValue() -> String {
        var r: CGFloat = 1
        var g: CGFloat = 1
        var b: CGFloat = 1
        var a: CGFloat = 1
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let red = Float(r * 255)
        let green = Float(g * 255)
        let blue = Float(b * 255)
        let alpha = Float(a * 255)
        return String.init(format: "#%02lX%02lX%02lX%02lX", lroundf(alpha), lroundf(red), lroundf(green), lroundf(blue))
    }
}

public extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
}

internal extension UIViewController {
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    

    
}

internal extension UIView {
    
    func updateConstraint(attribute: NSLayoutAttribute, constant: CGFloat) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = constant
            self.layoutIfNeeded()
        }
    }
}


