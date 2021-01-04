//
//  UILabel+Extension.swift
//  frapp
//
//  Created by fr on 2020/9/30.
//  Copyright © 2020 fr. All rights reserved.
//

import UIKit

extension UILabel {
    class func quickLab(title: String, font: UIFont?, textColor: UIColor? = UIColor.secondaryLabelColor(),_ backgroundColor: UIColor? = UIColor.backgroundColor()) -> UILabel{
        let lab = UILabel()
        lab.font = font
        lab.textColor = textColor
        lab.text = title
        return lab
    }
    
   
}


extension UILabel {
    enum GetSizeType_ENUM: Int {
        case text = 0
        case attributeString
    }
    

    /// 获取label的高度,
    /// - Parameters:
    ///   - type: 计算text 还是attributeText，如果不传则（如果有text的话，优先计算attributeText的height，没有attributeText则计算text的height，如果两个都没有值则返回0）
    ///   - width: width的最大值。如果不传则（自动计算了label 的width，在此之前，需要有label的width约束）
    /// - Returns: 文本实际高度的最大值
    func getLabelHeight(type: GetSizeType_ENUM? = nil, width: CGFloat? = nil) -> CGFloat {
        var w: CGFloat = width ?? -1
        var h: CGFloat = CGFloat.greatestFiniteMagnitude
        if w <= 0 {
            if frame.width == 0 {
                layoutIfNeeded()
            }
            guard frame.width != 0 else {
                Util.printX("🌶🌶🌶： 计算label的height失败，因为其width为0")
                return 0
            }
            w = frame.width
        }
        
        if let attributedText = attributedText, let type = type, type == .attributeString{
            
            h = attributedText.getSize(width: w, height: h).height
        }else if let text = text {
            
            h = text.getLableHeigh(font: font, width: w)
        }else {
            Util.printX("label没有text，或者attribute")
        }
        return h
    }
    
    
    /// 获取label的widht,
    /// - Parameters:
    ///   - type: 计算text 还是attributeText，如果不传则（如果有text的话，优先计算attributeText的width，没有attributeText则计算text的width，如果两个都没有值则返回0）
    ///   - height: 高度的最大值。如果不传则（自动计算了label 的height，在此之前，需要有label的height约束）
    /// - Returns: 文本的宽度最大值
    func getLabelWidth(type: GetSizeType_ENUM? = nil, height: CGFloat? = nil) -> CGFloat {
        var w: CGFloat = CGFloat.greatestFiniteMagnitude
        var h: CGFloat = height ?? -1
        if h <= 0 {
            if frame.width == 0 {
                layoutIfNeeded()
            }
            guard frame.height != 0 else {
                Util.printX("🌶🌶🌶： 计算label的width失败，因为其height为0")
                return 0
            }
            h = frame.height
        }
        
        if let attributedText = attributedText, let type = type, type == .attributeString{
            
            w = attributedText.getSize(width: w, height: h).width
        }else if let text = text {
            
            w = text.getLableWidth(font: font, height: h)
        }else {
            Util.printX("label没有text，或者attribute")
        }
        return w + 1
    }
    
    
    /// 限制最大汉字数
    /// - Parameters:
    ///   - maxCount: 最多显示多少个字
    /// - Returns: label的宽度
    func getLabelWidth(type: GetSizeType_ENUM? = nil, height: CGFloat? = nil, maxCount: Int64) -> CGFloat {
        
        var str = "哈"
        for _ in 0 ..< maxCount {
            str += "哈"
        }
        
        let text = self.text
        let attributedText = self.attributedText
        let textW = getLabelWidth(type: type, height: height)
        
        self.text = str
        let strW = getLabelWidth(height: height)
        
        self.text = text
        self.attributedText = attributedText
        return strW < textW ? strW : textW
    }

}


