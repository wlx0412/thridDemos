//
//  WoWanOCManager.h
//  jujuwan_swift
//
//  Created by wlx on 2020/5/14.
//  Copyright © 2020 furong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WoWanSDK/WoWanSDK.h>
#import <AiWanAdSDK/AiWanAdSDK.h>

@protocol WoWanOCManagerDelegate <NSObject>

- (void)gameClickCallBack:(NSString *)gameid GameName:(NSString *)gamename;

- (void)gamePlayTimeCallCallBack:(NSString *)gameid GameName:(NSString *)gamename GameType:(int)gametype PlayTime:(NSInteger)playseconds;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WoWanOCManager : NSObject

@property(nonatomic, weak) id <WoWanOCManagerDelegate> delegate;


+(instancetype)shared;

-(void)initSDK:(NSString *)userID name:(NSString *)nickName photo:(NSString *)url;

-(void)getGameList:(void (^)(NSInteger status, NSArray *list, NSString *msg))block;

-(void)openGame:(NSString *)gameID from:(UIViewController *)vc;
@end

NS_ASSUME_NONNULL_END
