//
//  DateExtension.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/11/16.
//  Copyright © 2016 wph. All rights reserved.
//

extension NSDate {
    //.dateByAddingTimeInterval(1 * 24 * 3600)
    static func dateByOffsetDay(date:NSDate?,offsetDay:Int) -> NSDate {
        var originDate = date
        if date == nil {
            originDate = NSDate()
        }
        return originDate!.dateByAddingTimeInterval(Double(offsetDay) * 24 * 3600)
    }
    
    static func dateByOffsetMonth(date:NSDate?,offsetDay:Int) -> NSDate {
        var originDate = date
        if date == nil {
            originDate = NSDate()
        }
        return originDate!.dateByAddingTimeInterval(Double(offsetDay) * 30 * 24 * 3600)
    }
    
    static func dateWithStandardFormatString(dateString:String?) -> NSDate {
        if dateString == nil {
            return NSDate()
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.dateFromString(dateString!)!
    }
    
    static func dateFullStringWithStandardFormat(date:NSDate?) -> String {
        var originDate = date
        if date == nil {
            originDate = NSDate()
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.stringFromDate(originDate!)
    }
    
    static func dateDayStringWithStandardFormat(date:NSDate?) -> String {
        var originDate = date
        if date == nil {
            originDate = NSDate()
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.stringFromDate(originDate!)
    }
    
    static func yearMonthStringWithStandardFormat(date:NSDate?) -> String {
        var originDate = date
        if date == nil {
            originDate = NSDate()
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter.stringFromDate(originDate!)
    }
    
    static func yearStringWithStandardFormat(date:NSDate?) -> String {
        var originDate = date
        if date == nil {
            originDate = NSDate()
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.stringFromDate(originDate!)
    }
    
    static func monthDayStringWithStandardFormat(date:NSDate?) -> String {
        var originDate = date
        if date == nil {
            originDate = NSDate()
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM-dd"
        return formatter.stringFromDate(originDate!)
    }
    
    static func monthCnStringWithStandardFormat(date:NSDate?) -> String {
        var originDate = date
        if date == nil {
            originDate = NSDate()
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM月"
        return formatter.stringFromDate(originDate!)
    }
    
    static func yearMonthCnStringWithStandardFormat(date:NSDate?) -> String {
        var originDate = date
        if date == nil {
            originDate = NSDate()
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        return formatter.stringFromDate(originDate!)
    }
    
}
