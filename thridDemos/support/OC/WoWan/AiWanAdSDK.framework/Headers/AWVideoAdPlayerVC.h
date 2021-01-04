//
//  WWVideoAdPlayerVC.h
//  WoWanAdSDKDemo
//
//  Created by pceggs on 2020/4/22.
//  Copyright © 2020年 lezhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWAdModel.h"

NS_ASSUME_NONNULL_BEGIN

//显示方向
typedef NS_ENUM(int, AWAdOrientationType) {
    AWAdOrientationTypeVertical         = 0,  // 竖屏
    AWAdOrientationTypeHorizontal   = 1,  // 横屏
};


@protocol AWVideoAdDelegate <NSObject>

//广告开始播放
- (void)adPlayStart;

//广告播放完成
- (void)adPlayComplete;

//广告播放失败
- (void)adPlayFailWithError:(NSError *_Nullable)error;

//广告点击
- (void)adClick;

//广告关闭
- (void)adClose;

@end


@interface AWVideoAdPlayerVC : UIViewController 

@property (nonatomic, weak, nullable)id<AWVideoAdDelegate> delegate; //声明协议变量

@property (nonatomic,retain) AWAdModel *adModel;
@property (nonatomic,assign) AWAdOrientationType orientationType;



@end



NS_ASSUME_NONNULL_END
