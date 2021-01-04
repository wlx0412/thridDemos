//
//  BookStoreMgr.h
//  YuemengSdkDemo
//
//  Created by wangdh on 2019/5/7.
//  Copyright © 2019 wangdh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UIViewController;


@interface BookStoreMgr : NSObject

@property (nonatomic, strong) NSString *thirdUserId;

-(void) openBookStore;
-(void) openBookStore: (NSString *)thirdID;
-(void) openBookStoreByUrl:(NSString *)url;
-(BOOL) handleOpenURL:(NSURL *)url;

-(UIViewController *) getBookStoreWebviewController;

@end

NS_ASSUME_NONNULL_END
