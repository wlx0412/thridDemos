//
//  UIAlertController+Extension.swift
//  jujuwan_swift
//
//  Created by wlx on 2020/2/12.
//  Copyright © 2020 furong. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(title: String?, message: String?, strs: [String], cancel: Bool, complete: ((Int) -> Void)?) {
        self.init(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        
        if cancel {
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel) {(UIAlertAction) -> Void in
                Util.printX("Tap 取消 Button")
            }
            self.addAction(cancelAction)
        }
        
        for (index,str) in strs.enumerated() {
            let otherAction = UIAlertAction(title: str, style: UIAlertAction.Style.default) {(UIAlertAction) -> Void in
                complete?(index)
            }
            self.addAction(otherAction)
        }
    }
}
