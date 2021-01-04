//
//  UIResponser+Extension.swift
//  jujuwan_swift
//
//  Created by wlx on 2020/2/22.
//  Copyright © 2020 furong. All rights reserved.
//

import UIKit

extension UIResponder {
    @objc func routerEventWithName(name: String, userInfo: Dictionary<String, Any>?) {
        self.next?.routerEventWithName(name: name, userInfo: userInfo)
    }
}
