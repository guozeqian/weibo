//
//  VisitorView.swift
//  weibo
//
//  Created by guozeqian on 16/4/25.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit
protocol VisitorViewDeletage{
    func loginButtonWillClick()
    func registerButtonWillClick()
}

class VisitorView: UIView {
    var deletage:VisitorViewDeletage?
    func loginButtonClick(){
       deletage?.loginButtonWillClick()
    }
    func registerButtonClick(){
        deletage?.registerButtonWillClick()
    }

    /**
     设置是否为首页
     
     - parameter isHome:    是否为首页
     - parameter imageName: 图片名称
     - parameter message:   文字
     */
    func setupVisitorInfo(isHome:Bool,imageName:String,message:String){
        iconView.hidden = !isHome
        homeIcon.image = UIImage(named: imageName)
        messageLabel.text = message
        if isHome{
            startAnimation()
        }
    }
    /**
     开启旋转动画
     */
    private func startAnimation(){
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.duration = 20
        anim.repeatCount = MAXFLOAT
        
        //设置动画不被移除
        anim.removedOnCompletion = false
        iconView.layer.addAnimation(anim, forKey: nil)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //添加子控件
        addSubview(iconView)
        addSubview(maskBGView)
        addSubview(homeIcon)
        addSubview(messageLabel)
        addSubview(loginButton)
        addSubview(registerButton)
        
        //添加子控件约束
        //居中
        iconView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        homeIcon.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        messageLabel.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: iconView, size: nil)
        // "哪个控件" 的 "什么属性" "等于" "另外一个控件" 的 "什么属性" 乘以 "多少" 加上 "多少"
        let widthCons = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224)
        addConstraint(widthCons)
        registerButton.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: messageLabel, size: CGSize(width: 100, height: 30), offset: CGPoint(x: 0, y: 20))
        loginButton.xmg_AlignVertical(type: XMG_AlignType.BottomRight, referView: messageLabel, size: CGSize(width: 100, height: 30), offset: CGPoint(x: 0, y: 20))
        // 2.5设置蒙版
        maskBGView.xmg_Fill(self)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /**
    *  懒加载控件
    */
    /// 转盘
    private lazy var iconView:UIImageView = {
       let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return iv
    }()
    /// 图标
    private lazy var homeIcon:UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return iv
    }()
    /// 文本
    private lazy var messageLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.darkGrayColor()
        label.text = "萧萧秋风起，悠悠行万里，万里何所行，横漠筑长城。"
        return label
    }()
    /// 登录按钮
    private lazy var loginButton:UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.setTitle("登录", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "loginButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    /// 注册按钮
    private lazy var registerButton:UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.setTitle("注册", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "registerButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    /// 挡布
    private lazy var maskBGView:UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return iv
    }()

    
}
