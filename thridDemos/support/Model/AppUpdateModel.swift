//
//  AppUpdateModel.swift
//  frapp
//
//  Created by fr on 2020/9/16.
//  Copyright © 2020 fr. All rights reserved.
//

import UIKit

//{
//  "code" : 1,
//  "downloadUrl" : "http:\/\/tu2.yiqizhuan.com\/jujuwan.apk",
//  "httpCode" : 200,
//  "id" : null,
//  "timestamp" : 1584351341024,
//  "msg" : "成功",
//  "forceUpgrade" : false,
//  "versionCode" : 148,
//  "data" : {
//    "id" : null,
//    "versionCode" : 148,
//    "forceUpgrade" : false,
//    "downloadUrl" : "http:\/\/tu2.yiqizhuan.com\/jujuwan.apk",
//    "updateMsg" : "日常优化",
//    "versionName" : "2.4.8"
//  },
//  "updateMsg" : "日常优化",
//  "versionName" : "2.4.8"
//}
class AppUpdateModel: NSObject {
    var id: Int?
    var versionCode: Int?
    var forceUpgrade: Bool?
    var downloadUrl: String?
    var updateMsg: String?
    var versionName: String?
    var lastForceUpdateVersion: String? //最后一次强制更新的版本号
}
