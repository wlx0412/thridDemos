//
//  LzGameAwardModel.h
//  WoWanSDKDemo
//
//  Created by pceggs on 2020/3/27.
//  Copyright © 2020年 lezhen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LzGameAwardModel : NSObject

//奖励级别
@property (nonatomic, assign) NSInteger dlevel;
//需要的分数
@property (nonatomic, assign) NSInteger needscore;
//用户领取状态
@property (nonatomic, assign) NSInteger userstatus;
//奖励金额
@property (nonatomic, copy) NSString* rwmoney;
//金额单位
@property (nonatomic, copy) NSString* unit;

@end

NS_ASSUME_NONNULL_END
