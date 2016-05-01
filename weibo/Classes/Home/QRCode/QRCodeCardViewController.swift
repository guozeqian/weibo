//
//  QRCodeCardViewController.swift
//  weibo
//
//  Created by guozeqian on 16/5/1.
//  Copyright © 2016年 guozeqian. All rights reserved.
//  生成二维码视图

import UIKit

class QRCodeCardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "我的名片"
        view.addSubview(iconView)
        
        iconView.xmg_AlignInner(type: XMG_AlignType.Center, referView: view, size: CGSize(width: 200, height: 200))
        iconView.backgroundColor = UIColor.redColor()
        
        //生成二维码
        let qrcodeImage = createQRCodeImage()
        
        iconView.image = qrcodeImage
        
    }
    /**
     生成二维码的方法
     */
    private func createQRCodeImage() -> UIImage{
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        filter?.setValue("阿麽".dataUsingEncoding(NSUTF8StringEncoding),forKey:"inputMessage")
        let ciImage = filter?.outputImage
        let bgImage = createNonInterPolatedUIImageFormCIImage(ciImage!,size: 300)
        
        let icon = UIImage(named: "kakaluote.png")
        let newImage = createImage(bgImage,iconImage:icon!)
        
        return newImage
    }
    
    /**
     合成图片
     
     - parameter bgImage:   背景图
     - parameter iconImage: 头像
     
     - returns: 返回合成后的图片
     */
    private func createImage(bgImage:UIImage,iconImage:UIImage) -> UIImage
    {
        // 1.开启图片上下文
        UIGraphicsBeginImageContext(bgImage.size)
        // 2.绘制背景图片
        bgImage.drawInRect(CGRect(origin: CGPointZero, size: bgImage.size))
        // 3.绘制头像
        let width:CGFloat = 50
        let height:CGFloat = width
        let x = (bgImage.size.width - width) * 0.5
        let y = (bgImage.size.height - height) * 0.5
        iconImage.drawInRect(CGRect(x: x, y: y, width: width, height: height))
        // 4.取出绘制号的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 5.关闭上下文
        UIGraphicsEndImageContext()
        // 6.返回合成号的图片
        return newImage
    }
    
    /**
     根据CIImage生成指定大小的高清UIImage
     
     - parameter image: CIImage
     - parameter size:  大小
     
     - returns: 生成好的图片
     */
    private func createNonInterPolatedUIImageFormCIImage(image:CIImage,size:CGFloat) ->UIImage{
        let extent:CGRect = CGRectIntegral(image.extent)
        let scale: CGFloat = min(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent))
        // 1.创建bitmap;
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef,  CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale);
        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
        
    }
    private lazy var iconView:UIImageView = UIImageView()

   

}
