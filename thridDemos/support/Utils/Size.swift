//
//  Size.swift
//  WLXUtils
//
//  Created by wlx on 2020/11/17.
//

import Foundation
import SwiftyFitsize

public struct Size {
    /// 屏幕尺寸
    public static var screenBounds = UIScreen.main.bounds
    /// 屏幕大小
    public static var screenSize = screenBounds.size
    /// 屏幕宽
    public static var screenWidth = screenBounds.size.width
    /// 屏幕高
    public static var screenHeight = screenBounds.size.height
    /// size大小8~30
    public static var size8: CGFloat = 10.0
    public static var size10: CGFloat = 10.0
    public static var size12: CGFloat = 12.0
    public static var size14: CGFloat = 12.0
    public static var size16: CGFloat = 16.0
    public static var size18: CGFloat = 18.0
    public static var size20: CGFloat = 20.0
    public static var size22: CGFloat = 20.0
    public static var size25: CGFloat = 25.0
    public static var size30: CGFloat = 30.0
    
    /// 是否是iPhone X
    /// - Returns: true是    false否
    public static func isIphoneX() -> Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.mainWindow().safeAreaInsets.bottom
            return bottom > 0
        } else {
            return false
        }
    }
    

    /// 底部安全距离
    /// - Returns: iPhone X以前是0,之后是34
    public static func bottomSafeOffset() -> CGFloat {
        return isIphoneX() == true ? 34 : 0
    }
    
    /// 状态栏高度
    /// - Returns: iPhone X之前是20,之后是44(注意: iOS14 在iPhone 12上高度有小幅度变化)
    public static func statusBarHeight() -> CGFloat {
        var statusHeight: CGFloat  = 0.0
        if #available(iOS 13, *) {
            statusHeight = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 0
        } else {
            statusHeight = UIApplication.shared.statusBarFrame.size.height
        }
        return statusHeight
    }
    
    /// 导航栏高度
    /// - Returns: iPhone X之前是64,之后是88+
    public static func navHeight() -> CGFloat {
        return statusBarHeight() + 44
    }
    

    /// 底部标签栏高度
    /// - Returns: iPhone X之前是49,之后是83
    public static func tabbarHeiht() -> CGFloat {
        return isIphoneX() ? 83 : 49
    }
    

    /// 去掉导航栏后的高度
    /// - Returns: CGFloat
    public static func mainViewWithoutNavHeight() -> CGFloat {
        return screenHeight - navHeight()
    }
    
    /// 以iPhone 6为参照
    static public let kWidthRatio = screenWidth/375.0
    static public let kHeightRatio = screenHeight/667.0
    
    /// 自适应宽度
    /// - Parameter width: 以iPhone 6为参照的宽度
    /// - Returns: CGFloat
    static public func kAdaptWidth(_ width: CGFloat) -> CGFloat {
    //    return ceil(width) * kWidthRatio
        return width~
    }

    /// 自适应高度
    /// - Parameter width: 以iPhone 6为参照的高度
    /// - Returns: CGFloat
    static public func kAdaptHeight(_ height: CGFloat) -> CGFloat {
    //    return ceil(height) * kWidthRatio
        return height~
    }
    
    /// 自适应大小
    /// - Parameter size: 以iPhone 6为参照的大小
    /// - Returns: CGSize
    static public func kAdaptSize(size: CGSize) -> CGSize {
        return size~
    }
    
    /// 自适应rect
    /// - Parameter rect: 以iPhone 6为参照的rect
    /// - Returns: CGRect
    static public func kAdaptRect(rect: CGRect) -> CGRect {
        return rect~
    }
}
