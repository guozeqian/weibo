//
//  PopoverPresentationController.swift
//  weibo
//
//  Created by guozeqian on 16/4/27.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit

class PopoverPresentationController: UIPresentationController {

    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    
    /**
     即将布局转场子视图时调用
     */
    override func containerViewWillLayoutSubviews() {
        presentedView()?.frame = CGRect(x: 100, y: 56, width: 200, height: 200)
        containerView?.insertSubview(coverView, atIndex: 0)
        
    }
    
    private lazy var coverView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.frame = UIScreen.mainScreen().bounds
        
        //添加监听
        let tap = UITapGestureRecognizer(target: self, action: "close")
        view.addGestureRecognizer(tap)
        return view
    }()

    func close(){
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
