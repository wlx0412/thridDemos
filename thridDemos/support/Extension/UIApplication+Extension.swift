//
//  UIApplication+Extension.swift
//  furongbook
//
//  Created by wlx on 2020/11/17.
//

import UIKit

extension UIApplication {
    public static func mainWindow() -> UIWindow {
        
        return UIApplication.shared.windows.filter({ $0.isKeyWindow }).first!
    }
}
