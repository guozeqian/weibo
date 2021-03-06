//
//  AppDelegate.swift
//  weibo
//
//  Created by guozeqian on 16/4/23.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit
//控制器切换通知 bucuo
let XMGSwitchRootviewControllerKey = "XMGSwitchRootViewControllerKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        window?.backgroundColor = UIColor.whiteColor()
//        window?.rootViewController = MainTabBarViewController()
        //window?.rootViewController = NewfeatureCollectionViewController()
//        isNewUpdate()
//        window?.rootViewController = WelcomeViewController()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchRootViewController:", name: XMGSwitchRootviewControllerKey, object: nil)
        
        window?.rootViewController = defaultController()
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func switchRootViewController(notify:NSNotification){
        if notify.object as! Bool
        {
            window?.rootViewController = MainTabBarViewController()
        }else{
            window?.rootViewController = WelcomeViewController()
        }
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func defaultController() -> UIViewController{
        if UserAccount.userLogin(){
            return isNewUpdate() ? NewfeatureCollectionViewController() : WelcomeViewController()  
        }
        return isNewUpdate() ? NewfeatureCollectionViewController() : MainTabBarViewController()
    }
    /**
     判断是否是第一次登陆
     
     - returns: 返回true or false
     */
    private func isNewUpdate() -> Bool{
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        let sandboxVersion = NSUserDefaults.standardUserDefaults().objectForKey("CFBundleShortVersionString") as? String ?? ""
        
        if currentVersion.compare(sandboxVersion) == NSComparisonResult.OrderedDescending
        {
            NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: "CFBundleShortVersionString")
            return true
        }
        
        return false
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

