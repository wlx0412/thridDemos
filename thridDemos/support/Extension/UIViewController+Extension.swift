//
//  UIViewController+Extension.swift
//  frongbook
//
//  Created by wlx on 2020/11/18.
//  Copyright © 2020 furong. All rights reserved.
//  封装了一些跳转方法

import Foundation
import UIKit


public extension UIViewController{
    /// 添加存储属性的key
    fileprivate struct AssociateKeys {
        static var UIViewControllerIdentifierKey = 1000
        static var navBarBgAlpha = 1.0
    }
    
    /// 跳转到当前页面时带过来的参数
    var parameter: Dictionary<String, Any>? {
        get {
            if let rs = objc_getAssociatedObject(self, &AssociateKeys.UIViewControllerIdentifierKey) as? Dictionary<String, Any> {
                return rs
            }
            return nil
        }
        
        set {
            objc_setAssociatedObject(self, &AssociateKeys.UIViewControllerIdentifierKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    
    /// 导航栏透明度
    var navBarBgAlpha: CGFloat {
        get {
            var alpha = objc_getAssociatedObject(self, &AssociateKeys.navBarBgAlpha) as? CGFloat
            if alpha == nil {
                alpha = 1.0
            }
            return alpha!
        }
        
        set {
            var alpha = newValue
            if alpha == nil || alpha > 1.0 || alpha < 0.0 {
                alpha = 1.0
            }
            objc_setAssociatedObject(self, &AssociateKeys.navBarBgAlpha, alpha, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    /// 获取当前应用显示的VC
    /// - Parameter base: 参数
    /// - Returns: UIViewController?
    static func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
    
    /// push方式跳转
    /// - Parameters:
    ///   - vc: 目的地VC
    ///   - para: 要传的参数
    class func pushToViewController(_ vc: UIViewController,_ parameters: Dictionary<String, Any>? = nil) {
        let topVC = currentViewController()
    
        if topVC?.navigationController != nil {
            if let dict = parameters {
                vc.parameter = dict
            }
            topVC?.navigationController!.pushViewController(vc, animated: true)
        }else{
            Util.printX("当前vc没有UINavigationController")
        }
    }
    
    /// push方式跳转
    /// - Parameters:
    ///   - vcName: 目的地VC的类名字符串
    ///   - dict: 参数
    class func pushToViewController(_ vcName: String,_ parameters: Dictionary<String, Any>? = nil) {
        UIViewController.pushToViewController(UIViewController.getViewControllerFromStr(vcName: vcName)!, parameters)
    }
    

    /// present方式跳转
    /// - Parameters:
    ///   - vc: 目的地VC
    ///   - parameters: 参数
    ///   - block: 回调
    class func presentViewController(_ vc: UIViewController,_ parameters: [String: Any],_ block: (()->Void)?) {
        let topVC = currentViewController()
        vc.parameter = parameters
        topVC?.present(vc, animated: true, completion: block)
    }
    
    
    /// present方式跳转
    /// - Parameters:
    ///   - vcName: 目的地VC的类名字符串
    ///   - parameters: 参数
    ///   - block: 回调
    class func presentViewController(_ vcName: String,_ parameters: [String: Any],_ block: (()->Void)?) {
        let topVC = currentViewController()
        if let vc = UIViewController.getViewControllerFromStr(vcName: vcName){
            vc.parameter = parameters
            topVC?.present(vc, animated: true, completion: block)
        }
    }
    
    
    /// 从字符串创建vc
    /// - Parameter vcName: 类名
    /// - Returns: UIViewController?
    class func getViewControllerFromStr(vcName: String) -> UIViewController? {
        guard let nameSpace = Bundle.main.infoDictionary![kCFBundleExecutableKey as String] as? String else{
            Util.printX("没有获取到命名空间")
            return nil
        }
        
        guard let nameClass = NSClassFromString(nameSpace + "." + vcName) else{
            Util.printX("没有获取到对应的类")
            return nil
        }
        
        guard let type = nameClass as? UIViewController.Type else{
            
            return nil
        }
        
        return type.init()
    }
    
    
    /// nav跳转到指定vc
    /// - Parameter vcName: vc的类名
    class func popToViewController(vcName: String) {
        let topVC = UIViewController.currentViewController()
        if topVC?.navigationController != nil {
            for child in topVC?.navigationController!.viewControllers ?? [] {
                let childName:String = child.className
                if vcName == childName{
                    topVC?.navigationController?.popToViewController(child, animated: true)
                }
            }
        }
    }
    
    //让指定的vc执行某方法
    class func findViewControllerAndResponse(vcName: String, sel: Selector, para: Any?) {
        let topVC = UIViewController.currentViewController()
        
        var responseVC: UIViewController?
//        1.在当前vc的导航栈寻找
        if topVC?.navigationController != nil {
            for child in topVC?.navigationController!.viewControllers ?? [] {
                let childName:String = child.className
                if vcName == childName{
                    responseVC = child
                }
            }
        }
//        2.在presentingViewController的栈寻找
        let presentingVC = topVC?.presentingViewController
        if presentingVC != nil {
            if presentingVC!.isKind(of: UINavigationController.self) {
                for child in (presentingVC! as! UINavigationController).viewControllers {
                    let childName:String = child.className
                    if vcName == childName{
                        responseVC = child
                    }
                }
            }
            
            if presentingVC!.isKind(of: UIViewController.self) {
                if presentingVC!.className == vcName {
                    responseVC = presentingVC!
                }
            }
        }
//        3.找到相应的vc,做响应方法处理
        if responseVC != nil {
            if responseVC!.responds(to: sel) {
                // FIXME: 目前Selector只能单参数,多参数para请传一个字典
                responseVC!.performSelector(onMainThread: sel, with: para, waitUntilDone: false)
            }else{
                Util.printX("\(vcName)未找到对应的方法\(sel)");
            }
        }else{
            Util.printX("未找到对应的\(vcName)")
        }
    }
    
    //  跳转至login
    class func presentToLogin() {
        let topVC = self.currentViewController()
        if let vc = getViewControllerFromStr(vcName: "LoginViewController") {
            topVC?.present(vc, animated: true, completion: nil)
        } else {
            Util.printX("LoginViewController创建失败")
        }
    }
    
    
}
