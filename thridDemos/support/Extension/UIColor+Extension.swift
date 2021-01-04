//
//  MyColor.swift
//  furongbook
//
//  Created by wlx on 2020/11/18.
//

import UIKit

extension UIColor {
    public static var mainTHemeColor: UIColor = UIColor(hexString: "#027aff")

    // Hex String -> UIColor
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
         
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
         
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
         
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
         
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
         
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
     
    // UIColor -> Hex String
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
         
        let multiplier = CGFloat(255.999999)
         
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
         
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
    
    //获取反色(补色)
    func invertColor() -> UIColor {
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: nil)
        return UIColor(red:1.0-r, green: 1.0-g, blue: 1.0-b, alpha: 1)
    }
    
//    func get() -> UIColor {
//        if #available(iOS 13.0, *) {
//            return UIColor.init { (trait) -> UIColor in
//                if trait.userInterfaceStyle == .dark {
//                    return .white
//                }
//                return self
//            }
//        }
//        return self
//    }
    
    public static func randomColor() -> UIColor {
        let r = CGFloat( arc4random()%255 ) / 255.0
        let g = CGFloat( arc4random()%255 ) / 255.0
        let b = CGFloat( arc4random()%255 ) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    public static func backgroundColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground
        } else {
            // Fallback on earlier versions
            return UIColor.white
        }
    }
    
    public static func purpleColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemPurple
        } else {
            // Fallback on earlier versions
            return UIColor.purple
        }
    }
    
    public static func whiteColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground
        } else {
            // Fallback on earlier versions
            return UIColor.white
        }
    }
    
    public static func redColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemRed
        } else {
            // Fallback on earlier versions
            return UIColor.red
        }
    }
    
    public static func labelColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.label
        } else {
            // Fallback on earlier versions
            return UIColor.init(hexString: "#333333")
        }
    }
    
    public static func secondaryLabelColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.secondaryLabel
        } else {
            // Fallback on earlier versions
            return UIColor.init(hexString: "#666666")
        }
    }
    
    public static func tertiaryLabelColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.tertiaryLabel
        } else {
            // Fallback on earlier versions
            return UIColor.init(hexString: "#888888")
        }
    }
    
    public static func quaternaryLabelColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.quaternaryLabel
        } else {
            // Fallback on earlier versions
            return UIColor.init(hexString: "#999999")
        }
    }
    
    public static func placeholderColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.placeholderText
        } else {
            // Fallback on earlier versions
            return UIColor.init(hexString: "#888888")
        }
    }
    
    public static func linkColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.link
        } else {
            // Fallback on earlier versions
            return UIColor.blue
        }
    }
    
}
