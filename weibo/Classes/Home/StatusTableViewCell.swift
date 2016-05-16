//
//  StatusTableViewCell.swift
//  weibo
//
//  Created by guozeqian on 16/5/10.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit
import SDWebImage

let XMGPictureViewCellReuseIdentifier = "XMGPictureViewCellReuseIdentifier"

/**
 保存cell的重用标示
 
 - NormalCell:  原创微博的重用标识
 - ForwardCell: 转发微博的重用标识
 */
enum StatusTableViewCellIdentifier: String
{
    case NormalCell = "NormalCell"
    case ForwardCell = "ForwardCell"
    
    // 如果在枚举中利用static修饰一个方法 , 相当于类中的class修饰方法
    // 如果调用枚举值的rawValue, 那么意味着拿到枚举对应的原始值
    static func cellID(status: Status) ->String
    {
        return status.retweeted_status != nil ? ForwardCell.rawValue : NormalCell.rawValue
    }
}

class StatusTableViewCell: UITableViewCell {
    

    /// 保存配图的宽度约束
    var pictureWidthCons: NSLayoutConstraint?
    /// 保存配图的高度约束
    var pictureHeightCons: NSLayoutConstraint?
    //保存配图的约束
    var pictureTopCons: NSLayoutConstraint?
    
    
    var status:Status?{
        didSet{
            topView.status = status
            
            
            // 设置正文
            contentLabel.text = status?.text

            // 设置配图的尺寸
            pictureView.status = status?.retweeted_status != nil ? status?.retweeted_status :  status

           // pictureView.reloadData()
            
            // 注意: 计算尺寸需要用到模型, 所以必须先传递模型
            let size = pictureView.calculateImageSize()
            // 1.2设置配图的尺寸
            pictureWidthCons?.constant = size.width
            pictureHeightCons?.constant = size.height
            pictureTopCons?.constant = size.height == 0 ? 0 : 10

        }
    }
    
    override init(style:UITableViewCellStyle,reuseIdentifier:String?){
        super.init(style:style,reuseIdentifier:reuseIdentifier)
        
        setupUI()
        
    
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        // 1.添加子控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
//        footerView.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        contentView.addSubview(pictureView)
        contentView.addSubview(footerView)
        
        
        let width = UIScreen.mainScreen().bounds.width
        // 2.布局子控件
        topView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: contentView, size: CGSize(width: width, height: 60))
        
        contentLabel.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint(x: 10, y: 10))
        
        footerView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))
    }
    
    /**
     用于缓存行高
     
     - parameter status：模型数据
     
     - returns: 行高
     */
    func rowHeight(status:Status) ->CGFloat{
        self.status = status
        self.layoutIfNeeded()
        return CGRectGetMaxY(footerView.frame)
    }
    
    /**
     计算配图的尺寸
     */
    private func calculateImageSize() -> (viewSize: CGSize, itemSize: CGSize){
        let count = status?.storedPicURLS?.count
        if count == 0 || count == nil{
            return (CGSizeZero, CGSizeZero)
        }
        if count == 1 {
            let key = status?.storedPicURLS!.first?.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key!)
            return (image.size, image.size)
        }
        let width = 90
        let margin = 10
        if count == 4{
            let viewWidth = width * 2 + margin
            return (CGSize(width: viewWidth, height: viewWidth), CGSize(width: width, height: width))
        }
        
        //计算列数
        let colNumber = 3
        let rowNumber = (count! - 1) / 3 + 1
        let viewWidth = colNumber * width + (colNumber - 1) * margin
        let viewHeight = rowNumber * width + (rowNumber - 1) * margin
        return (CGSize(width: viewWidth, height: viewHeight), CGSize(width: width, height: width))
    }

    /// 顶部视图
    private lazy var topView: StatusTableViewTopView = StatusTableViewTopView()
    
       //正文
    lazy var contentLabel:UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        return label
    }()
    
    /// 配图
    lazy var pictureView: StatusPictureView = StatusPictureView()
    
    /// 底部工具条
    lazy var footerView: StatusTableViewBottomView = StatusTableViewBottomView()
}



