//
//  UIColor+Category.swift
//  weibo
//
//  Created by guozeqian on 16/5/19.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit

extension UIColor{
    
    class func randomColor() -> UIColor {
        return UIColor(red: randomNumber(), green: randomNumber(), blue: randomNumber() , alpha: 1.0)
    }
    
    class func randomNumber() -> CGFloat {
        // 0 ~ 255
        return CGFloat(arc4random_uniform(256)) / CGFloat(255)
    }
    
    
}
