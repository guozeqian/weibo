//
//  UIBarButtonItem+Category.swift
//  weibo
//
//  Created by guozeqian on 16/4/26.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    class func createButtonItem(imageName:String,targent:AnyObject?,action:Selector) ->UIBarButtonItem{
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(targent, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        btn.sizeToFit()
        return UIBarButtonItem(customView: btn)
        
    }

}
