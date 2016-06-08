//
//  OMGlobleManager.h
//  OMNI
//
//  Created by changxicao on 16/6/1.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMGlobleManager : NSObject

+ (instancetype)shareManager;

+ (void)login:(NSArray *)array inView:(UIView *)view block:(OMTCPNetWorkFinishBlock)block;

+ (void)regist:(NSArray *)array inView:(UIView *)view block:(OMTCPNetWorkFinishBlock)block;

+ (void)clear:(NSInteger)type inView:(UIView *)view block:(OMTCPNetWorkFinishBlock)block;

+ (void)getListInView:(UIView *)view block:(OMTCPNetWorkFinishBlock)block;

+ (void)addDevice:(NSArray *)array InView:(UIView *)view block:(OMTCPNetWorkFinishBlock)block;

//UDP
+ (void)readRoomsInView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

+ (void)readDevicesInView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

@end
