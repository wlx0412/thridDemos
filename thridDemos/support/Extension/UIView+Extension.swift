//
//  UIView+Extension.swift
//  frapp
//
//  Created by fr on 2020/9/3.
//  Copyright © 2020 fr. All rights reserved.
//

import UIKit

extension UIView {
    /// 设置圆角
    /// - Parameters:
    ///   - radius: 圆角大小
    ///   - color: 颜色
    func setBorder( radius: CGFloat,_ color: UIColor? = nil, _ borderWidth: CGFloat? = 1) {
           self.layer.masksToBounds = true
           self.layer.cornerRadius = radius
           if let v = color {
               self.layer.borderColor = v.cgColor
               self.layer.borderWidth = borderWidth!
           }
       }
    
    
    /// 设置渐变颜色
    /// - Parameters:
    ///   - cgColor1: 开始颜色
    ///   - cgColor2: 结束颜色
    ///   - corderRadius: 圆角大小
    func setGradientBgColor(_ color1: UIColor, _ color2: UIColor, _ corderRadius: CGFloat? = nil, _ frame: CGRect? = nil,_ type: Int? = 1) {
        let colors = [color1.cgColor, color2.cgColor]
        let layer = CAGradientLayer()
        layer.locations = [0.0, 0.5]
        layer.colors = colors
        if type == 1 { //左右渐变
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 1, y: 0)
        }else if type == 2 {//上下渐变
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 0, y: 1)
        }
        
        layer.frame = Size.kAdaptRect(rect: self.bounds)
        if let f = frame {
            layer.frame = f
        }
        if let corner = corderRadius {
            layer.cornerRadius = corner
            layer.masksToBounds = true
        }
        self.layer.insertSublayer(layer, at: 0)
    }
    
    /// 设置阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - offset: 偏移 默认(0, -3)
    ///   - opacity: 透明度 默认0
    ///   - radius: 阴影半径 默认3
    func setShadow(color: UIColor?,_ offset: CGSize? = CGSize(width: 0, height: -3),_ opacity: Float? = 0,_ radius: CGFloat? = 3,_ cornerRadius: CGFloat? = Size.kAdaptWidth(4)){
        self.layer.shadowColor = color?.cgColor
        
        if let off = offset {
            self.layer.shadowOffset = off
        }
        
        if let op = opacity {
            self.layer.shadowOpacity = op
        }
        
        if let r = radius {
            self.layer.shadowRadius = r
        }
        
        if let corner = cornerRadius {
            self.layer.cornerRadius = corner
        }
    }
}
