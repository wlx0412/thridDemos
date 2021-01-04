//
//  WWAdModel.h
//  WoWanAdSDKDemo
//
//  Created by pceggs on 2020/4/23.
//  Copyright © 2020年 lezhen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWAdModel : NSObject

@property (nonatomic, copy)NSString* lid; //流水id
@property (nonatomic, copy)NSString* adorigin; //广告来源  1:飞马移动
@property (nonatomic, copy)NSString* adoriginlogo;//广告来源logo
@property (nonatomic, copy)NSString* adid; //广告ID
@property (nonatomic, copy)NSString* adname;//广告名称
@property (nonatomic, copy)NSString* addesc;//广告描述
@property (nonatomic, copy)NSString* opentype;//打开类型:download(下载),webview(浏览器)
@property (nonatomic, copy)NSString* btntext; //按钮文本
@property (nonatomic, copy)NSString* icon;//图标
@property (nonatomic, copy)NSString* clickurl; //点击链接
@property (nonatomic, copy)NSString* videourl; //视频MP4链接
@property (nonatomic, copy)NSString* videoduration;//视频时长
@property (nonatomic, copy)NSString* videosize;//视频文件大小
@property (nonatomic, copy)NSString* videopreimg;//视频第一帧图片
@property (nonatomic, assign)int videosound; //视频是否需要开启声音 0-关闭 1-开启
@property (nonatomic, assign)int infobardelay;  //底部信息栏延迟弹出时间 单位秒

@property (nonatomic, copy)NSString* opr;//预留字段

@property (nonatomic, copy)NSString* localCachedFilePath;//本地缓存的文件路径

+(AWAdModel*)initWithDictionary:(NSDictionary*)dic;

@end

NS_ASSUME_NONNULL_END
