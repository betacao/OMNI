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
    _roomDeviceType = roomDeviceType;

    if ([roomDeviceType isEqualToString:@"258"]) {
        //开关
        self.roomDeviceIcon = [UIImage imageNamed:@"choose_device_type_smart_switch"];
    } else if ([roomDeviceType isEqualToString:@"259"]) {
        //单色灯
        self.roomDeviceIcon = [UIImage imageNamed:@"light_single"];
    } else if ([roomDeviceType isEqualToString:@"260"]) {
        //双色灯
        self.roomDeviceIcon = [UIImage imageNamed:@"light_double"];
    } else if ([roomDeviceType isEqualToString:@"261"]) {
        //彩色灯
        self.roomDeviceIcon = [UIImage imageNamed:@"light_mutable"];
    } else if ([roomDeviceType isEqualToString:@"262"]) {
        //吊扇
        self.roomDeviceIcon = [UIImage imageNamed:@"choose_device_type_art_fan"];
    } else if ([roomDeviceType isEqualToString:@"263"]) {
        //窗帘
        self.roomDeviceIcon = [UIImage imageNamed:@"choose_device_type_intelligent_curtain"];
    }
}

@end