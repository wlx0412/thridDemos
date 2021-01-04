//
//  AWRewardVideoAd.h
//  WoWanAdSDKDemo
//
//  Created by pceggs on 2020/4/24.
//  Copyright © 2020年 lezhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "AWVideoAdPlayerVC.h"

@class AWRewardVideoAd;

NS_ASSUME_NONNULL_BEGIN


/*
 * 广告代理回调
 */
@protocol AWRewardVideoAdDelegate <NSObject>

//广告加载成功
- (void)rewardVideoAdDidLoad:(AWRewardVideoAd *) rewardVideoAd;

//广告加载失败
- (void)rewardVideoAd:(AWRewardVideoAd *) rewardVideoAd didFailWithError:(NSError *)error;

//广告视频加载成功
- (void)rewardVideoAdVideoDidLoad:(AWRewardVideoAd *) rewardVideoAd;

//广告开始播放
- (void)rewardVideoAdDidPlayStart:(AWRewardVideoAd *) rewardVideoAd;

//广告播放完成
- (void)rewardVideoAdDidPlayFinish:(AWRewardVideoAd *) rewardVideoAd;

//广告播放失败
- (void)rewardVideoAd:(AWRewardVideoAd *) rewardVideoAd didPlayFail:(NSError *)error;

//广告点击
- (void)rewardVideoAdDidClick:(AWRewardVideoAd *) rewardVideoAd;

//广告关闭
- (void)rewardVideoAdDidClose:(AWRewardVideoAd *) rewardVideoAd;

@end



@interface AWRewardVideoAd : NSObject<AWVideoAdDelegate,NSURLSessionDelegate>

@property (nonatomic, weak, nullable)id<AWRewardVideoAdDelegate> delegate; //声明协议变量

//广告是否已准备好可用
@property (nonatomic, assign, readonly) BOOL adValid;

//初始化
-(instancetype)initWithPlaceId:(NSString *)placeid InViewController:(UIViewController *)vc Orientation:(AWAdOrientationType)orientationType;

//加载激励视频广告
-(void)loadAd;

//显示激励视频
-(void)showAd;

@end




NS_ASSUME_NONNULL_END
