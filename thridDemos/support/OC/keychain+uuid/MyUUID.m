//
//  MyUUID.m
//  uuid
//
//  Created by chenao on 2019/11/18.
//  Copyright © 2019 wlx. All rights reserved.
//

#import "MyUUID.h"
#import "KeyChainStore.h"
#import <AdSupport/AdSupport.h>
#import "SVProgressHUD.h"
#import "thridDemos-Swift.h"

@implementation MyUUID
//213589

+(NSString*)getUUID{
    NSString*strUUID = (NSString*)[KeyChainStore load:@"com.wlx.uuid"];
//    NSLog(@"strUUID=%@",strUUID);
    //首次执行该方法时，uuid为空
    if(!strUUID || [strUUID isEqualToString:@""]){
//        UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        //生成一个uuid的方法
        CFUUIDRef uuidRef= CFUUIDCreate(kCFAllocatorDefault);
        strUUID = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault,uuidRef));
        //将该uuid保存到keychain
        [KeyChainStore save:@"com.wlx.uuid" data:strUUID];
    }
//    NSLog(@"strUUID=%@",strUUID);
    return strUUID;
}

@end
