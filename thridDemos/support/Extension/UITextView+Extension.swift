//
//  UITextView+Extension.swift
//  jujuwan_swift
//
//  Created by wlx on 2020/1/13.
//  Copyright © 2020 furong. All rights reserved.
//

import UIKit

class PlaceholderTextView: UITextView {
    public var maxCount = 100 //最大长度
    static let defaultPlaceholderColor: UIColor = {
//        let textField = UITextField.init()
//        textField.placeholder = " "
//        let color = textField.value(forKeyPath: "_placeholderLabel.textColor") as! UIColor
//        return color
        return UIColor.tertiaryLabelColor()
    }()
    
    private var needsUpdateFont = false
    
    static let observingKeys = ["attributedText", "bounds", "font", "frame", "text", "textAlignment", "textContainerInset"]
    
    var placeholder: String = "" {
        didSet {
            self.placeHolderTextView.text = placeholder
            self.updatePlaceholderTextView()
        }
    }
    
    var attributedPlaceholder: NSAttributedString = NSAttributedString() {
        didSet {
            self.placeHolderTextView.attributedText = attributedPlaceholder
            self.updatePlaceholderTextView()
        }
    }
    
    var placeholderColor: UIColor {
        set {
            self.placeHolderTextView.textColor = newValue
        }
        get {
            return self.placeHolderTextView.textColor ?? PlaceholderTextView.defaultPlaceholderColor
        }
    }
    
    private lazy var placeHolderTextView: UITextView = {
        
        var onceCode: UITextView = {
            let temp = UITextView()
            temp.textColor = PlaceholderTextView.defaultPlaceholderColor
            temp.isUserInteractionEnabled = false
            self.needsUpdateFont = true
//            self.updatePlaceholderTextView()
            self.needsUpdateFont = false
            
            NotificationCenter.default.addObserver(self, selector: #selector(updatePlaceholderTextView), name: UITextView.textDidChangeNotification, object: self)
            
            for  key in PlaceholderTextView.observingKeys {
                self.addObserver(self, forKeyPath: key, options: NSKeyValueObservingOptions.new, context: nil)
            }
            
            return temp
        }()
        
      return onceCode
    }()
    
    lazy var countLab: UILabel = {
        let temp = UILabel()
        temp.text = "0/\(maxCount)"
        temp.textAlignment = .right
        self.insertSubview(temp, at: 0)
        temp.textColor = UIColor.secondaryLabelColor()
       return temp
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.updatePlaceholderTextView()
    }
    
    @objc private func updatePlaceholderTextView() {
        let count = (self.text?.count ?? 0)
        if count != 0{
            self.placeHolderTextView.removeFromSuperview()
            if count > maxCount {
                self.countLab.text = "\(maxCount)/\(maxCount)"
                //禁止输入
//                let textVStr = self.text;
//                let str = textVStr?.stringCut(end: maxCount)
//                self.text = str;
            }else {
                self.countLab.text = "\(count)/\(maxCount)"
                self.countLab.textColor = UIColor.lightGray
            }
        }else {
            self.insertSubview(placeHolderTextView, at: 0)
             self.countLab.text = "0/\(maxCount)"
        }
        
        if self.needsUpdateFont {
            self.placeHolderTextView.font = self.font
            self.needsUpdateFont = false
        }
        self.placeHolderTextView.textAlignment = self.textAlignment
        self.placeHolderTextView.backgroundColor = UIColor.clear
        self.placeHolderTextView.textContainer.exclusionPaths = self.textContainer.exclusionPaths
        self.placeHolderTextView.textContainerInset = self.textContainerInset
        self.placeHolderTextView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height-25)
        let size = self.bounds.size.height >= self.contentSize.height ? self.bounds.size : self.contentSize
        self.countLab.frame = CGRect.init(x: 0, y: size.height-25, width: size.width, height: 25)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        PlaceholderTextView.observingKeys.forEach{ (key) in
            self.removeObserver(self, forKeyPath: key)
        }
    }
}

extension PlaceholderTextView : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == ""{
            return true
        }
        if textView.text.length >= maxCount {
            return false
        }
        return true
    }
}
