//
//  KeyChainStore.h
//  uuid
//
//  Created by chenao on 2019/11/18.
//  Copyright © 2019 wlx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyChainStore : NSObject

+ (void)save:(NSString*)service data:(id)data;

+ (id)load:(NSString*)service;

+ (void)deleteKeyData:(NSString*)service;
@end

NS_ASSUME_NONNULL_END
