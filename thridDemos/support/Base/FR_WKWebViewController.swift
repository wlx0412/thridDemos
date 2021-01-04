//
//  FR_WKWebViewController.swift
//  frapp
//
//  Created by fr on 2020/9/17.
//  Copyright © 2020 fr. All rights reserved.
//

import UIKit
import WebKit

let jxName = "wlx"

//h5是否播放声音
enum VoicePlayType:Int {
    case pause = 0
    case play = 1
}

public class FR_WKWebViewController: FR_BaseViewController {
    var titleName: String?{
        willSet {
            self.title = newValue
        }
    }
    
    var urlStr: String?{
        willSet {
            if let url = newValue?.stringToUrl() {
                webView.load(URLRequest(url: url))
            }
        }
    }
    
    var htmlStr: String?{
        willSet {
            if let str = newValue {
                webView.loadHTMLString(str, baseURL: nil)
            }
        }
    }
    
    // 进度条
    lazy var progressView:UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = UIColor.orange
        progress.trackTintColor = .clear
        return progress
    }()
    
    lazy var webView : WKWebView = {
        /// 自定义配置
        let conf = WKWebViewConfiguration()
        conf.allowsInlineMediaPlayback = true
        conf.mediaPlaybackRequiresUserAction = false
        conf.userContentController = WKUserContentController()
        conf.preferences.javaScriptEnabled = true
        conf.selectionGranularity = WKSelectionGranularity.character
        let web = WKWebView( frame: UIScreen.main.bounds, configuration: conf)
        web.navigationDelegate = self
        return web
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(webView)
        webView.navigationDelegate = self
        view.addSubview(self.progressView)
        
        //进入后台和进入前台,通知声音开关
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterBackground), name: NSNotification.Name.init(UIApplication.didEnterBackgroundNotification.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name.init(UIApplication.willEnterForegroundNotification.rawValue), object: nil)
        
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.progressView.frame = CGRect(x:0,y: 0,width:self.view.frame.size.width,height:2)
        self.progressView.isHidden = false
        UIView.animate(withDuration: 1.0) {
            self.progressView.progress = 0.0
        }
        
        webView.configuration.userContentController.add(self, name: jxName)
        voicePlayOrPause(type: .play)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //当前ViewController销毁前将其移除，否则会造成内存泄漏
        webView.configuration.userContentController.removeScriptMessageHandler(forName: jxName)
        voicePlayOrPause(type: .pause)
    }
    
    @objc func applicationWillEnterBackground() {
        voicePlayOrPause(type: .pause)
    }
    
    @objc func applicationWillEnterForeground() {
        voicePlayOrPause(type: .play)
    }
    
    //暂停声音或者播放声音
    func voicePlayOrPause(type: VoicePlayType) -> Void {
        //不是"疯狂捕牛"小游戏就不做操作
        if urlStr?.contains("cow.jujuwan.com") == true {
            var jsStr = ""
            if type == .play {
                jsStr = "document.querySelector('#bgm').play()"
            } else if type == .pause {
                jsStr = "document.querySelector('#bgm').pause()"
            }
            webView.evaluateJavaScript(jsStr, completionHandler: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //加载完成回调
    func webViewLoadFinished(){
        
    }
    
    public override func goBack() -> Bool {
        return true
    }
    
    
    deinit {
        Util.printX("WKWebViewController销毁了")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(UIApplication.didEnterBackgroundNotification.rawValue), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(UIApplication.willEnterForegroundNotification.rawValue), object: nil)
    }
}

extension FR_WKWebViewController: WKNavigationDelegate{
    // 页面开始加载时调用
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        self.title = "加载中..."
        /// 获取网页的progress
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = Float(self.webView.estimatedProgress)
        }
    }
    // 当内容开始返回时调用
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        
    }
    // 页面加载完成之后调用
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        /// 获取网页title
        if self.titleName == nil || self.titleName?.isEmpty == true {
            self.title = self.webView.title
        } else{
            self.title = titleName
        }
        
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 1.0
            self.progressView.isHidden = true
        }
        
        webViewLoadFinished()
    }
    // 页面加载失败时调用
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 0.0
            self.progressView.isHidden = true
        }
        /*
        /// 弹出提示框点击确定返回
        let alertView = UIAlertController.init(title: "提示", message: "加载失败", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title:"确定", style: .default) { okAction in
            _=self.navigationController?.popViewController(animated: true)
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
        */
    }
    
}

extension FR_WKWebViewController:WKScriptMessageHandler{//用于与JS交互
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        Util.printX("message name: \(message.name)")
    }
    
}
