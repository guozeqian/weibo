//
//  WelcomeViewController.swift
//  weibo
//
//  Created by guozeqian on 16/5/7.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    // 懒加载
    private lazy var bgIV:UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    
    private lazy var iconView:UIImageView = {
       let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var messageLabel:UILabel = {
        let label = UILabel()
        label.text = "欢迎回来"
        label.sizeToFit()
        label.alpha = 0.0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(bgIV)
        view.addSubview(iconView)
        view.addSubview(messageLabel)
        
        bgIV.xmg_Fill(view)
        
        let cons = iconView.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: view, size: CGSize(width: 100, height: 100),offset: CGPoint(x: 0, y: -150))
        
        
        
        
    }

    
    

}
