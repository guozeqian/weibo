//
//  UILabel+Category.swift
//  weibo
//
//  Created by guozeqian on 16/5/12.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit
extension UILabel{
    class func createLabel(color:UIColor,fontSize:CGFloat) -> UILabel{
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFontOfSize(fontSize)
        return label
    }
}
