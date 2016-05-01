//
//  QRCodeViewController.swift
//  weibo
//
//  Created by guozeqian on 16/4/27.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController,UITabBarDelegate {
    //容器高度约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!

    //冲击波
    @IBOutlet weak var scanLineView: UIImageView!
    //冲击波顶部视图
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    
    
    @IBAction func CloseClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var customTabBar: UITabBar!
    
    @IBOutlet weak var resultLable: UILabel!
    
    /**
     我的名片点击
     
     - parameter sender: nil
     */
    @IBAction func myQRCodeClick(sender: AnyObject) {
        let vc = QRCodeCardViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customTabBar.selectedItem = customTabBar.items![0]
        customTabBar.delegate = self
    }


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        startAnimation()
        
        startScan()
    }
    /**
     扫描二维码
     */
    private func startScan(){
        //判断是否能够将输入添加到会话中
        if !session.canAddInput(deviceInput){
            return
        }
        //判断是否能够将输入添加到会话中
        if !session.canAddOutput(output){
            return
        }
        session.addInput(deviceInput)
        print(output.availableMetadataObjectTypes)
        session.addOutput(output)
        print(output.availableMetadataObjectTypes)
        
        // 4.设置输出能够解析的数据类型
        // 注意: 设置能够解析的数据类型, 一定要在输出对象添加到会员之后设置, 否则会报错
        output.metadataObjectTypes =  output.availableMetadataObjectTypes
        print(output.availableMetadataObjectTypes)
        // 5.设置输出对象的代理, 只要解析成功就会通知代理
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        // 如果想实现只扫描一张图片, 那么系统自带的二维码扫描是不支持的
        // 只能设置让二维码只有出现在某一块区域才去扫描
                output.rectOfInterest = CGRectMake(0.0, 0.0, 1, 1)
        

        
        // 添加预览图层
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        
        // 添加绘制图层到预览图层上
        previewLayer.addSublayer(drawLayer)
        
        // 6.告诉session开始扫描
        session.startRunning()
    }
    //执行动画操作
    private func startAnimation(){
        
        self.scanLineCons.constant = -self.containerHeightCons.constant
        view.layoutIfNeeded()
        
        //执行冲击波动画
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            
            self.scanLineCons.constant = self.containerHeightCons.constant
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.view.layoutIfNeeded()
        })
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag == 1 {
            self.containerHeightCons.constant = 300
        }else{
            self.containerHeightCons.constant = 150
        }
        
        self.scanLineView.layer.removeAllAnimations()
        startAnimation()
    }
   
    
    private lazy var session:AVCaptureSession = AVCaptureSession()
    
    private lazy var deviceInput:AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do{
            let input = try AVCaptureDeviceInput(device: device)
            return input
        }catch{
            print(error)
            return nil
        }
    }()
    
    private lazy var output:AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    private lazy var previewLayer:AVCaptureVideoPreviewLayer = {
       let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = UIScreen.mainScreen().bounds
        return layer
        
    }()
    
    //创建用于绘制边线的图层
    private lazy var drawLayer:CALayer = {
        let layer = CALayer()
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
    
}
extension QRCodeViewController:AVCaptureMetadataOutputObjectsDelegate{
    //只要解析到数据就会调用
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        print(metadataObjects.last?.stringValue)
        resultLable.text = metadataObjects.last?.stringValue
        resultLable.sizeToFit()
        
        clearConers()
        
        for object in metadataObjects {
            if object is AVMetadataMachineReadableCodeObject{
                let codeObject = previewLayer.transformedMetadataObjectForMetadataObject(object as! AVMetadataObject) as! AVMetadataMachineReadableCodeObject
                drawCorners(codeObject)
            }
        }
        
    }
    
    /**
     绘制图画
     
     - parameter codeObject: 保存了坐标系对象
     */
    private func drawCorners(codeObject:AVMetadataMachineReadableCodeObject){
        if codeObject.corners.isEmpty{
            return
        }
        //1.创建图层
        let layer = CAShapeLayer()
        layer.lineWidth = 4
        layer.strokeColor = UIColor.redColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        //2.创建路径
        let path = UIBezierPath()
        var point = CGPointZero
        var index:Int = 0
        //移动到第一个点
        CGPointMakeWithDictionaryRepresentation((codeObject.corners[index++] as! CFDictionaryRef), &point)
        path.moveToPoint(point)
        
        while index < codeObject.corners.count {
            CGPointMakeWithDictionaryRepresentation((codeObject.corners[index++] as! CFDictionaryRef), &point)
            path.addLineToPoint(point)
        }
        //关闭路径
        path.closePath()
        
        //绘制路径
        layer.path = path.CGPath
        //将绘制好的图层添加到drawLayer上
        drawLayer.addSublayer(layer)
        
        
        
    }
    
    
    /**
     清空边缘
     */
    private func clearConers(){
        if drawLayer.sublayers == nil || drawLayer.sublayers?.count == 0{
            return
        }
        for subLayer in drawLayer.sublayers! {
            subLayer.removeFromSuperlayer()
        }
    }
}
