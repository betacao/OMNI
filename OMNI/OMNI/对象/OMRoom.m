//
//  OMRoom.m
//  OMNI
//
//  Created by changxicao on 16/6/5.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMRoom.h"

@implementation OMRoom

@end


@implementation OMRoomDevice

- (void)setRoomDeviceType:(NSString *)roomDeviceType
{
    if ([roomDeviceType integerValue] > 200) {
        _roomDeviceType = roomDeviceType = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1lx",(long)[roomDeviceType integerValue]]];
    } else{
        _roomDeviceType = roomDeviceType;
    }
    
    if ([roomDeviceType isEqualToString:@"102"]) {
        //开关
        self.roomDeviceIcon = [UIImage imageNamed:@"choose_device_type_smart_switch"];
    } else if ([roomDeviceType isEqualToString:@"103"]) {
        //单色灯
        self.roomDeviceIcon = [UIImage imageNamed:@"light_single"];
    } else if ([roomDeviceType isEqualToString:@"104"]) {
        //双色灯
        self.roomDeviceIcon = [UIImage imageNamed:@"light_double"];
    } else if ([roomDeviceType isEqualToString:@"105"]) {
        //彩色灯
        self.roomDeviceIcon = [UIImage imageNamed:@"light_mutable"];
    } else if ([roomDeviceType isEqualToString:@"106"]) {
        //吊扇
        self.roomDeviceIcon = [UIImage imageNamed:@"choose_device_type_art_fan"];
    } else if ([roomDeviceType isEqualToString:@"107"]) {
        //窗帘
        self.roomDeviceIcon = [UIImage imageNamed:@"choose_device_type_intelligent_curtain"];
    }
}

@end