//
//  YLPopup.swift
//  YLDatePicker
//
//  Created by Yeonluu on 2018/6/14.
//  Copyright © 2018年 Yeonluu. All rights reserved.
//

import Foundation
import UIKit

typealias VoidBlock = (()->Void)
let SCREEN_WIDTH = Double(UIScreen.main.bounds.size.width)
let SCREEN_HEIGHT = Double(UIScreen.main.bounds.size.height)

class YLPopup: NSObject {
    
    enum PopupShowType {
        case fromBottom
        case fromCenter
    }
    
    // 弹出动画时间
    public let PopAnimationDuration = 0.3
    // 显示方式
    public var showType: PopupShowType = .fromBottom {
        didSet {
            if showType == .fromBottom {
                viewWidth = SCREEN_WIDTH
                self.mainView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: viewWidth, height: self.viewHeight)
                self.mainView.layer.cornerRadius = 0
            }
            else {
                viewWidth = SCREEN_WIDTH-40
                self.mainView.frame = CGRect(x: 20, y: (SCREEN_HEIGHT-viewHeight)/2, width: viewWidth, height: self.viewHeight)
                self.mainView.layer.cornerRadius = 8
            }
            layoutSubviews()
        }
    }
    
    public func layoutSubviews() {
        self.toolbar.frame = CGRect(x: 0, y: 0, width: viewWidth, height: self.toolbarHeight)
        self.contentView.frame = CGRect(x: 0, y: self.toolbarHeight, width: viewWidth, height: self.contentHeight)
    }
    
    // 确定事件
    public var confirmBlock: ((YLPopup) -> (Bool))?
    // 取消事件
    public var cancelBlock: VoidBlock?
    // 消失时间
    public var dismissBlock: VoidBlock?
    // 显示完成事件
    public var showCompletionBlock: VoidBlock?
    // 工具栏高度
    public var toolbarHeight = 44.0
    // 内容视图高度
    public var contentHeight = 216.0 + (SCREEN_HEIGHT >= 812 ? 34.0 : 0.0)
    public var title: String? {
        didSet {
            (self.titleButtonItem.customView as? UIButton)?.setTitle(title, for: .normal)
        }
    }
    // 所点击的IndexPath
    public var fromIndexPath: IndexPath?
    // 主题色
//    public var tintColor: UIColor = UIColor(red: 0, green: 167/255, blue: 225/255, alpha: 1)
    public var tintColor: UIColor = UIColor.backgroundColor()
    
    private(set) var isShow = false
    private var viewWidth = SCREEN_WIDTH
    private var viewHeight: Double {
        return toolbarHeight + contentHeight
    }
    
    // MARK: Init
    override init() {
        super.init()
        setup()
    }
    
    init(title: String) {
        super.init()
        setup()
        (self.titleButtonItem.customView as? UIButton)?.setTitle(title, for: .normal)
    }
    
    func setup() {
        
    }
    
    // MARK: Action
    @objc func showView() {
        if isShow {
            return
        }
        isShow = true
        let window = UIApplication.shared.windows.last
        if let window = window {
            window.addSubview(maskView)
        }
        
        if showType == .fromBottom {
            UIView.animate(withDuration: 0.3, animations: {
                self.mainView.transform = CGAffineTransform(translationX: 0, y: -CGFloat(self.viewHeight))
            }) { (_) in
                
            }
        }
        else {
            let animation = CAKeyframeAnimation(keyPath: "transform")
              animation.duration = PopAnimationDuration
              animation.values = [NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)), NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))]
              self.mainView.layer.add(animation, forKey: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+PopAnimationDuration) { [weak self] in
            if let showCompletionBlock = self?.showCompletionBlock {
                showCompletionBlock()
            }
        }
    }

    func hideView() {
        dismissAction()
    }
    
    private func dismissAction() {
        
        isShow = false
        UIView.animate(withDuration: 0.3, animations: {
            self.maskView.alpha = 0
            self.mainView.transform = .identity

        }) { finished in
            self.maskView.alpha = 1
            self.maskView.backgroundColor = UIColor(white: 0, alpha: 0.4)
            self.maskView.removeFromSuperview()
        }
        if let dismissBlock = dismissBlock {
            dismissBlock()
        }
    }
    
    @objc func confirmAction() {
        if let confirmBlock = confirmBlock {
            if confirmBlock(self) {
                hideView()
            }
        }
        else {
            hideView()
        }
    }
    
    @objc func cancelAction() {
        if let cancelBlock = cancelBlock {
            cancelBlock()
        }
        hideView()
    }
    
    @objc func touchAction() {
        hideView()
    }
    
    // MARK: Getter View
    private lazy var maskView: UIControl! = {
        let maskView = UIControl(frame: UIScreen.main.bounds)
        maskView.addTarget(self, action: #selector(touchAction), for: .touchUpInside)
        maskView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        maskView.addSubview(mainView)
        return maskView
    }()
    
    private(set) lazy var mainView: UIView! = {
        let mainView = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: viewWidth, height: self.viewHeight))
        mainView.clipsToBounds = true
        mainView.backgroundColor = .white
        mainView.transform = .identity
        mainView.addSubview(toolbar)
        mainView.addSubview(contentView)
        return mainView
    }()
    
    private lazy var toolbar: UIToolbar! = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: viewWidth, height: self.toolbarHeight))
        // toolbar.barStyle = .blackTranslucent
        toolbar.isTranslucent = true
//        toolbar.tintColor = .white
        toolbar.setBackgroundImage(UIImage.imageWithColor(tintColor), forToolbarPosition: .any, barMetrics: .default)
        
        var items: [UIBarButtonItem] = []
        let flexSpace = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        items.append(self.cancelButtonItem)
        items.append(flexSpace)
//        items.append(self.titleButtonItem)
//        items.append(flexSpace)
        items.append(self.confirmButtonItem)
        toolbar.setItems(items, animated: false)
        return toolbar
    }()
    
    private(set) lazy var contentView: UIView! = {
        let contentView = UIView(frame: CGRect(x: 0, y: self.toolbarHeight, width: viewWidth, height: self.contentHeight))
        return contentView
    }()
    
    private lazy var titleButtonItem: UIBarButtonItem = {
        let titleButton = UIButton.init(type: .custom)
        titleButton.setTitle(self.title, for: .normal)
        titleButton.titleLabel?.textColor = .white
        titleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        titleButton.titleLabel?.textAlignment = .center
        titleButton.frame = CGRect(x: 0, y: 0, width: 170, height: self.toolbarHeight)
        return UIBarButtonItem.init(customView: titleButton)
    }()
    
    private lazy var confirmButtonItem = self.barButtonItemWith(title: "确定", action: #selector(confirmAction), adjustment: UIOffset(horizontal: -10, vertical: 0))!
    
    private lazy var cancelButtonItem = self.barButtonItemWith(title: "取消", action: #selector(cancelAction), adjustment: UIOffset(horizontal: 10, vertical: 0))!
    
    private func barButtonItemWith(title: String?, action: Selector?,  adjustment: UIOffset = .zero) -> UIBarButtonItem! {
        let item = UIBarButtonItem.init(title: title, style: .plain, target: self, action: action)
        item.setTitlePositionAdjustment(adjustment, for: .default)
//        item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.red], for: .normal)
        return item
    }
}
