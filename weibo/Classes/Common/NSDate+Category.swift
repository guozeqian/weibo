//
//  NSDate+Category.swift
//  weibo
//
//  Created by guozeqian on 16/5/12.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit
extension NSDate{
    
    class func dateWithStr(time:String) -> NSDate{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EE MMM d HH:mm:ss Z yyyy"
        formatter.locale = NSLocale(localeIdentifier: "en")
        let createDate = formatter.dateFromString(time)
        return createDate!
    }
    
    
    var descDate:String{
        let calendar = NSCalendar.currentCalendar()
        
        if calendar.isDateInToday(self){
            let since = Int(NSDate().timeIntervalSinceDate(self))
            if since < 60
            {
                return "刚刚"
            }
            if since < 60 * 60 {
                return "\(since / (60))分钟前"
            }
            return "\(since / (60 * 60))小时前"
        }
        var formatterStr = "HH:mm"
        if calendar.isDateInYesterday(self)
        {
            return "昨天：" + formatterStr
        }
        else{
            // 3.处理一年以内
            formatterStr = "MM-dd " + formatterStr
            
            // 4.处理更早时间
            let comps = calendar.components(NSCalendarUnit.Year, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
            if comps.year >= 1
            {
                formatterStr = "yyyy-" + formatterStr
            }
        }
        
        // 5.按照指定的格式将时间转换为字符串
        // 5.1.创建formatter
        let formatter = NSDateFormatter()
        // 5.2.设置时间的格式
        formatter.dateFormat = formatterStr
        // 5.3设置时间的区域(真机必须设置, 否则可能不能转换成功)
        formatter.locale = NSLocale(localeIdentifier: "en")
        // 5.4格式化
        
        return formatter.stringFromDate(self)
    }
    
}
