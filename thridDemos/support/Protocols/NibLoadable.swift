//
//  NibLoadable.swift
//  furongbook
//
//  Created by wlx on 2020/10/31.
//  Copyright © 2020 furong. All rights reserved.
//

import UIKit

// 协议
protocol NibLoadable {
    // 具体实现写到extension内
}

// 默认实现加载nib
extension NibLoadable where Self : UIView {
    static func loadFromNib(_ nibname : String? = nil) -> Self {
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}
