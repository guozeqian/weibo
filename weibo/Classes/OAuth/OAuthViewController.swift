//
//  OAuthViewController.swift
//  weibo
//
//  Created by guozeqian on 16/5/1.
//  Copyright © 2016年 guozeqian. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {

    
    let WB_App_Key = "639075404"
    let WB_App_Secret = "3f7e700036ea71e5a7f739d854df385b"
    let WB_redirect_uri = "http://www.baidu.com"

    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "webo微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: "close")

        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_redirect_uri)"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    func close(){
        dismissViewControllerAnimated(true, completion: nil)
    }

    private lazy var webView: UIWebView = {
        let wv = UIWebView()
        wv.delegate = self
        return wv
    }()

}

extension OAuthViewController:UIWebViewDelegate{
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        
        
        let urlStr = request.URL?.absoluteString
        if !urlStr!.hasPrefix(WB_redirect_uri){
            return true
        }
        
        let codeStr = "code="
        if request.URL!.query!.hasPrefix(codeStr){
            let code = request.URL!.query!.substringFromIndex(codeStr.endIndex)
            print(code)
        }else{
            close()
        }
        return false
        
    }
    
    
    
}






