//
//  Date + Ext.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/14/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import Foundation

extension Date {
    func shortDateFormatter() -> String {
        return DateFormatter.shortDateFormatter.string(from: self)
    }
    
    func longDateFormatter() -> String {
        return DateFormatter.longDateFormatter.string(from: self)
    }
    
    func weekdayDateFormatter() -> String {
        return DateFormatter.weekdayDateFormatter.string(from: self)
    }
}

// Formatter for Short-Style Date E.G. 10/11/2016 3:11 P.M
extension DateFormatter {
    
    //Short Date Formatter - 10/11/12
    fileprivate static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    //Long Date Formatter - December 12, 2016
    fileprivate static let longDateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    fileprivate static let weekdayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
}

