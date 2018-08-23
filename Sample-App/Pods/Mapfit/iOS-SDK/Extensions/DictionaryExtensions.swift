//
//  DictionaryExtensions.swift
//  iOS.SDK
//
//  Created by Zain N. on 12/5/17.
//  Copyright © 2017 Mapfit. All rights reserved.
//

import Foundation

internal extension Dictionary where Value: Equatable {
    
    /* Use when keys/values are not 1:1 */
    internal func keysForValue(value: Value) -> [Key] {
        return flatMap { (key: Key, val: Value) -> Key? in
            value == val ? key : nil
        }
    }
    
    /* Use when keys/values are 1:1*/
    internal func keyForValue(value: Value) -> Key? {
        let results = keysForValue(value: value)
        guard !results.isEmpty else { return nil }
        return results.first
    }
}

