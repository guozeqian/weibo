//
//  HomeRefreshView.swift
//  weibo
//
//  Created by guozeqian on 16/5/18.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit

class HomeRefreshView: UIView {

    
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var loadingView: UIImageView!
    
    
    /**
     旋转箭头
     */
    func rotaionArrowIcon(flag: Bool)
    {
        var angle = M_PI
        angle += flag ? -0.01 : 0.01
        UIView.animateWithDuration(0.2) { () -> Void in
            self.arrowIcon.transform = CGAffineTransformRotate(self.arrowIcon.transform, CGFloat(angle))
        }
    }
    
    /**
     开始圈圈动画
     */
    func startLoadingViewAnim()
    {
        tipView.hidden = true
        
        // 1.创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        // 2.设置动画属性
        anim.toValue = 2 * M_PI
        anim.duration = 1
        anim.repeatCount = MAXFLOAT
        
        // 该属性默认为YES, 代表动画只要执行完毕就移除
        anim.removedOnCompletion = false
        // 3.将动画添加到图层上
        loadingView.layer.addAnimation(anim, forKey: nil)
    }
    /**
     停止圈圈动画
     */
    func stopLoadingViewAnim()
    {
        tipView.hidden = false
        
        loadingView.layer.removeAllAnimations()
    }
    
    class func refreshView() -> HomeRefreshView{
        return NSBundle.mainBundle().loadNibNamed("HomeRefreshView", owner: nil, options: nil).last as! HomeRefreshView
    }
    
}

class HomeRefreshControl: UIRefreshControl {
    
    override init() {
       super.init()
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI()
    {
        addSubview(refreshView)
        
        // 2.布局子控件
        refreshView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: CGSize(width: 170, height: 60))
        
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
        
    }
    private var rotationArrowFlag = false
    private var loadingViewAnimFlag = false
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if frame .origin.y >= 0
        {
            return
        }
        // 判断是否已经触发刷新事件
        if refreshing && !loadingViewAnimFlag
        {
            print("圈圈动画")
            loadingViewAnimFlag = true
            // 显示圈圈, 并且让圈圈执行动画
            refreshView.startLoadingViewAnim()
            return
        }

        if refreshing && !loadingViewAnimFlag
        {
            print("圈圈动画")
            loadingViewAnimFlag = true
            refreshView.rotaionArrowIcon(rotationArrowFlag)
        }else if frame.origin.y < -50 && !rotationArrowFlag
        {
            print("翻转")
            rotationArrowFlag = true
            refreshView.rotaionArrowIcon(rotationArrowFlag)
        }
    }
   
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.stopLoadingViewAnim()
        loadingViewAnimFlag = false
    }
    
    deinit
    {
        removeObserver(self, forKeyPath: "frame")
    }

    private lazy var refreshView:HomeRefreshView = HomeRefreshView.refreshView()
    
    
}
