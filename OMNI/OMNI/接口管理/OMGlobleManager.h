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

+ (void)deleteDevice:(NSArray *)array inView:(UIView *)view block:(OMTCPNetWorkFinishBlock)block;

//UDP

//更改wifi配置
+ (void)changeWifi:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

+ (void)readTimeTask:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

+ (void)readRoomsInView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

+ (void)readRoomDevicesInView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

+ (void)createRoom:(NSString *)roomName inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

+ (void)editeRoom:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

//添加房间设备用到的函数
+ (void)createRoomDevice:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

+ (void)editeRoomDevice:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

+ (void)deleteRoomDevice:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

+ (void)pairRoomDevice:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

//以后再搞的
+ (void)panelRoomDevice:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

+ (void)changeRoomDeviceState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

//添加时间
+ (void)addTimeTask:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;
//打开关闭操作
+ (void)changeTimeTaskState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;
//删除
+ (void)deleteTimeTask:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;
+ (void)editTimeTask:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

//switch操作
+ (void)readSwitchState:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;
+ (void)changeSwitchState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

//单色灯操作
+ (void)readSingleLightState:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;
+ (void)changeSingleLightState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;
+ (void)slideSingleLightState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

//双色灯操作
+ (void)readDoubleLightState:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;
+ (void)slideDoubleLightInState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;
+ (void)slideDoubleLightOutState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;
+ (void)changeDoubleLightState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;

//彩灯操作
+ (void)readColorLightState:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;
+ (void)changeColorLightState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;
+ (void)changeColorLightOutState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;
+ (void)changeColorLightInState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;
+ (void)changeColorLightSpeed:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;
+ (void)changeColorLightTheme:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;
+ (void)changeColorLightColor:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block;
@end
