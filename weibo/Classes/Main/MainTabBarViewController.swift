//
//  MainTabBarViewController.swift
//  weibo
//
//  Created by guozeqian on 16/4/23.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.orangeColor()
        
        addChildViewControllers()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupComposeBtn()
    }
    
    func composeBtnClick(){
        print("composeBtnClick")
    }
    

    private func setupComposeBtn()
    {
        // 1.添加加号按钮
        tabBar.addSubview(composeBtn)
        
        // 2.调整加号按钮的位置
        let width = UIScreen.mainScreen().bounds.size.width / CGFloat(viewControllers!.count)
        let rect  = CGRect(x: 0, y: 0, width: width, height: 49)
        composeBtn.frame = CGRectOffset(rect, 2 * width, 0)
    }
    

    private func addChildViewControllers() {
        let path = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil)

        if let jsonPath = path{
            let jsonData = NSData(contentsOfFile: jsonPath)
            
            do{

                let dictArr = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)
                for dict in dictArr as! [[String: String]]
                {
                    addChildViewController(dict["vcName"]!, title: dict["title"]!, imageName: dict["imageName"]!)
                }
                
            }catch
            {
                addChildViewController("HomeTableViewController", title: "首页", imageName: "tabbar_home")
                addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
                
                // 再添加一个占位控制器
                addChildViewController("NullViewController", title: "", imageName: "")
                addChildViewController("DiscoverTableViewController", title: "广场", imageName: "tabbar_discover")
                addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
            }
        }
        
    }

    private func addChildViewController(childControllerName: String, title:String, imageName:String) {
        let ns = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String

        let cls:AnyClass? = NSClassFromString(ns + "." + childControllerName)
        let vcCls = cls as! UIViewController.Type

        let vc = vcCls.init()
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        vc.title = title
        
        let nav = UINavigationController()
        nav.addChildViewController(vc)
        
        addChildViewController(nav)
        
    }
    
    
    // MARK: - 懒加载
    private lazy var composeBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named:"tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named:"tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        btn.addTarget(self, action: "composeBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    
}
