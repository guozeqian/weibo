//
//  StatusTableViewBottomView.swift
//  weibo
//
//  Created by guozeqian on 16/5/16.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit

class StatusTableViewBottomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化UI
        setupUI()
    }
    
    
    private func setupUI()
    {
        // 1.添加子控件
        addSubview(retweetBtn)
        addSubview(unlikeBtn)
        addSubview(commonBtn)
        
        // 2.布局子控件
        xmg_HorizontalTile([retweetBtn, unlikeBtn, commonBtn], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    // MARK: - 懒加载
    // 转发
    private lazy var retweetBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "timeline_icon_retweet"), forState: UIControlState.Normal)
        btn.setTitle("转发", forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(10)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return btn
    }()
    
    // 赞
    private lazy var unlikeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "timeline_icon_unlike"), forState: UIControlState.Normal)
        btn.setTitle("赞", forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(10)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return btn
    }()
    
    // 评论
    private lazy var commonBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "timeline_icon_comment"), forState: UIControlState.Normal)
        btn.setTitle("评论", forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(10)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}