//
//  LzLittleGame.h
//  WoWanSDK
//
//  Created by pceggs on 2020/3/17.
//  Copyright © 2020年 lezhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

#import "LzGameUserModel.h"
#import "LzGameAdConfig.h"
#import "LzGameModel.h"

NS_ASSUME_NONNULL_BEGIN


/*****代理****/
@protocol LzLittleGameDelegate<NSObject>

@optional

//游戏点击进入回调
- (void)gameClickCallBack:(NSString *)gameid GameName:(NSString *)gamename;

//游戏体验时长回调
- (void)gamePlayTimeCallCallBack:(NSString *)gameid GameName:(NSString *)gamename GameType:(int)gametype PlayTime:(NSInteger)playseconds;

@end
/*****代理****/



@interface LzLittleGame : NSObject

typedef enum
{
    LzLittleGameType_TIME,
    LzLittleGameType_Rank,
    LzLittleGameType_REWARD
} LzLittleGameType;


+ (LzLittleGame *)getInstance;

@property (nonatomic, weak, nullable) id <LzLittleGameDelegate> delegate;

//初始化SDK
-(void)launchLGSDK:(NSString *)appid AppSecret:(NSString *)appsecret User:(LzGameUserModel *)userModel;
//设置广告配置
-(void)setAdConfig:(LzGameAdConfig *)adConfig;
//是否隐藏游戏结束时候确认退出dialog
-(void)setHideFinishGameDialog:(BOOL)_hide;
//是否开启控制台日志打印
-(void)setDebugLog:(BOOL)_debug;

//打开小游戏列表页
-(void)openGameListFromViewController:(UIViewController *)fromViewController;

//获取游戏列表数据源
-(void)getGameListData:(LzLittleGameType)gameType Complete:(void (^)(int status, NSArray<LzGameModel *> *games, NSString *msg))complete;

//直接打开单个小游戏
-(void)openGameByGid:(NSString *)gid FromViewController:(UIViewController *)fromViewController;

//直接打开单个小游戏介绍页面
-(void)openGameIntroPageByGid:(NSString *)gid FromViewController:(UIViewController *)fromViewController;

//获取sdk版本号
-(NSString *)getSDKVersion;

@end


NS_ASSUME_NONNULL_END
