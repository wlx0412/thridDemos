//
//  UserDefaults+Extension.swift
//  jujuwan_swift
//
//  Created by wlx on 2020/1/8.
//  Copyright © 2020 furong. All rights reserved.
//

import Foundation

extension UserDefaults {
    // MARK: - 保存自定义对象
    /// - Parameters:
    ///   - obj: 符合NSCoding的自定义对象
    ///   - key: key
    static func setCustomObject(_ obj: NSCoding, key: String) {
        let encode = NSKeyedArchiver.archivedData(withRootObject: obj)
        UserDefaults.standard.setValue(encode, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    /// 获取自定义对象
    /// - Parameter key: key
    static func getCustomObject(_ key: String) -> Any? {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: data)
    }
    
    
    // MARK: - UserDefaults
    /// 保存到UserDefaults
    /// - Parameters:
    ///   - key: 键
    ///   - value: 值
    static func setUserDefaults(with key: String, value: Any) {
        UserDefaults.standard.set(value, forKey: key)
        let result = UserDefaults.standard.synchronize()
        if !result {
            Util.printX("保存失败: key: \(key), value: \(value)")
        }
    }
    
    /// 从UserDefaults获取值
    /// - Parameter key: 键
    static func getUserDefaults(with key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    /// 从UserDefaults移除指定的key
    /// - Parameter key: 键
    static func removeUserDefault(for key: String){
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
    }
    
    /// 删除全部q存放在UserDefaults的数据
    static func clearAllUserDefaultsData(){
        let userDefaults = UserDefaults.standard
        let dics = userDefaults.dictionaryRepresentation()
        for key in dics {
            userDefaults.removeObject(forKey: key.key)
        }
        userDefaults.synchronize()
    }
}
