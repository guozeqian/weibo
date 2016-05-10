//
//  StatusTableViewCell.swift
//  weibo
//
//  Created by guozeqian on 16/5/10.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit

class StatusTableViewCell: UITableViewCell {

    var status:Status?{
        didSet{
            iconView.sd_setImageWithURL(NSURL(string: (status?.user?.profile_image_url)!))
        }
    }
    
    override init(style:UITableViewCellStyle,reuseIdentifier:String?){
        super.init(style:style,reuseIdentifier:reuseIdentifier)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(iconView)
        
        
        //布局
        iconView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: contentView, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
        
    }
    
    
    //头像
    private lazy var iconView:UIImageView = {
       let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        return iv
    }()

}
