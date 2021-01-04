//
//  NSObject+Extension.swift
//  jujuwan_swift
//
//  Created by wlx on 2020/6/16.
//  Copyright © 2020 furong. All rights reserved.
//

import Foundation

extension NSObject {
    public func printKeyValues() {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            Util.printX("\(child.label ?? "") : \(child.value)")
        }
    }
    
    public func printX(file: String = #file,
                       method: String = #function,
                       line: Int = #line,
                       _ args: Any...) -> Void {
        Util.printX(args, file: file, method: method, line: line)
    }
}


extension NSObject {
    private struct AssociatedKeys {
        static var identifierKey = "fr_identifier"
    }
    
    /// 获取类名字符串
    var className:String {
        get {
            let name =  type(of: self).description()
            if(name.contains(".")){
                return name.components(separatedBy: ".")[1];
            }else{
                return name;
            }
        }
    }
    
    /// 添加存储属性: UIViewController的标志
    var identifier: String {
        get {
            if let rs = objc_getAssociatedObject(self, &AssociatedKeys.identifierKey) as? String {
                return rs
            }
            return self.className
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.identifierKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    class func printIvars() {
//        利用运行时获取类里面的成员变量
        var outCount: UInt32 = 0
//        ivars实际上是一个数组
        let ivars = class_copyIvarList(self, &outCount)!
//        获取里面的每一个元素
        for i in 0..<outCount
        {
//            ivar是一个结构体的指针
            let ivar = ivars[Int(i)]
//          获取 成员变量的名称,cName c语言的字符串,首元素地址
            let cName = ivar_getName(ivar)!
            let name = String(cString: cName, encoding: String.Encoding.utf8)
            Util.printX("name: \(name ?? "name")")
        }
//        方法中有copy,create,的都需要释放
        free(ivars)
    }
}


//秒
extension DispatchTime: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}

//毫秒
extension DispatchTime: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}


//自定义字典的合并
extension Dictionary {
    mutating func merge<S>(_ other: S)
        where S: Sequence, S.Iterator.Element == (key: Key, value: Value){
            for (k ,v) in other {
                self[k] = v
        }
    }
}

//实现dispatch_once(swift3废弃)的swift版
extension DispatchQueue {
    private static var onceToken = [String]()
    
    /// swift 实现dispatch_once
    /// - Parameters:
    ///   - token: 根据token区分是否要执行
    ///   - block: 回到
    static func once(token: String = "\(#file):\(#function):\(#line)", block: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        
        if onceToken.contains(token) {
            return
        }
        onceToken.append(token)
        block()
    }
}


//图片格式
enum ImageFormat:NSInteger {
    case JPEG = 0
    case PNG = 1
    case GIF = 2
    case TIFF = 3
    case WebP = 4
    case HEIC = 5
    case HEIF = 6
    case Unknow = 7
}

extension Data {
    //获取图片类型
    func getImageFormat() -> ImageFormat  {
        var buffer = [UInt8](repeating: 0, count: 1)
        self.copyBytes(to: &buffer, count: 1)
        
        switch buffer {
        case [0xFF]: return .JPEG
        case [0x89]: return .PNG
        case [0x47]: return .GIF
        case [0x49],[0x4D]: return .TIFF
        case [0x52] where self.count >= 12:
            if let str = String(data: self[0...11], encoding: .ascii), str.hasPrefix("RIFF"), str.hasSuffix("WEBP") {
                return .WebP
            }
        case [0x00] where self.count >= 12:
            if let str = String(data: self[8...11], encoding: .ascii) {
                let HEICBitMaps = Set(["heic", "heis", "heix", "hevc", "hevx"])
                if HEICBitMaps.contains(str) {
                    return .HEIC
                }
                let HEIFBitMaps = Set(["mif1", "msf1"])
                if HEIFBitMaps.contains(str) {
                    return .HEIF
                }
            }
        default: break;
        }
        return .Unknow
    }
}


//小数四舍五入和截断
extension Double {
    ///四舍五入 到小数点后某一位
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    ///截断 到小数点后某一位
    func truncate(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Double(Int(self * divisor)) / divisor
    }
}


//随机数
extension Int {
    /*这是一个内置函数
     lower : 内置为 0，可根据自己要获取的随机数进行修改。
     upper : 内置为 UInt32.max 的最大值，这里防止转化越界，造成的崩溃。
     返回的结果： [lower,upper) 之间的半开半闭区间的数。
     */
    /// 随机数
    /// - Parameters:
    ///   - lower: 最小值
    ///   - upper: 最大值
    static func randomIntNumber(lower: Int = 0,upper: Int = Int(UInt32.max)) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower)))
    }
    /**
     生成某个区间的随机数
     - Parameter range: 范围
     */
    static func randomIntNumber(range: Range<Int>) -> Int {
        return randomIntNumber(lower: range.lowerBound, upper: range.upperBound)
    }
}

//获取时间戳
extension Date {
    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    
    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
}

