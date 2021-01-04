//
//  LzGameModel.h
//  WoWanSDKDemo
//
//  Created by pceggs on 2020/3/27.
//  Copyright © 2020年 lezhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LzGameAwardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LzGameModel : NSObject


//游戏ID
@property (nonatomic, copy) NSString* gid;
//游戏名称
@property (nonatomic, copy) NSString* gname;
//游戏小图图标
@property (nonatomic, copy) NSString* icon;
//游戏大图图标
@property (nonatomic, copy) NSString* bigicon;
//游戏介绍页地址
@property (nonatomic, copy) NSString* pageurl;
//游戏在玩人数
@property (nonatomic, copy) NSString* playcnt;
//游戏常玩标志
@property (nonatomic, assign) NSInteger playedtag;
//游戏标签（如：休闲 益智）
@property (nonatomic, copy) NSString* tag;
//总奖励
@property (nonatomic, copy) NSString* totalaward;
//奖励货币单位
@property (nonatomic, copy) NSString* unit;

//游戏奖励方案
@property (nonatomic, retain) NSArray<LzGameAwardModel *> *awards;

@end

NS_ASSUME_NONNULL_END
