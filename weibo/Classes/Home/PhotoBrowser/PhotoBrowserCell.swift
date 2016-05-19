//
//  PhotoBrowserCell.swift
//  weibo
//
//  Created by guozeqian on 16/5/19.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoBrowserCell: UICollectionViewCell {
    
    var imageURL:NSURL?{
        didSet{
            iconView.sd_setImageWithURL(imageURL) { (image, _, _, _) -> Void in
                let size = self.displaySize(image)
                self.iconView.frame = CGRect(origin: CGPointZero, size: size)
            }
        }
    }
    
    private func displaySize(image: UIImage) -> CGSize {
        let scale = image.size.height / image.size.width
        let width = UIScreen.mainScreen().bounds.width
        let height = width * scale
        
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
        contentView.addSubview(iconView)
        
        scrollview.frame = UIScreen.mainScreen().bounds
    }

    private lazy var scrollview:UIScrollView = UIScrollView()
    
    private lazy var iconView:UIImageView = UIImageView()
}
