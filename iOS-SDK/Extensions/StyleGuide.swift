//
//  StyleGuide.swift
//  iOS.SDK
//
//  Created by Zain N. on 12/7/17.
//  Copyright © 2017 Mapfit. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    public convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    // .withAlphaComponent to add alpha
    public convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    public struct StyleGuide {
        
        //MARK: - Colors
        public static let highlight_purple     = UIColor(netHex: 0x9935e2)
        public static let highlight_pink       = UIColor(netHex: 0xdc2678)
        public static let highlight_red        = UIColor(netHex: 0xf54b59)
        public static let highlight_orange     = UIColor(netHex: 0xf77b40)
        public static let highlight_yellow     = UIColor(netHex: 0xffdc45)
        public static let highlight_green      = UIColor(netHex: 0x33e384)
        public static let highlight_teal       = UIColor(netHex: 0x2ccab9)
        public static let highlight_green_blue = UIColor(netHex: 0x00b289)
        public static let highlight_light_blue = UIColor(netHex: 0x009eff)
        public static let highlight_mid_blue   = UIColor(netHex: 0x0685e3)
        public static let highlight_blue       = UIColor(netHex: 0x0955ec)
        public static let highlight_violet     = UIColor(netHex: 0x0020d4)
        
        public static let context_orange       = UIColor(netHex: 0xf18d57)
        public static let context_pink         = UIColor(netHex: 0xe95f9d)
        public static let context_blue         = UIColor(netHex: 0x2498e7)
        public static let context_violet       = UIColor(netHex: 0x2846cc)
        public static let context_dark_violet  = UIColor(netHex: 0x18379e)
        public static let context_green        = UIColor(netHex: 0x2bbfa5)
        
        public static let neutral_light5       = UIColor(netHex: 0xbed7e7) //blue
        public static let neutral_light4       = UIColor(netHex: 0xc9e2f2)
        public static let neutral_light3       = UIColor(netHex: 0xd8edfe)
        public static let neutral_light2       = UIColor(netHex: 0xe3f1fc)
        public static let neutral_light1       = UIColor(netHex: 0xebf5fe)
        
        public static let someLighterBlueColorNotInTheStyleGuide       = UIColor(netHex: 0xF7FBFF)
        public static let someLighterBlueColorForTextAlsoNotInStyleGuide       = UIColor(netHex: 0xb5d1e3)
        
        public static let neutral_dark3        = UIColor(netHex: 0x124364)
        public static let neutral_dark2        = UIColor(netHex: 0x3f526d)
        public static let neutral_dark1        = UIColor(netHex: 0x39627c)
        public static let neutral_mid1         = UIColor(netHex: 0x7e9fb5)
        public static let neutral_mid2         = UIColor(netHex: 0x6a7f93)
        public static let neutral_mid3         = UIColor(netHex: 0x4a7591)
        public static let neutral_text_dark    = UIColor(netHex: 0x2f4352)
        
        public static let white                = UIColor(netHex: 0xffffff)
        public static let unselected_grey      = UIColor(netHex: 0xb3b9bd)
        
    }
}
