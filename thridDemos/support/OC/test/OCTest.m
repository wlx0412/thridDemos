//
//  OCTest.m
//  jujuwan_swift
//
//  Created by wlx on 2020/1/14.
//  Copyright © 2020 furong. All rights reserved.
//

#import "OCTest.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <objc/runtime.h>

#define rate [UIScreen mainScreen].bounds.size.width / 375

@implementation OCTest
///  SVProgressHUD纯文本
/// @param str msg
+(void)show: (NSString *) str {
    [SVProgressHUD setMinimumDismissTimeInterval: 3.0];
    [SVProgressHUD setCornerRadius: 6 * rate];
    [SVProgressHUD setBackgroundColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
//    [SVProgressHUD setMinimumSize:CGSizeMake(120 * rate, 50 * rate)];
    
    [SVProgressHUD showImage:[UIImage imageNamed: @""] status: str];
}

@end
