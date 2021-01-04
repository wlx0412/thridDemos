//
//  RandomCodeView.swift
//  swiftTest
//
//  Created by wlx on 2020/5/18.
//  Copyright © 2020 furong. All rights reserved.
//  随机验证码

import UIKit

class RandomCodeView: UIView {

    var lineCount = 4 //干扰线的个数
    var lineWidth: CGFloat = 1 //干扰线宽度
    var numberCount = 4 //生成的数字个数
    var fontSize:CGFloat = 14 //数字的字体大小
    var randomStr: String = "" //生成的随机字符串
    
    private var numberArray:[Int] {
        get {
            var arr:[Int] = []
            for _ in 0..<numberCount {
                arr.append(Int(arc4random() % 10))
            }
            return arr
        }
    }
    
    var randomblock: ((String) -> Void)? //回调,获取生成的随机串
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func randomColor() -> UIColor {
        return UIColor(red: CGFloat(Double(arc4random() % 255)/255.0), green: CGFloat(Double(arc4random() % 255)/255.0), blue: CGFloat(Double(arc4random() % 255)/255.0), alpha: 1.0)
    }
    
    /// 刷新方法
    func change(){
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let itemWidth = (rect.width / CGFloat(numberArray.count))
        randomStr = ""
        for (index,i) in numberArray.enumerated() {
            let x = CGFloat( index ) * itemWidth + (itemWidth - fontSize)/2
            let y:CGFloat = CGFloat(arc4random() % UInt32((rect.height - fontSize)))
            
            let str:String = "\(i)"
            randomStr += str
            srand48(Int(time(nil)))
            
            (str as NSString).draw(at:  CGPoint(x: x, y: y), withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize), NSAttributedString.Key.foregroundColor: randomColor(), NSAttributedString.Key.obliqueness: drand48() - 0.5])
        }
        
        randomblock?(randomStr)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(lineWidth)
        for _ in 0..<lineCount {
            context?.setStrokeColor(randomColor().cgColor)
            
            let startX = Int( arc4random() % UInt32(rect.width))
            let startY = Int(arc4random() % UInt32(rect.height))
            context?.move(to: CGPoint(x: startX, y: startY))
            
            let endX = Int( arc4random() % UInt32(rect.width)) + 10
            let endY = Int(arc4random() % UInt32(rect.height)) + 10
            context?.addLine(to: CGPoint(x: endX, y: endY))
            
            context?.strokePath()
        }
    }
}
