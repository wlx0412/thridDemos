//
//  Array+Extension.swift
//  jujuwan_swift
//
//  Created by wlx on 2020/5/21.
//  Copyright © 2020 furong. All rights reserved.
//

import Foundation

extension Array {
    // 防止数组越界
    subscript(index: Int, safe: Bool) -> Element? {
        if safe {
            if self.count > index {
                return self[index]
            }
            else {
                return nil
            }
        }
        else {
            return self[index]
        }
    }
}
