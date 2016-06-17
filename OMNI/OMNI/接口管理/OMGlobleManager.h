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

+ (void)getGatewayID:(UIView *)view block:(OMTCPNetWorkFinishBlock)block;

//这个不是增加房间设备 而是网关设备(上一个项目的东东)
+ (void)addDevice:(NSArray *)array inView:(UIView *)view block:(OMTCPNetWorkFinishBlock)block;

//UDP
+ (void)readRoomsInView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

+ (void)readRoomDevicesInView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

+ (void)createRoom:(NSString *)roomName inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

+ (void)editeRoom:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

//添加房间设备用到的函数
+ (void)createRoomDevice:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

+ (void)editeRoomDevice:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

+ (void)deleteRoomDevice:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

+ (void)pairRoomDevice:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

+ (void)panelRoomDevice:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

@end
