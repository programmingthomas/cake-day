//
//  NSDateExtensions.swift
//  Cake Day
//
//  Created by Thomas Denney on 07/12/2014.
//  Copyright (c) 2014 Thomas Denney. All rights reserved.
//

import Foundation

extension NSDate {
    func nextDate() -> NSDate {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        var cakeday = self
        let today = NSDate()
        
        //Offset that is added each time
        let offset = NSDateComponents()
        offset.year = 1;
        
        while cakeday.compare(today) != NSComparisonResult.OrderedDescending {
            cakeday = calendar.dateByAddingComponents(offset, toDate: cakeday, options: NSCalendarOptions.allZeros)!
        }
        
        return cakeday
    }
    
    func compareOrderInYear(date2: NSDate) -> NSComparisonResult {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let calendarUnits = NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit
        
        let components1 = calendar.components(calendarUnits, fromDate: self)
        let components2 = calendar.components(calendarUnits, fromDate: date2)
        
        if (components1.month < components2.month) {
            return NSComparisonResult.OrderedAscending
        }
        else if (components1.month > components2.month) {
            return NSComparisonResult.OrderedDescending
        }
        else if (components1.day < components2.day) {
            return NSComparisonResult.OrderedAscending
        }
        else if (components1.day > components2.day) {
            return NSComparisonResult.OrderedDescending
        }
        
        return NSComparisonResult.OrderedSame
    }
}
