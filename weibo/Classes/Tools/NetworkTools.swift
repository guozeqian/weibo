//
//  NetworkTools.swift
//  weibo
//
//  Created by guozeqian on 16/5/2.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkTools: AFHTTPSessionManager {

    static let tools:NetworkTools = {
        let url = NSURL(string: "https://api.weibo.com/")
        let t = NetworkTools(baseURL: url)
        
        t.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as! Set<String>
        return t
    }()
    
    
    /**
     获取单例
     
     - returns: 返回单利对象
     */
    class func shareNetworkTools() -> NetworkTools{
        return tools
    }
}
