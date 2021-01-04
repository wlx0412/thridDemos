//
//  UIButton+Extension.swift
//  frapp
//
//  Created by fr on 2020/9/24.
//  Copyright © 2020 fr. All rights reserved.
//  1.把btn的按钮事件用block表示
//  2.修改btn图片按钮的位置

import UIKit

typealias BtnAction = (UIButton)->()

extension UIButton{

/// 给 button 添加一个属性 用于记录点击tag
    private struct AssociatedKeys{
      static var actionKey = "actionKey"
    }

    @objc dynamic var actionDic: NSMutableDictionary? {
        set{
            objc_setAssociatedObject(self,&AssociatedKeys.actionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get{
            if let dic = objc_getAssociatedObject(self, &AssociatedKeys.actionKey) as? NSDictionary{
                return NSMutableDictionary.init(dictionary: dic)
            }
            return nil
        }
    }

    @objc dynamic fileprivate func DIY_button_add(action:@escaping  BtnAction ,for controlEvents: UIControl.Event) {
        let eventStr = NSString.init(string: String.init(describing: controlEvents.rawValue))
        if let actions = self.actionDic {
            actions.setObject(action, forKey: eventStr)
            self.actionDic = actions
        }else{
            self.actionDic = NSMutableDictionary.init(object: action, forKey: eventStr)
        }
        
        switch controlEvents {
            case .touchUpInside:
                self.addTarget(self, action: #selector(touchUpInSideBtnAction), for: .touchUpInside)
            case .touchUpOutside:
                self.addTarget(self, action: #selector(touchUpOutsideBtnAction), for: .touchUpOutside)
        default:
            self.addTarget(self, action: #selector(touchUpInSideBtnAction), for: .touchUpInside)
        }
      }

    @objc fileprivate func touchUpInSideBtnAction(btn: UIButton) {
      if let actionDic = self.actionDic  {
        if let touchUpInSideAction = actionDic.object(forKey: String.init(describing: UIControl.Event.touchUpInside.rawValue)) as? BtnAction{
              touchUpInSideAction(self)
           }
      }
    }

    @objc fileprivate func touchUpOutsideBtnAction(btn: UIButton){
     if let actionDic = self.actionDic  {
        if let touchUpOutsideBtnAction = actionDic.object(forKey:   String.init(describing: UIControl.Event.touchUpOutside.rawValue)) as? BtnAction{
            touchUpOutsideBtnAction(self)
        }
     }
    }

    @discardableResult
    func addTouchUpInSideBtnAction(_ action:@escaping BtnAction) -> UIButton{
        self.DIY_button_add(action: action, for: .touchUpInside)
        return self
    }
    @discardableResult
    func addTouchUpOutSideBtnAction(_ action:@escaping BtnAction) -> UIButton{
            self.DIY_button_add(action: action, for: .touchUpOutside)
           return self
    }
    
    class func quickBtn(_ title: String? = nil,_ img: String? = nil,_ titleColor: UIColor? = UIColor.labelColor(),_ titleFont: UIFont? = UIFont.font14,_ action: ((UIButton) -> Void)? = nil) -> UIButton {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        if let titleStr = title {
             btn.setTitle(titleStr, for: UIControl.State.normal)
        }
       
        btn.setTitleColor(titleColor, for: UIControl.State.normal)
        if let imgStr = img {
            btn.setImage(UIImage(named: imgStr), for: UIControl.State.normal)
        }
        btn.titleLabel?.font = titleFont
        btn.addTouchUpInSideBtnAction { (btn) in
            if let touch = action {
                touch(btn)
            }
        }
        return btn
    }
}

enum ButtonEdgeInsetsStyle {
   case ButtonEdgeInsetsStyleTop // image在上，label在下
   case ButtonEdgeInsetsStyleLeft  // image在左，label在右
   case ButtonEdgeInsetsStyleBottom  // image在下，label在上
   case ButtonEdgeInsetsStyleRight // image在右，label在左
}

extension UIButton {
    func layoutButtonEdgeInsets(style:ButtonEdgeInsetsStyle,space:CGFloat) {
      var labelWidth : CGFloat = 0.0
      var labelHeight : CGFloat = 0.0
        var imageEdgeInset = UIEdgeInsets.zero
        var labelEdgeInset = UIEdgeInsets.zero
      let imageWith = self.imageView?.frame.size.width
      let imageHeight = self.imageView?.frame.size.height
      labelWidth = (self.titleLabel?.frame.size.width)!
      labelHeight = (self.titleLabel?.frame.size.height)!
      
      switch style {
      case .ButtonEdgeInsetsStyleTop:
        imageEdgeInset = UIEdgeInsets(top: -labelHeight-space/2.0, left: 0, bottom: 0, right: -labelWidth)
        labelEdgeInset = UIEdgeInsets(top: 0, left: -imageWith!, bottom: -imageHeight!-space/2.0, right: 0)
      case .ButtonEdgeInsetsStyleLeft:
        imageEdgeInset = UIEdgeInsets(top: 0, left: -space/2.0, bottom: 0, right: space/2.0);
        labelEdgeInset = UIEdgeInsets(top: 0, left: space/2.0, bottom: 0, right: -space/2.0);
      case .ButtonEdgeInsetsStyleBottom:
        imageEdgeInset = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight-space/2.0, right: -labelWidth)
        labelEdgeInset = UIEdgeInsets(top: -imageHeight!-space/2.0, left: -imageWith!, bottom: 0, right: 0)
      case .ButtonEdgeInsetsStyleRight:
          // To Do Util.printX("坐标是====\(labelWidth)=====\(space)")
        imageEdgeInset = UIEdgeInsets(top: 0, left: labelWidth+space/2.0, bottom: 0, right: -labelWidth-space/2.0)
        labelEdgeInset = UIEdgeInsets(top: 0, left: -imageWith!-space/2.0, bottom: 0, right: imageWith!+space/2.0)
      }
      self.titleEdgeInsets = labelEdgeInset
      self.imageEdgeInsets = imageEdgeInset
  }
}
