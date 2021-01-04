//
//  WWAdManager.h
//  WoWanAdSDKDemo
//
//  Created by pceggs on 2020/4/23.
//  Copyright © 2020年 lezhen. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface AWAdSDK : NSObject

+ (AWAdSDK *)getInstance;

//初始化SDK
-(void)initSDK:(NSString *)appid AppSecret:(NSString *)appsecret;

//获取AppID
-(NSString *)getAppId;

//获取密钥
-(NSString *)getAppSecret;

//获取sdk版本号
-(NSString *)getSDKVersion;

//是否开启控制台日志打印
-(void)setDebugLog:(BOOL)_debug;

@end

NS_ASSUME_NONNULL_END
