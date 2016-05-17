//
//  Status.swift
//  weibo
//
//  Created by guozeqian on 16/5/10.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit
import SDWebImage

class Status: NSObject {

    var created_at:String?{
        didSet{
            let createDate = NSDate.dateWithStr(created_at!)
            created_at = createDate.descDate
        }
    }
    var id:Int = 0
    var text:String?
    var source:String?{
        didSet{
            if let str = source{
                if str.containsString(">") && str.containsString("<"){
                    let startLocation = (str as NSString).rangeOfString(">").location + 1
                    let length = (str as NSString).rangeOfString("<",options: NSStringCompareOptions.BackwardsSearch).location - startLocation
                    source = "来自: " + (str as NSString).substringWithRange(NSRange(location: startLocation,length: length))
                }
            }
        }
    }
    
    
    var pic_urls:[[String: AnyObject]]?
        {
        didSet{
            storedPicURLS = [NSURL]()
            for dict in pic_urls! {
                if let urlStr = dict["thumbnail_pic"]{
                    storedPicURLS?.append(NSURL(string:urlStr as! String)!)
                }
            }
        }
    }
    
    var storedPicURLS:[NSURL]?
    var user: User?
    /// 转发微博
    var retweeted_status: Status?
    
    // 如果有转发, 原创就没有配图
    /// 定义一个计算属性, 用于返回原创获取转发配图的URL数组
    var pictureURLS:[NSURL]?
        {
            return retweeted_status != nil ? retweeted_status?.storedPicURLS : storedPicURLS
    }
    
     ///加载微博数据
    class func loadStatuses(since_id:Int, max_id: Int, finished:(models:[Status]?,error:NSError?) -> ()){
        let path = "2/statuses/home_timeline.json"
        var params = ["access_token": UserAccount.loadAccount()!.access_token!]
        if since_id > 0{
            params["since_id"] = "\(since_id)"
        }
        if max_id > 0
        {
            params["max_id"] = "\(max_id)"
        }
        NetworkTools.shareNetworkTools().GET(path, parameters: params, success: { (_, JSON) -> Void in
            let models = dict2Model(JSON!["statuses"] as! [[String:AnyObject]])
            //finished(models: models, error: nil)
            // 3.缓存微博配图
            cacheStatusImages(models, finished: finished)
            }) { (_, error) -> Void in
                finished(models: nil, error: error)
                
        }
    }
    
    /// 缓存配图
    class func cacheStatusImages(list: [Status], finished: (models:[Status]?, error:NSError?)->()) {
        
        if list.count == 0
        {
            finished(models: list, error: nil)
        }
        
        // 1.创建一个组
        let group = dispatch_group_create()
        
        // 1.缓存图片
        for status in list
        {
            // 1.1判断当前微博是否有配图, 如果没有就直接跳过
            //            if status.storedPicURLS == nil{
            //                continue
            //            }
            // Swift2.0新语法, 如果条件为nil, 那么就会执行else后面的语句
            //            status.storedPicURLS = nil
            guard let urls = status.storedPicURLS else
            {
                continue
            }
            
            for url in status.storedPicURLS!
            {
                // 将当前的下载操作添加到组中
                dispatch_group_enter(group)
                
                // 缓存图片
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (_, _, _, _, _) -> Void in
                    
                    // 离开当前组
                    dispatch_group_leave(group)
                })
            }
        }
        
        // 2.当所有图片都下载完毕再通过闭包通知调用者
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            // 能够来到这个地方, 一定是所有图片都下载完毕
            finished(models: list, error: nil)
        }
    }

    
    class func dict2Model(list:[[String: AnyObject]]) -> [Status] {
        var models = [Status]()
        for dict in list {
            models.append(Status(dict:dict))
        }
        return models
    }
    
    init(dict: [String:AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if "user" == key{
            user = User(dict: value as! [String : AnyObject])
            return
        }
       // 2.判断是否是转发微博, 如果是就自己处理
        if "retweeted_status" == key
        {
            retweeted_status = Status(dict: value as! [String : AnyObject])
            return
        }
        
        super.setValue(value, forKey: key)
        
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    var properites = [""]
    override  var description:String {
        let dict = dictionaryWithValuesForKeys(properites)
        return "\(dict)"
    }
    
}
