//
//  SyetemTool.swift
//  jujuwan_swift
//
//  Created by wlx on 2019/12/29.
//  Copyright © 2019 furong. All rights reserved.
//

import UIKit
import AdSupport
import AppTrackingTransparency
import SwiftDate
import SwiftyJSON

class SystemTool: NSObject {
    static let shared = SystemTool()
    private override init() {
        super.init()
    }
    
    /// 系统信息
    func systemInfo() -> Dictionary<String, Any>?{
        let info = Bundle.main.infoDictionary
        return info
    }
    
    // MARK: - 版本信息
    /// 当前版本(字符串格式: 版本信息+.+第几次编译)
    func currentVersion() -> String? {
        if let info = systemInfo() {
            let shortVersion:String = info["CFBundleShortVersionString"] as! String
//            let version = shortVersion
            let bundleVersion:String = info["CFBundleVersion"] as! String
            return "\(shortVersion).\(bundleVersion)"
        }
        return nil
    }
    
    
    /// 检查版本是否需要更新
    /// true 需要更新
    /// false 不需要更新
    @discardableResult
    func checkVersion(updateModel: AppUpdateModel, ifShowResult: Bool) -> Bool{
        guard let current = currentVersion(), let versionName = updateModel.versionName else { return false }
        UserDefaults.setUserDefaults(with: Constants.kLastVersion, value: current)
        
        if let old = getIntFromVersion(versionStr: current), let new = getIntFromVersion(versionStr: versionName) {
            if old >= new {
                if ifShowResult {
                    SystemTool.showMessage("当前已是最新版本!")
                }
                return false
            }
        }
        
        ZASUpdateAlert.show(version: "\(updateModel.versionName ?? "1.0")", content: updateModel.updateMsg ?? "修复已知bug,优化用户体验", appId: "\(updateModel.downloadUrl ?? "")", isMustUpdate: updateModel.forceUpgrade ?? false)
        return true
    }
    
    
    /// 获取用户id
    static func getUserID() -> Int? {
        if let u = UserDefaults.getCustomObject(Constants.kUser) as? User {
            return u.userId
        }
        
        SystemTool.shared.presentToLogin()
        return nil
    }
    
    /// 获取用户secretKey
    static func getUserSecretKey() -> String? {
        if let u = UserDefaults.getCustomObject(Constants.kUser) as? User {
            return u.secretKey
        }
        
        SystemTool.shared.presentToLogin()
        return nil
    }


    
    /// 跳转到l登录页
    func presentToLogin() {
        DispatchQueue.main.async {
            
        }
    }
    
    /// 跳转到主tabbar下的viewController
    /// - Parameter index: tabbar的index
    static func jumpToMainTabbarViewController(_ index: Int) {
        if let vc = UIViewController.currentViewController(), let nav = vc.navigationController as? FR_NavViewController {
            nav.popToRootViewController(animated: false)
        }
        
        (UIApplication.shared.delegate?.window??.rootViewController as? UITabBarController)?.selectedIndex = index
    }
    
    
    /// 从json文件加载数据
    /// - Parameter fileName: 文件名
    static func arrayFromJsonFile(_ fileName: String) -> Array<Any>? {
        let path = Bundle.main.path(forResource: fileName, ofType: "json")
        if let p = path {
            let url = URL(fileURLWithPath: p)
            
            do {
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                let arr = json as? Array<Any>
                return arr
            } catch let error {
                Util.printX("arrayFromJsonFile error: \(error)")
            }
        }
        return nil
    }
    
    /// 从json加载字典
    /// - Parameter fileName: json文件名字
    static func dictFromJsonFile(_ fileName: String) -> Dictionary<String, Any>? {
        let path = Bundle.main.path(forResource: fileName, ofType: "json")
        if let p = path {
            let url = URL(fileURLWithPath: p)
            
            do {
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                let dict = json as? Dictionary<String, Any>
                return dict
            } catch let error {
                Util.printX("dictFromJsonFile error: \(error)")
            }
        }
        return nil
    }
    
    // MARK: - 弹窗提示
    static func showInfo(_ str: String? ) {
        HUD.show(msg: str!)
    }
    
    static func showSuccess(_ str: String? ) {
        HUD.show(msg: str!)
    }
    
    static func showMessage(_ str: String? ) {
        HUD.show(msg: str!)
    }
    
    static func show(_ str: String? = nil) {
        HUD.loading(msg: str, toView: UIApplication.mainWindow(), delay: 0)
    }
    
    static func dismiss() {
        HUD.hideLoading()
    }
    
    
    // MARK: - 打开QQ
    static func jumpToQQ(_ qq: String) {
        if(UIApplication.shared.canOpenURL(URL(string: "mqq://")!)){
            let str =  String(format: "mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", qq)
            UIApplication.shared.open(URL(string: str)!, options: [:], completionHandler: nil)
        }else{
            SystemTool.showInfo("没有发现QQ")
        }
    }
    
    /// 跳转qq群
    /// - Parameter qq: 群号
    static func jumpToQQGroup(_ qq: String) {
        if(UIApplication.shared.canOpenURL(URL(string: "mqq://")!)){
            let str =  String(format: "mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", qq, Constants.kQQAppKey)
            UIApplication.shared.open(URL(string: str)!, options: [:], completionHandler: nil)
        }else{
            SystemTool.showInfo("没有发现QQ")
        }
    }
    
    
   /// 获取给定时间的月第一天和最后一天
    /// - Parameters:
    ///   - date: 给定时间
    ///   - style: 返回的日期格式
    static func getFirstAndLast(date: Date? = Date(), style: DateToStringStyles? = .custom("yyyy-MM-dd")) -> (String, String) {
        let start = date!.dateAtStartOf(Calendar.Component.month)
        let end = date!.dateAtEndOf(Calendar.Component.month)
        let startStr = start.toString(style)
        let endStr = end.toString(style)
        return (startStr, endStr)
    }
    
    /// Int类型转换成最多num位小数
    /// - Parameters:
    ///   - number: Int类型的数字
    ///   - num: 小数点后的位数
    ///   - unit: 换算单位
    static func maxDecimals(number: Int, num: Int,_ unit: Double? = Constants.kTenThousand,_ ifShowUnit: Bool? = true) -> String? {
        let formate = NumberFormatter()
        formate.maximumFractionDigits = num
        formate.minimumIntegerDigits = 1
    
        var result = ""
        var isZero = false //是否=0
        if num == 0 {
            let temp = Int(Double(number) / unit!)
            result = formate.string(from: NSNumber.init(value: temp)) ?? "0"
        }else{
            let doubleV = Double(number) / unit!
            isZero = (doubleV == 0.0)
            //直接截取
            result = "\(doubleV.truncate(places: num))"
            //四舍五入
//            result = formate.string(from: NSNumber.init(value: Double(number) / unit!)) ?? "0"
        }
        
        if unit == Constants.kTenThousand && ifShowUnit == true && isZero != true {
            return result + "万"
        }else if unit == Constants.kHundred && ifShowUnit == true {
            return result + "元"
        }
        
        return result
    }
    
    /// 应用跳转
    /// - Parameters:
    ///   - url: 跳转的url
    ///   - appId: 应用的appId
    ///   - isAppStore: 是否是App Store应用
    static func jumpToOtherApp(url: String?,_ appId: String? = nil,_ isAppStore: Bool? = false){
        var urlStr:URL?
        if isAppStore == true && appId != nil{
            urlStr = ("itms-apps://itunes.apple.com/app/id" + appId!).stringToUrl()
        }else{
            guard let str = url else { return }
            urlStr = str.stringToUrl()
        }
        
        guard let u = urlStr else { return }
        
        guard UIApplication.shared.canOpenURL(u) else {
            SystemTool.showMessage("不能打开\(appId ?? "")应用")
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(u, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(u)
        }
    }
    
    
    /// 是否能打开App
    /// - Parameter urlString: app白名单(类似 jujuwan:// )
    static func canOpenApp(urlString: String?) -> Bool{
        guard let urlStr = urlString else { return false }
        guard let url = (urlStr).stringToUrl() else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    /// 获取广告标识符
    /// iOS14 通过回到获取
    /// iOS13以下通过返回值获取
    @discardableResult
    static func getIDFA(block: ((String?) -> Void)? = nil) -> String? {
        if #available(iOS 14, *) {
            let status = ATTrackingManager.trackingAuthorizationStatus
            switch status {
            case .authorized:
                return ASIdentifierManager.shared().advertisingIdentifier.uuidString
            default:
                requestTrackingAuthorization(blcok: block)
                return nil
            }
        } else {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                return ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }else{
                let alert = SystemTool.alertVC(title: "温馨提示", message: "请将 设置->隐私->广告->限制广告跟踪 保持关闭状态,并重启app再试", btns: ["去设置"], cancel: true) { (index) in
                    if index == 0 {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }
                }
                DispatchQueue.main.async {
                    UIViewController.currentViewController()?.present(alert, animated: true, completion: nil)
                }
                return nil
            }
        }
        
    }
    
    /// 快速弹窗
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 信息
    ///   - btns: 按钮标题
    ///   - cancel: 取消
    ///   - complete: 回调
    static func alertVC(title: String?, message: String?, btns: [String], cancel: Bool,_ type: UIAlertController.Style? = .alert, complete: ((Int)-> Void)?) -> UIAlertController {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: type!)
        for (index,str) in btns.enumerated() {
            let action = UIAlertAction.init(title: str, style: UIAlertAction.Style.default, handler: { (action) in
                alertVC.dismiss(animated: false, completion: nil)
                complete?(index)
            })
            alertVC.addAction(action)
        }
        
        if cancel {
            let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
            alertVC.addAction(cancelAction)
        }
        return alertVC
    }
    
    
    
    
    /// 开启人脸识别
    static func checkFaceVerify(_ json: JSON?){
        if let code = json?["code"].int {
            if code == 100 {
                guard let user = UserDefaults.getCustomObject(Constants.kUser) as? User else {
                    SystemTool.showMessage(Constants.kGetUserInfoError)
                    return
                }
                
                if user.faceVerify == 0 {
                    HUD.show(msg: "您还没有进行人脸识别，为保障您的资金安全请及时验证")
                }
            }
        }
    }
    
    
    /// 跳转本地页面或者网页
    /// - Parameter banner: 轮播图对象
    static func jumpToWebOrVC(banner: Banner?) {
        guard let ban = banner else {
            SystemTool.showMessage("开发中,敬请期待...")
            return
        }
        //游戏
        if ban.imgnav == "jjw.GameDetailActivity" {
//            UIViewController.pushToViewController("GameDetailViewController", ["gameId": ban.appTaskId ?? 0])
            SystemTool.showMessage("此游戏为安卓游戏,请在安卓端试玩!")
        } else if let jumplink = ban.jumplink, !jumplink.isEmpty {
            let web = FR_WKWebViewController()
            web.urlStr = jumplink
            UIViewController.pushToViewController(web)
        } else {
//            SystemTool.showMessage("跳转链接无效!")
        }
       
    }
    
    /// 把版本字符串转换成整数
    /// - Parameter versionStr: 版本字符串
    func getIntFromVersion(versionStr: String) -> Int? {
        let version = versionStr.replacingOccurrences(of: ".", with: "")
        //不是三位,就在后面补个0
//        if version.length < 3 {
//            version = "\(version)0"
//        }
        return Int(version)
    }
    
    /// 判断是否开启了代理(防抓包)
    public func isUsedProxy() -> Bool {
        guard let proxy = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() else { return false }
        guard let dict = proxy as? [String: Any] else { return false }
        guard let HTTPProxy = dict["HTTPProxy"] as? String else { return false }
        if(HTTPProxy.count>0){
            return true;
        }
        return false;
    }
    
    /// 粘贴板复制字符串str
    /// (str如果为null,会导致崩溃)
    /// - Parameters:
    ///   - str: 要复制的内容
    ///   - msg: 提示消息
    public static func pasteboardCopy(str: String?, msg: String? = nil){
        if let s = str {
            UIPasteboard.general.string = s
        }
        if let m = msg {
            SystemTool.showMessage(m)
        }
    }
    
    /// 申请IDFA权限
    static func requestTrackingAuthorization(blcok: ((String?) -> Void)?){
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { (status) in
                if status == .authorized {
                    blcok?(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
                } else {
                    let alert = SystemTool.alertVC(title: "温馨提示", message: "请将 设置->聚聚玩->允许跟踪 保持开启状态,并重新进入app再试", btns: ["去设置"], cancel: true) { (index) in
                        if index == 0 {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                        }
                    }
                    DispatchQueue.main.async {
                        UIViewController.currentViewController()?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } else {
            // Fallback on earlier versions
            blcok?(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
        }
    }
}

