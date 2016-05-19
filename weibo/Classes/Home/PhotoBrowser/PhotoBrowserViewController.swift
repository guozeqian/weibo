//
//  PhotoBrowserViewController.swift
//  weibo
//
//  Created by guozeqian on 16/5/18.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit

class PhotoBrowserViewController: UIViewController {

    var currentIndex:Int?
    var pictureURLs:[NSURL]?
    init(index:Int,urls:[NSURL]){
        currentIndex = index
        pictureURLs = urls
        
        super.init(nibName:nil,bundle:nil)
        
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        setupUI()
    }
    
    private func setupUI()
    {
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        
        closeBtn.xmg_AlignInner(type: XMG_AlignType.BottomLeft, referView: view, size: CGSize(width: 100, height: 35))
        saveBtn.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: view, size: CGSize(width: 100, height: 35))
        collectionView.frame = UIScreen.mainScreen().bounds
    }

    func close(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save(){
        
    }
    
    private lazy var closeBtn:UIButton = {
       let btn = UIButton()
        btn.setTitle("关闭", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.backgroundColor = UIColor.darkGrayColor()
        btn.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    private lazy var saveBtn:UIButton = {
       let btn = UIButton()
        btn.setTitle("保存", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.backgroundColor = UIColor.darkGrayColor()
        btn.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    private lazy var collectionView:UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewLayout())


}






