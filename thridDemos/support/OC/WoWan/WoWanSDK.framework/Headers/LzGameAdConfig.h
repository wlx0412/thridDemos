//
//  LzGameAdConfig.h
//  WoWanSDKDemo
//
//  Created by pceggs on 2020/3/27.
//  Copyright © 2020年 lezhen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LzGameAdConfig : NSObject<NSCoding>

/** 穿山甲平台 */
//穿山甲横屏激励视屏广告位id
@property (nonatomic, copy)NSString* ttRewardVideo_h_code;
//穿山甲竖屏激励视频广告位id
@property (nonatomic, copy)NSString* ttRewardVideo_v_code;
//穿山甲横屏全屏视频广告位id
@property (nonatomic, copy)NSString* ttFullVideo_h_code;
//穿山甲竖屏全屏视频广告位id
@property (nonatomic, copy)NSString* ttFullVideo_v_code;
//穿山甲插屏广告位id  3：2
@property (nonatomic, copy)NSString* ttNativeCode;
//穿山甲Banner广告位id 640*100
@property (nonatomic, copy)NSString* ttBannerCode;
//游戏结束确认退出弹框上的穿山甲信息流广告id 创建广告id时除视频以外都勾选
@property (nonatomic, copy)NSString* ttGameEndFeedAdId;


/** 广点通平台 */
//广点通平台appid
@property (nonatomic, copy)NSString* gdtAppid;
//广点通插屏广告位id
@property (nonatomic, copy)NSString* gdtNativeCode;
//广点通激励视屏广告位id
@property (nonatomic, copy)NSString* gdtRewardVideoCode;
//广点通全屏视屏广告位id
@property (nonatomic, copy)NSString* gdtFullVideoCode;
//广点通banner广告位id
@property (nonatomic, copy)NSString* gdtBannerCode;
//游戏结束确认退出弹框上的广点通信息流广告id 创建广告id时除视频以外都勾选
@property (nonatomic, copy)NSString* gdtGameEndFeedAdId;


/** 爱玩广告平台 */
//广点通激励视屏广告位id
@property (nonatomic, copy)NSString* awRewardVideoCode;


@end

NS_ASSUME_NONNULL_END
