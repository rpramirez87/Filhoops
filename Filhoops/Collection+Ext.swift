//
//  Collection+Ext.swift
//  Filhoops
//
//  Created by Ron Ramirez on 11/29/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import Foundation

extension Array where Element: Integer {
    /// Returns the sum of all elements in the array
    var total: Element {
        return reduce(0, +)
    }
}
extension Collection where Iterator.Element == Int, Index == Int {
    /// Returns the average of all elements in the array
    var average: Int {
        return isEmpty ? 0 : Int(reduce(0, +)) / Int(endIndex-startIndex)
    }
}
