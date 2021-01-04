//
//  LzGameUserModel.h
//  WoWanSDKDemo
//
//  Created by pceggs on 2020/3/31.
//  Copyright © 2020年 lezhen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LzGameUserModel : NSObject<NSCoding>

/** 用户信息 */
//用户ID
@property (nonatomic, copy)NSString* userid;
//头像
@property (nonatomic, copy)NSString* headUrl;
//昵称
@property (nonatomic, copy)NSString* nickName;


@end

NS_ASSUME_NONNULL_END
