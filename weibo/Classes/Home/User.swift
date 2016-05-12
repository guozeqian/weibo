//
//  User.swift
//  weibo
//
//  Created by guozeqian on 16/5/10.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit

class User: NSObject {

    var id: Int = 0
    var name:String?
    var profile_image_url:String?
    var verified:Bool = false
    var verified_type:Int = -1{
        didSet{
            switch verified_type{
            case 0:
                verifiedImage = UIImage(named: "avatar_vip")
            case 2,3,5:
                verifiedImage = UIImage(named: "avatar_enterprise_vip")
            case 220:
                verifiedImage = UIImage(named: "avatar_grassroot")
            default:
                verifiedImage = nil
            }
        }
    }
    
    var verifiedImage:UIImage?
    
    var mbrank:Int = 0
        {
        didSet{
            if mbrank > 0 && mbrank < 7{
                mbrankImage = UIImage(named: "common_icon_membership_level\(mbrank)")
            }
        }
    }
    
    var mbrankImage:UIImage?
    
    init(dict:[String:AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    var properties = ["id", "name", "profile_image_url", "verified", "verified_type"]
    override var description: String {
        let dict = dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }

}
