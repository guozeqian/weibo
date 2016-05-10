//
//  NewfeatureCollectionViewController.swift
//  weibo
//
//  Created by guozeqian on 16/5/2.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"

class NewfeatureCollectionViewController: UICollectionViewController {

    private let pageCount = 4
    
    private var layout:UICollectionViewFlowLayout = NewfeatureLayout()
    
    init(){
        super.init(collectionViewLayout:layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.registerClass(NewfeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewfeatureCell
    
        cell.imageIndex = indexPath.item
    
        return cell
    }

    // 完全显示一个cell之后调用
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let path = collectionView.indexPathsForVisibleItems().last!
        if path.item == (pageCount - 1){
            // 2.拿到当前索引对应的cell
            let cell = collectionView.cellForItemAtIndexPath(path) as! NewfeatureCell
            // 3.让cell执行按钮动画
            cell.startBtnAnimation()
        }
    }
   
}

class NewfeatureCell:UICollectionViewCell{
    private var imageIndex:Int?{
        didSet{
            iconView.image = UIImage(named: "new_feature_\(imageIndex! + 1)")
            
        }
    }
    
    func startBtnAnimation(){
        startButton.hidden = false
        startButton.transform = CGAffineTransformMakeScale(0.0, 0.0)
        startButton.userInteractionEnabled = false
        
        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
            () -> Void in
            self.startButton.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                self.startButton.userInteractionEnabled = true
        }

        
    }
    
    override init(frame: CGRect){
        super.init(frame:frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startButtonClick(){
        NSNotificationCenter.defaultCenter().postNotificationName(XMGSwitchRootviewControllerKey, object: false)
    }
    
    private func setupUI(){
        // 1.添加子控件到contentView上
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        
        // 2.布局子控件的位置
        iconView.xmg_Fill(contentView)
        startButton.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: contentView, size: nil, offset: CGPoint(x: 0, y: -160))
    
    }
    private lazy var iconView = UIImageView()
    
    private lazy var startButton:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named:"new_feature_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"new_feature_button_highlighted"), forState: UIControlState.Highlighted)
        btn.hidden = true
        btn.addTarget(self, action: "startButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
}

private class NewfeatureLayout: UICollectionViewFlowLayout{
    // 准备布局
    override func prepareLayout()
    {
        // 1.设置layout布局
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 2.设置collectionView的属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
    }

}
