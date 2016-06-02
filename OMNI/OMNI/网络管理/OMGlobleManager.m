//
//  OMGlobleManager.m
//  OMNI
//
//  Created by changxicao on 16/6/1.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMGlobleManager.h"

@implementation OMGlobleManager

+ (instancetype)shareManager
{
    static OMGlobleManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

+ (void)login:(NSArray *)array inView:(UIView *)view block:(OMTCPNetWorkFinishBlock)block
{
    NSString *request = [NSString stringWithFormat:@"fyzn2015#1#6#%@#%@#", [array firstObject], [array lastObject]];
    [[OMTCPNetWork sharedNetWork] sendMessage:request inView:view complete:block];
}

+ (void)regist:(NSArray *)array inView:(UIView *)view block:(OMTCPNetWorkFinishBlock)block
{
    NSString *request = [NSString stringWithFormat:@"fyzn2015#1#6#%@#%@#", [array firstObject], [array lastObject]];
    [[OMTCPNetWork sharedNetWork] sendMessage:request inView:view complete:block];
}

+ (void)clear:(NSInteger)type inView:(UIView *)view block:(OMTCPNetWorkFinishBlock)block
{
    NSString *request = @"";
    //tcp清理掉数据
    if (type == 1) {
        request = [NSString stringWithFormat:@"fyzn2015#1#11#%@#%@#%@#", kAppDelegate.deviceID, kAppDelegate.pinCode, kAppDelegate.userID];
    } else{
        request = [NSString stringWithFormat:@"fyzn2015#1#11#%@#G7S3#%@#", kAppDelegate.deviceID, kAppDelegate.userID];
    }
    [[OMTCPNetWork sharedNetWork] sendMessage:request inView:view complete:block];
}

@end
