//
//  UserAccount.swift
//  weibo
//
//  Created by guozeqian on 16/5/2.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit
/// 
class UserAccount: NSObject,NSCoding {

    var access_token: String?
    var expires_in: NSNumber?{
        didSet{
            expires_Date = NSDate(timeIntervalSinceNow: expires_in!.doubleValue)
            print(expires_Date)
        }
    }
    var uid: String?
    var expires_Date:NSDate?
    /// 用户头像地址（大图），180×180像素
    var avatar_large: String?
    /// 用户昵称
    var screen_name: String?

    override init() {
        
    }
    
    init(dict:[String:AnyObject]) {
        super.init()
//        access_token = dict["access_token"] as? String
//        expires_in = dict["expires_in"] as? NSNumber
//        uid = dict["uid"] as? String
       setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
//        print(key)
    }
    
    
    override var description: String {
        let properties = ["access_token","expires_in","uid"]
        let dict = self.dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }
    
    func saveAccount(){
        NSKeyedArchiver.archiveRootObject(self, toFile: "account.plist".cacheDir())
    }
    
    func loadUserInfo(finished:(account:UserAccount?,error:NSError?)->()){
        assert(access_token != nil, "没有授权")
        let path = "2/users/show.json"
        let params = ["access_token":access_token!, "uid":uid!]
        NetworkTools.shareNetworkTools().GET(path, parameters: params, success: { (_, JSON) in
            if let dict = JSON as? [String:AnyObject]
            {
                self.screen_name = dict["screen_name"] as? String
                self.avatar_large = dict["avatar_large"] as? String
                finished(account: self, error: nil)
                return
            }
            finished(account: nil, error: nil)
            }) { (_, error) in
                finished(account: nil, error: error)
        }
    }
    
    
    /**
     返回用户是否登录
     */
    class func userLogin() -> Bool
    {
        return UserAccount.loadAccount() != nil
    }
    
    static var account: UserAccount?
    /**
     加载授权模块
     
     - returns: account
     */
    class func loadAccount() -> UserAccount?{
        if account != nil
        {
            return account
        }
        
         account = NSKeyedUnarchiver.unarchiveObjectWithFile("account.plist".cacheDir()) as? UserAccount
        if account?.expires_Date?.compare(NSDate()) == NSComparisonResult.OrderedAscending{
            return nil
        }
        
        return account
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    required init?(coder aDecoder: NSCoder){
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate
        screen_name = aDecoder.decodeObjectForKey("screen_name")  as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large")  as? String
    }

}
