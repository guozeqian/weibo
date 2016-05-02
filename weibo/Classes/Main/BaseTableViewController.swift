//
//  BaseTableViewController.swift
//  weibo
//
//  Created by guozeqian on 16/4/25.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController,VisitorViewDeletage {

    
    var userLogin = UserAccount.userLogin()
    
    var visitorView:VisitorView?
    
    override func viewDidLoad() {
        
        userLogin ? super.loadView() : setupVisitorView()
        
    }

    private func setupVisitorView(){
        let customView = VisitorView()
        //customView.backgroundColor = UIColor.redColor()
        customView.deletage = self
        visitorView = customView
        view = customView
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "registerButtonWillClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "loginButtonWillClick")
        
    }
    func loginButtonWillClick() {
        let oauthVC = OAuthViewController()
        let nav = UINavigationController(rootViewController: oauthVC)
        presentViewController(nav, animated: true , completion: nil)
    }
    func registerButtonWillClick() {
        print(#function)
    }
   
}
