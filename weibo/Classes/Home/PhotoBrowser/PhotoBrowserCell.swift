//
//  PhotoBrowserCell.swift
//  weibo
//
//  Created by guozeqian on 16/5/19.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserCellDelegate:NSObjectProtocol {
    func photoBrowserCellDidClose(cell:PhotoBrowserCell)
}

class PhotoBrowserCell: UICollectionViewCell {
    
    weak var photoBrowserCellDelegate:PhotoBrowserCellDelegate?
    
    var imageURL:NSURL?{
        didSet{
            reset()
            
            activity.startAnimating()
            
            iconView.sd_setImageWithURL(imageURL) { (image, _, _, _) -> Void in
//                let size = self.displaySize(image)
//                self.iconView.frame = CGRect(origin: CGPointZero, size: size)
                self.setImageViewPostion()
            }
        }
    }

    private func reset(){
        scrollview.contentInset = UIEdgeInsetsZero
        scrollview.contentOffset = CGPointZero
        scrollview.contentSize = CGSizeZero
        //重置imageview
        iconView.transform = CGAffineTransformIdentity
    }

    /**
     调整图片显示的位置
     */
    private func setImageViewPostion()
    {
        // 1.拿到按照宽高比计算之后的图片大小
        let size = self.displaySize(iconView.image!)
        // 2.判断图片的高度, 是否大于屏幕的高度
        if size.height < UIScreen.mainScreen().bounds.height
        {
            // 2.2小于 短图 --> 设置边距, 让图片居中显示
            iconView.frame = CGRect(origin: CGPointZero, size: size)
            // 处理居中显示
            let y = (UIScreen.mainScreen().bounds.height - size.height) * 0.5
            self.scrollview.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
        }else
        {
            // 2.1大于 长图 --> y = 0, 设置scrollview的滚动范围为图片的大小
            iconView.frame = CGRect(origin: CGPointZero, size: size)
            scrollview.contentSize = size
        }
    }
    
    func close(){
        photoBrowserCellDelegate?.photoBrowserCellDidClose(self)
    }
    
    /**
     按照图片的宽高比计算图片显示的大小
     */
    private func displaySize(image: UIImage) -> CGSize
    {
        // 1.拿到图片的宽高比
        let scale = image.size.height / image.size.width
        // 2.根据宽高比计算高度
        let width = UIScreen.mainScreen().bounds.width
        let height =  width * scale
        
        return CGSize(width: width, height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI()
    {
        contentView.addSubview(scrollview)
        scrollview.addSubview(iconView)
        
        scrollview.frame = UIScreen.mainScreen().bounds
        
        scrollview.delegate = self
        scrollview.maximumZoomScale = 2.0
        scrollview.minimumZoomScale = 0.5
        
        let tap = UITapGestureRecognizer(target: self, action: "close")
        iconView.addGestureRecognizer(tap)
        iconView.userInteractionEnabled = true
    }

    private lazy var scrollview:UIScrollView = UIScrollView()
    
    private lazy var iconView:UIImageView = UIImageView()
    
    private lazy var activity:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
}

extension PhotoBrowserCell:UIScrollViewDelegate{
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return iconView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
//        print("11")
        var offsetX = (UIScreen.mainScreen().bounds.width - view!.frame.width) * 0.5
        var offsetY = (UIScreen.mainScreen().bounds.height - view!.frame.height) * 0.5
        offsetX = offsetX < 0 ? 0 : offsetX
        offsetY = offsetY < 0 ? 0 : offsetY
        
        scrollview.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
    
}






