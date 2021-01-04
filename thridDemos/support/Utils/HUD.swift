//
//  HUD.swift
//  furongbook
//
//  Created by wlx on 2020/11/17.
//

import Foundation
import MBProgressHUD

struct HUD {
    public var hud: MBProgressHUD?
    private init(){}
    
    public static var shared = HUD()
    
    
    public static func show(msg: String, toView: UIView? = nil) {
        DispatchQueue.main.async {
            if shared.hud != nil {
                shared.hud?.hide(animated: true)
            }
            
            let hud: MBProgressHUD = MBProgressHUD.showAdded(to: toView ?? UIApplication.mainWindow(), animated: true)
            hud.mode = .text
            hud.label.text = msg
            shared.hud = hud
            hud.hide(animated: true, afterDelay: 3.0)
        }
    }
    
    public static func loading(msg: String? = nil, toView: UIView? = nil, delay: TimeInterval? = nil){
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: UIApplication.mainWindow(), animated: true)
            hud.label.text = msg
            shared.hud = hud
        }
    }
    
    public static func hideLoading(delay: TimeInterval? = nil){
        if delay == nil {
            shared.hud?.hide(animated: true)
        } else {
            shared.hud?.hide(animated: true, afterDelay: delay!)
        }
    }
}

