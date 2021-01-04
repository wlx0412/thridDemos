//
//  Banner.swift
//  jujuwan_swift
//
//  Created by wlx on 2019/12/26.
//  Copyright © 2019 furong. All rights reserved.
//

import UIKit
import HandyJSON
import IGListKit

//{
//  "bannerdesc" : "",
//  "bannerTypeName" : null,
//  "imgurl" : "https:\/\/tu2.yiqizhuan.com\/HomePage\/20191220134523棋牌vip手机首页和游戏大厅banner.png",
//  "offtime" : "2020-01-21 12:49:57",
//  "ontime" : "2019-12-20 12:49:57",
//  "id" : 265,
//  "taskid" : 0,
//  "bannertype" : 11,
//  "appTaskId" : 0,
//  "imgnav" : "jjw.WebActivity",
//  "sortnum" : null,
//  "logintype" : 0,
//  "jumplink" : "https:\/\/www.jujuwan.com\/gamevipdec\/index",
//  "apptaskid" : 0
//},

class Banner: NSObject,HandyJSON {
    var bannerdesc: String?
    var imgurl: String?
    var offtime: String?
    var ontime: String?
    var jumplink: String?
    var bId: Int?
    var imgnav: String?
    var logintype: Int?
    var appTaskId: Int?

    required override init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
        self.bId <-- "id"
    }
}

extension Banner: ListDiffable{
    func diffIdentifier() -> NSObjectProtocol {
        return NSNumber(value: self.bId!)
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self.imgurl == (object as! Banner).imgurl
    }
    
    
}

