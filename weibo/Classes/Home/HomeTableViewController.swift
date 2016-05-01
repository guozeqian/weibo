//
//  HomeTableViewController.swift
//  weibo
//
//  Created by guozeqian on 16/4/23.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if !userLogin
        {
            visitorView?.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        setupNav()
    }
    
    private func setupNav(){
        navigationItem.leftBarButtonItem = UIBarButtonItem.createButtonItem("navigationbar_friendattention", targent: self, action: "leftItemClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem.createButtonItem("navigationbar_pop", targent: self, action: "rightItemClick")
        
        let titleBtn = titleButton()
        titleBtn.setTitle("阿麽 ", forState: UIControlState.Normal)
        titleBtn.addTarget(self, action: "titleBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleBtn
        
    }
    
    func titleBtnClick(btn:titleButton){
        btn.selected = !btn.selected
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        vc?.transitioningDelegate = self
        // 2.2设置转场的样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(vc!, animated: true, completion: nil)
    }
    func leftItemClick(){
        print(__FUNCTION__)
    }
    func rightItemClick(){
        let sb = UIStoryboard(name: "QRCodeViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    var isPresent:Bool = false
}
extension HomeTableViewController:UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning{
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?{
        return PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    //谁来负责转场动画
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = true
        return self
    }
    
    //谁来负责关闭动画
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = false
        return self
    }
    //执行时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 0.5
    }
    //动画内容
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        if isPresent
        {
            //展开
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            toView.transform = CGAffineTransformMakeScale(1.0, 0.0)
                
            transitionContext.containerView()?.addSubview(toView)
            //设置锚点
            toView.layer
            .anchorPoint = CGPoint(x: 0.5, y: 0)
            //执行动画
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                toView.transform = CGAffineTransformIdentity
                
                }, completion: { (_) -> Void in
                    // 2.2动画执行完毕, 一定要告诉系统
                    // 如果不写, 可能导致一些未知错误
                    transitionContext.completeTransition(true)
            })
            
        }else{
            //关闭
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            
            //执行动画
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                
                fromView!.transform = CGAffineTransformMakeScale(1.0, 0.00000001)
                
                }, completion: { (_) -> Void in
                    // 2.2动画执行完毕, 一定要告诉系统
                    // 如果不写, 可能导致一些未知错误
                    transitionContext.completeTransition(true)
            })
        }
        
        
    }

}











