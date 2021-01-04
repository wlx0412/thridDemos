//
//  Util.swift
//  WLXUtils
//
//  Created by wlx on 2020/11/30.
//

import Foundation


public class Util: NSObject {
    // MARK: -  判断是否在测试环境下
    #if DEBUG
    static let kEnvironment = "Debug"
    /// 是否是debug模式
    static let kIfDebug = true
    #else
    static let kEnvironment = "Release"
    static let kIfDebug = false
    #endif

    //是否是模拟器
    #if targetEnvironment(simulator)
    /// 是否是模拟器
    static let kIfSimulator = true
    #else
    static let kIfSimulator = false
    #endif


    /// 全局打印方法
    /// - Parameters:
    ///   - message: 要打印的msg
    ///   - file: 文件名
    ///   - method: 方法名
    ///   - line: 行数
    static public func printX<T>(_ message: T,
                  file: String = #file,
                  method: String = #function,
                  line: Int = #line) {
        #if DEBUG
            print("\((file as NSString).lastPathComponent)[\(line)], [\(method)]: \(message)")
        #endif
    }
    
    /// 刷新的方式
    public enum PullType: Int {
        case refresh //下拉刷新
        case loadMore //上拉加载更多
    }
    
    
    // MARK: - json相关
    /// JSONString转换为字典
    /// - Parameter jsonString: json字符串
    /// - Returns: 字典?
    func getDictionaryFromJSONString(jsonString:String) -> Dictionary<String, Any>? {
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        return dict as? Dictionary<String, Any>
    }
    
    /// 字典转换为JSONString
    /// - Parameter dictionary: 字典
    /// - Returns: String?
    func getJSONStringFromDictionary(dictionary:Dictionary<String, Any>) -> String? {
       if (!JSONSerialization.isValidJSONObject(dictionary)) {
        Util.printX("无法解析出JSONString")
           return ""
       }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData?
       let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
       return JSONString as? String

    }


    /// JSONString转换为数组
    /// - Parameter jsonString: json字符串
    /// - Returns: Array<Any>?
    func getArrayFromJSONString(jsonString:String) -> Array<Any>? {
        let jsonData:Data = jsonString.data(using: .utf8)!
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
    
        return array as? Array<Any>
    }

    /// 数组转json
    /// - Parameter array: 数组
    /// - Returns: String?
    func getJSONStringFromArray(array:Array<Any>) -> String? {
        if (!JSONSerialization.isValidJSONObject(array)) {
            Util.printX("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: array, options: []) as NSData?
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString as? String
    }

    /// 从字典数组中拿出所有的key组成的数组
    /// - Parameter arr: 字典数组
    func keyArray(arr: [Dictionary<String, Any>]?) -> [String]{
        var titleArr: [String] = []
        if let arr = arr {
            let newArr = arr.map { (dict) -> String in
                return dict.keys.first!
            }
            titleArr = newArr
        }
        return titleArr
    }

    /// 格式化货币数字
    /// - Parameter count: 数字
    func kFormatterNumber<T>(_ count: T) -> String {
        var number: NSNumber = NSNumber(value: 0)
        if let a = count as? Int {
            number = NSNumber(value: a)
        }
        if let b = count as? Double {
            number = NSNumber(value: b)
            
        }
        return String("\(NumberFormatter.localizedString(from: number, number: NumberFormatter.Style.decimal))")
    }



}
