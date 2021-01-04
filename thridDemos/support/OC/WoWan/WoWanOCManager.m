//
//  WoWanOCManager.m
//  jujuwan_swift
//
//  Created by wlx on 2020/5/14.
//  Copyright © 2020 furong. All rights reserved.
//

#import "WoWanOCManager.h"

static WoWanOCManager *manager = nil;

@interface WoWanOCManager()<LzLittleGameDelegate>

@end

@implementation WoWanOCManager

+(instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WoWanOCManager alloc] init];
    });
    return manager;
}

-(void)initSDK:(NSString *)userID name:(NSString *)nickName photo:(NSString *)url{
    //appid：渠道id（我方提供）
    //appsecret：秘钥（我方提供）
    NSString *appid = @"1021";
    NSString *appsecret = @"PmBml4TYBsmJjJCc8C9GRmDPlbsGHq9R";
    
    //用户信息
    LzGameUserModel *userModel = [[LzGameUserModel alloc] init];
    [userModel setUserid:userID]; //用户id    必填
    [userModel setHeadUrl:url]; //用户头像 建议填写，否则排行榜展示不了头像
    [userModel setNickName:nickName]; //用户昵称  建议填写，否则排行榜展示不了昵称
    
    //初始化
    [[LzLittleGame getInstance] launchLGSDK:appid AppSecret:appsecret User:userModel];
    
    //广告配置
    LzGameAdConfig *adConfig = [[LzGameAdConfig alloc] init];
    
    //穿山甲广告位
    //    [adConfig setTtRewardVideo_v_code:@"945135816"]; //竖屏激励视频    必填
    //    [adConfig setTtRewardVideo_h_code:@"945135901"]; //横屏激励视频    必填
    //    [adConfig setTtFullVideo_v_code:@"945101998"];   //竖屏全屏视频    必填
    //    [adConfig setTtFullVideo_h_code:@"945135904"];   //横屏全屏视频    必填
    //    [adConfig setTtNativeCode:@"945136038"]; //插屏 3：2    必填
    //    [adConfig setTtBannerCode:@"945136080"]; //banner    必填
    //    [adConfig setTtGameEndFeedAdId:@"945137264"]; //游戏退出提示对话框上的广告位 信息流，模板选择：上文下图模板、上文下图-附加创意模板、上文下浮层模板、文字浮层模板    必填
    //
    //    //广点通广告位
    //    [adConfig setGdtAppid:@"1105344611"];
    //    [adConfig setGdtRewardVideoCode:@"8020744212936426"];//激励视频    必填
    //    [adConfig setGdtFullVideoCode:@"6050298509489032"];//全屏视频    必填
    //    [adConfig setGdtNativeCode:@"6050298509489032"];//插屏,广告素材:图文，广告样式:大规格    必填
    //    [adConfig setGdtBannerCode:@"1080958885885321"];//banner    必填
    //    [adConfig setGdtGameEndFeedAdId:@"5070791337820394"]; //游戏退出提示对话框上的广告位 信息流，模板选择：纯图片（1280*720）    必填
    
    //爱玩广告位
    [adConfig setAwRewardVideoCode:@"100201"];
    
    [[LzLittleGame getInstance] setAdConfig:adConfig];
    
    //设置代理
    [LzLittleGame getInstance].delegate = self;
    
    //是否隐藏游戏退出时的提示对话框  默认NO
    //[[LzLittleGame getInstance] setHideFinishGameDialog:YES];
    
    //调试时，可设置开启控制台日志输出  默认NO
    //[[LzLittleGame getInstance] setDebugLog:YES];
    
    
    
    //初始化爱玩广告sdk (注意：这里的 appid 和 appsecret 是爱玩广告sdk的，与上面小游戏的并不是同一个)
    [[AWAdSDK getInstance] initSDK:@"11001" AppSecret:@"8f1PuI6l4f22lAyceljeqwcHoXnQTS5w"];
}

-(void)getGameList:(void (^)(NSInteger status, NSArray *list, NSString *msg))block{
    [[LzLittleGame getInstance] getGameListData:LzLittleGameType_TIME Complete:^(int status, NSArray<LzGameModel *> * _Nonnull games, NSString * _Nonnull msg) {
        block(status, games, msg);
    }];
}


-(void)openGame:(NSString *)gameID from:(UIViewController *)vc{
    [LzLittleGame.getInstance openGameByGid:gameID FromViewController:vc];
}


#pragma mark - LzLittleGameDelegate
- (void)gameClickCallBack:(NSString *)gameid GameName:(NSString *)gamename{
    if ([self.delegate respondsToSelector:@selector(gameClickCallBack:GameName:)]) {
        [self.delegate gameClickCallBack:gameid GameName:gamename];
    }
}


- (void)gamePlayTimeCallCallBack:(NSString *)gameid GameName:(NSString *)gamename GameType:(int)gametype PlayTime:(NSInteger)playseconds{
    if ([self.delegate respondsToSelector:@selector(gamePlayTimeCallCallBack:GameName:GameType:PlayTime:)]) {
        [self.delegate gamePlayTimeCallCallBack:gameid GameName:gamename GameType:gametype PlayTime:playseconds];
    }
}

@end
