//
//  Date + Ext.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/14/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import Foundation

extension Date {
    func StringDateFormatter() -> String {
        return DateFormatter.StringDateFormatter.string(from: self)
    }
    
    func MonthDayDateFormatter() -> String {
        return DateFormatter.MonthDayDateFormatter.string(from: self)
    }
}

// Formatter for Short-Style Date E.G. 10/11/2016 3:11 P.M
extension DateFormatter {
    fileprivate static let StringDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}

extension DateFormatter {
    fileprivate static let MonthDayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter
    }()
}

// Formatter for Month and Year E.G. October 2016
extension Date {
    func MonthYearDateFormatter() -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.month , .year], from: self)
        let formatter = DateFormatter()
        return "\(formatter.monthSymbols[components.month! - 1]) \(components.year!)"
    }
}
