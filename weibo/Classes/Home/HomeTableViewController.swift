//
//  HomeTableViewController.swift
//  weibo
//
//  Created by guozeqian on 16/4/23.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit

let XMGHomeReuseIdentifier = "XMGHomeReuseIdentifier"

class HomeTableViewController: BaseTableViewController {

    var statuses:[Status]?
        {
        didSet{
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if !userLogin
        {
            visitorView?.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        
        setupNav()
        // 3.注册通知, 监听菜单
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "change", name: XMGPopoverAnimatorWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "change", name: XMGPopoverAnimatorWilldismiss, object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "showPhotoBrowser:", name: XMGStatusPictureViewSelected, object: nil)
        
        // 注册一个cell
//        tableView.registerClass(StatusTableViewCell.self, forCellReuseIdentifier: XMGHomeReuseIdentifier)
        // 注册两个cell
        tableView.registerClass(StatusNormalTableViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.NormalCell.rawValue)
        tableView.registerClass(StatusForwardTableViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.ForwardCell.rawValue)
        
        
        //tableView.rowHeight = 200
//        tableView.estimatedRowHeight = 200
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        refreshControl = HomeRefreshControl()
        refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        
        loadData()
        
    }
    
    func showPhotoBrowser(notify:NSNotification){
        guard let indexPath = notify.userInfo![XMGStatusPictureViewIndexKey] as? NSIndexPath else{
            return
        }
        guard let urls = notify.userInfo![XMGStatusPictureViewURLsKey] as? [NSURL] else {
            return
        }
        // 1.创建图片浏览器
        let vc = PhotoBrowserViewController(index: indexPath.item, urls: urls)
        presentViewController(vc, animated: true, completion:nil)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /// 定义变量记录当前是上拉还是下拉
    var pullupRefreshFlag = false
    @objc private func loadData(){
        var since_id = statuses?.first?.id ?? 0
        var max_id = 0
        
        //判断是否为下拉刷新
        if pullupRefreshFlag
        {
            since_id = 0
            max_id = statuses?.last?.id ?? 0
        }
        
        Status.loadStatuses(since_id, max_id:max_id) { (models, error) -> () in
            self.refreshControl?.endRefreshing()
            
            if error != nil{
                return
            }
            if since_id > 0
            {
                self.statuses = models! + self.statuses!
                self.showNewStatusCount(models?.count ?? 0)
            }
            else if max_id > 0
            {
                self.statuses = self.statuses! + models!
            }
            else
            {
                self.statuses = models
            }
        }
    }
    
    private func showNewStatusCount(count:Int){
        newStatuslabel.hidden = false
        newStatuslabel.text = (count == 0) ? "没有刷新到新的微博数据" :"刷新到\(count)条微博数据"
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.newStatuslabel.transform = CGAffineTransformMakeTranslation(0, self.newStatuslabel.frame.height)
            }) { (_) -> Void in
                UIView.animateWithDuration(1, animations: { () -> Void in
                    self.newStatuslabel.transform = CGAffineTransformIdentity
                    }, completion: { (_) -> Void in
                        self.newStatuslabel.hidden = true
                })
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
                // 2.设置数据
        let status = statuses![indexPath.row]
        
        // 1.获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusTableViewCellIdentifier.cellID(status), forIndexPath: indexPath) as! StatusTableViewCell
        // 2.设置数据

        cell.status = status
        // 4.判断是否滚动到了最后一个cell
        let count = statuses?.count ?? 0
        if indexPath.row == (count - 1)
        {
            pullupRefreshFlag = true
            //            print("上拉加载更多")
            loadData()
        }
        // 3.返回cell
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let status = statuses![indexPath.row]
        if let height = rowCache[status.id]
        {
            return height
        }
        // 3.拿到cell
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusTableViewCellIdentifier.cellID(status)) as! StatusTableViewCell
        let rowHeight = cell.rowHeight(status)
        rowCache[status.id] = rowHeight

        return rowHeight
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
    
    
    /// 刷新提示控件
    private lazy var newStatuslabel:UILabel = {
        let label = UILabel()
        let height:CGFloat = 44
        label.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: height)
        label.backgroundColor = UIColor.orangeColor()
        label.textAlignment = NSTextAlignment.Center
        self.navigationController?.navigationBar.insertSubview(label, atIndex:0)
        label.hidden = true
        return label
        
    }()
    
    var rowCache:[Int:CGFloat] = [Int:CGFloat]()
    
    override func didReceiveMemoryWarning() {
        // 清空缓存
        rowCache.removeAll()
    }
    
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











