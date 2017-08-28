//
//  DateExtension.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/11/16.
//  Copyright © 2016 wph. All rights reserved.
//

extension Date {
    //.dateByAddingTimeInterval(1 * 24 * 3600)
    static func dateByOffsetDay(_ date:Date?,offsetDay:Int) -> Date {
        var originDate = date
        if date == nil {
            originDate = Date()
        }
        return originDate!.addingTimeInterval(Double(offsetDay) * 24 * 3600)
    }
    
    static func dateByOffsetMonth(_ date:Date?,offsetDay:Int) -> Date {
        var originDate = date
        if date == nil {
            originDate = Date()
        }
        return originDate!.addingTimeInterval(Double(offsetDay) * 30 * 24 * 3600)
    }
    
    static func dateByOffsetYear(_ date:Date?,offsetDay:Int) -> Date {
        var originDate = date
        if date == nil {
            originDate = Date()
        }
        return originDate!.addingTimeInterval(Double(offsetDay) * 365 * 24 * 3600)
    }
    
    static func dateWithStandardFormatString(_ dateString:String?) -> Date {
        if dateString == nil {
            return Date()
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.date(from: dateString!)!
    }
    
    static func dateFullStringWithStandardFormat(_ date:Date?) -> String {
        var originDate = date
        if date == nil {
            originDate = Date()
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: originDate!)
    }
    
    static func dateDayStringWithStandardFormat(_ date:Date?) -> String {
        var originDate = date
        if date == nil {
            originDate = Date()
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: originDate!)
    }
    
    static func yearMonthStringWithStandardFormat(_ date:Date?) -> String {
        var originDate = date
        if date == nil {
            originDate = Date()
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter.string(from: originDate!)
    }
    
    static func yearStringWithStandardFormat(_ date:Date?) -> String {
        var originDate = date
        if date == nil {
            originDate = Date()
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: originDate!)
    }
    
    static func monthDayStringWithStandardFormat(_ date:Date?) -> String {
        var originDate = date
        if date == nil {
            originDate = Date()
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        return formatter.string(from: originDate!)
    }
    
    static func monthCnStringWithStandardFormat(_ date:Date?) -> String {
        var originDate = date
        if date == nil {
            originDate = Date()
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月"
        return formatter.string(from: originDate!)
    }
    
    static func yearMonthCnStringWithStandardFormat(_ date:Date?) -> String {
        var originDate = date
        if date == nil {
            originDate = Date()
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        return formatter.string(from: originDate!)
    }
    
}
