//
//  Date+String.swift
//  Call Logger
//
//  Created by Phil Scarfi on 6/1/17.
//  Copyright © 2017 Pioneer Mobile Applications. All rights reserved.
//

import Foundation

public extension Date {
    func showInFormat(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
    
    func formattedDurationToDate(toDate: Date) -> String? {
        let interval = toDate.timeIntervalSince(self)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: interval)
    }
    
    func dateAndTime() -> String {
        return showInFormat(format: "E, MMM d h:mm a")
    }
    
    func shortDateAndTime() -> String {
        return showInFormat(format: "MM/d HH:mm")
    }
    
    func simpleStringFromDate() -> String {
        if NSCalendar.current.isDateInToday(self) {
            return showInFormat(format: "h:mm a")
        }
        if NSCalendar.current.component(.year, from: self) == NSCalendar.current.component(.year, from: Date()) {
            return showInFormat(format: "E, MMM d")
        }
        return showInFormat(format: "MMM d, yyyy")
    }
    
    func smartStringFromDate() -> String {
        let timeSinceNow = Date().timeIntervalSince(self)
        let timeSinceInMinutes = timeSinceNow / 60
        if timeSinceInMinutes < 61 {
            if timeSinceInMinutes < 60 {
                return "\(Int(timeSinceInMinutes)) \(Int(timeSinceInMinutes) == 1 ? "min" : "mins") ago"
            } else {
                let hoursAgo = timeSinceInMinutes / 60
                return "\(Int(hoursAgo)) \(Int(hoursAgo) == 1 ? "hour" : "hours") ago"
            }
        } else {
            if timeSinceInMinutes < (24 * 60) {
                if NSCalendar.current.isDateInYesterday(self) {
                    return "Yesterday at \(showInFormat(format: "h:mm a"))"
                }
                return showInFormat(format: "h:mm a")
            } else if timeSinceInMinutes < (48 * 60) {
                return "Yesterday at \(showInFormat(format: "h:mm a"))"
            } else if timeSinceInMinutes < (24 * 7 * 60) {
                return showInFormat(format: "E, MMM d h:mm a")
            } else {
                return showInFormat(format: "MMM d")
            }
        }
    }
}
