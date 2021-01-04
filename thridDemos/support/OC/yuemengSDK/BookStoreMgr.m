//
//  BookStoreMgr.m
//  YuemengSdkDemo
//
//  Created by wangdh on 2019/5/7.
//  Copyright © 2019 wangdh. All rights reserved.
//

#import "BookStoreMgr.h"
#import "YuemengAdSdkCenter.h"

@interface BookStoreMgr () <YMBookStoreDelegate>

@property (nonatomic, strong) YuemengAdSdkCenter *adCenter;



@end



@implementation BookStoreMgr

-(id) init
{
    self = [super init];
    if (self){
        
        _thirdUserId = @"abc123dfdsk";
        
        //这里是demo展示的书城Id，合作方使用的书城Id请与商务联系获取
        _adCenter = [[YuemengAdSdkCenter alloc] initYuemengSdkWithBookStoreId:8493 delegate:self];//8052
        
        //设置navigation title 颜色
        //[_adCenter setWebiewNavigationbarTitleColor:[UIColor colorWithWhite:0.5 alpha:1]];

        //设置navigation bar 背景颜色
        //[_adCenter setWebiewNavigationbarBgColor:[UIColor colorWithWhite:0.8 alpha:1]];
    }
    
    return self;
}

-(void) dealloc
{
    _adCenter = nil;
}

-(void) openBookStore
{
    [_adCenter presentBookStore:_thirdUserId];
}

-(void) openBookStore: (NSString *)thirdID{
    [_adCenter presentBookStore:thirdID];
}

-(void) openBookStoreByUrl:(NSString *)url
{
    [_adCenter presentBookStoreByUrl:url :_thirdUserId];
}

-(BOOL) handleOpenURL:(NSURL *)url
{
    return [_adCenter handleOpenURL:url :_thirdUserId];
}

-(UIViewController *) getBookStoreWebviewController
{
    return [_adCenter getBookStoreWebviewController:_thirdUserId];
}

#pragma --mark BookStoreDelegate
//SDK打开通知
-(void) yuemengSdkDidOpen
{
    
}

//SDK关闭通知
-(void) yuemengSdkDidClose
{
    
}

-(void) notifySVIPUser
{
    //初始化后或者用户使用过程中购买了svip，通过这个接口通知app
    
}

@end
