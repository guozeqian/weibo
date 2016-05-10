//
//  Status.swift
//  weibo
//
//  Created by guozeqian on 16/5/10.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit

class Status: NSObject {

    var created_at:String?
    var id:Int = 0
    var text:String?
    var source:String?
    var pic_urls:[[String: AnyObject]]?
    var user: User?
    
    
    class func loadStatuses(finished:(models:[Status]?,error:NSError?) -> ()){
        let path = "2/statuses/home_timeline.json"
        let params = ["access_token": UserAccount.loadAccount()!.access_token!]
        
        NetworkTools.shareNetworkTools().GET(path, parameters: params, success: { (_, JSON) -> Void in
            let models = dict2Model(JSON!["statuses"] as! [[String:AnyObject]])
            finished(models: models, error: nil)
            
            }) { (_, error) -> Void in
                finished(models: nil, error: error)
                
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
            
        }else{
            super.setValue(value, forKey: key)
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    var properites = [""]
    override  var description:String {
        let dict = dictionaryWithValuesForKeys(properites)
        return "\(dict)"
    }
    
}
