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
class StatusTableViewCell: UITableViewCell {
    
    /// 保存配图的宽度约束
    var pictureWidthCons: NSLayoutConstraint?
    /// 保存配图的高度约束
    var pictureHeightCons: NSLayoutConstraint?

    var status:Status?{
        didSet{
            nameLabel.text = status?.user?.name
            
            contentLabel.text = status?.text
            
            // 设置用户头像
            if let url = status?.user?.imageURL
            {
                iconView.sd_setImageWithURL(url)
            }
            // 设置认证图标
            verifiedView.image = status?.user?.verifiedImage
            // 设置会员图标
            print("mbrankImage = \(status?.user?.mbrankImage)")
            vipView.image = status?.user?.mbrankImage
            // 设置来源
            sourceLabel.text = status?.source
            // 设置时间
            timeLabel.text = status?.created_at
            
            // 设置配图的尺寸
            // 1.1根据模型计算配图的尺寸
            let size = calculateImageSize()
            // 1.2设置配图的尺寸
            pictureWidthCons?.constant = size.viewSize.width
            pictureHeightCons?.constant = size.viewSize.height
            // 1.3设置cell的大小
            pictureLayout.itemSize = size.itemSize
            // 1.4刷新表格
            pictureView.reloadData()
        }
    }
    
    override init(style:UITableViewCellStyle,reuseIdentifier:String?){
        super.init(style:style,reuseIdentifier:reuseIdentifier)
        
        setupUI()
        
        // 初始化配图
        setupPictureView()
    }
    
    private func setupPictureView(){
        //1.注册cell
        pictureView.registerClass(PictureViewCell.self, forCellWithReuseIdentifier: XMGPictureViewCellReuseIdentifier)
        
        pictureView.dataSource = self
        
        pictureLayout.minimumInteritemSpacing = 10
        pictureLayout.minimumLineSpacing = 10
        
        pictureView.backgroundColor = UIColor.darkGrayColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        // 1.添加子控件
        contentView.addSubview(iconView)
        contentView.addSubview(verifiedView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(vipView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(footerView)
        footerView.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        contentView.addSubview(pictureView)
        
        // 2.布局子控件
        iconView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: contentView, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
        verifiedView.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x:5, y:5))
        nameLabel.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        vipView.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 10, y: 0))
        timeLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 10, y: 0))
        contentLabel.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 10))
        
        let cons = pictureView.xmg_AlignVertical(type:XMG_AlignType.BottomLeft,referView:contentLabel,size:CGSizeZero,offset:CGPoint(x:0,y:10))
        pictureWidthCons = pictureView.xmg_Constraint(cons, attribute:NSLayoutAttribute.Width)
        pictureHeightCons = pictureView.xmg_Constraint(cons, attribute:NSLayoutAttribute.Height)
        
        let width = UIScreen.mainScreen().bounds.width
        footerView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))
        
//        footerView.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: contentView, size: nil, offset: CGPoint(x: -10, y: -10))
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

    
    //头像
    private lazy var iconView:UIImageView = {
       let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        return iv
    }()
    //认证图标
    private lazy var verifiedView:UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    //昵称
    private lazy var nameLabel:UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    //会员图标
    private lazy var vipView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    //时间
    private lazy var timeLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    //来源
    private lazy var sourceLabel:UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    //正文
    private lazy var contentLabel:UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        return label
    }()
    //配图
    private lazy var pictureLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var pictureView:UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.pictureLayout)

 
    /// 底部工具条
    private lazy var footerView: StatusFooterView = StatusFooterView()

}

class StatusFooterView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化UI
        setupUI()
    }
    
    
    private func setupUI()
    {
        // 1.添加子控件
        addSubview(retweetBtn)
        addSubview(unlikeBtn)
        addSubview(commonBtn)
        
        // 2.布局子控件
        xmg_HorizontalTile([retweetBtn, unlikeBtn, commonBtn], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    // MARK: - 懒加载
    // 转发
    private lazy var retweetBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "timeline_icon_retweet"), forState: UIControlState.Normal)
        btn.setTitle("转发", forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(10)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return btn
    }()
    
    // 赞
    private lazy var unlikeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "timeline_icon_unlike"), forState: UIControlState.Normal)
        btn.setTitle("赞", forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(10)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return btn
    }()
    
    // 评论
    private lazy var commonBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "timeline_icon_comment"), forState: UIControlState.Normal)
        btn.setTitle("评论", forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(10)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StatusTableViewCell: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.storedPicURLS?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1.取出cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(XMGPictureViewCellReuseIdentifier, forIndexPath: indexPath) as! PictureViewCell
        // 2.设置数据
        //        cell.backgroundColor = UIColor.greenColor()
        cell.imageURL = status?.storedPicURLS![indexPath.item]
        // 3.返回cell
        return cell
    }
}

class PictureViewCell:UICollectionViewCell{
    var imageURL:NSURL?{
        didSet{
            iconImageView.sd_setImageWithURL(imageURL!)
        }
    }
    
    override init(frame:CGRect){
        super.init(frame:frame)
        //添加子控件
        contentView.addSubview(iconImageView)
        //布局子控件
        iconImageView.xmg_Fill(contentView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var iconImageView:UIImageView = UIImageView()
}
