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

- (void)setRoomDeviceType:(OMRoomDeviceType)roomDeviceType
{
    _roomDeviceType = roomDeviceType;

    if (roomDeviceType == OMRoomDeviceTypeSwitch) {
        //开关
        self.roomDeviceIcon = [UIImage imageNamed:@"choose_device_type_smart_switch"];
    } else if (roomDeviceType == OMRoomDeviceTypeSinglelight) {
        //单色灯
        self.roomDeviceIcon = [UIImage imageNamed:@"light_single"];
    } else if (roomDeviceType == OMRoomDeviceTypeDoublelight) {
        //双色灯
        self.roomDeviceIcon = [UIImage imageNamed:@"light_double"];
    } else if (roomDeviceType == OMRoomDeviceTypeMutablelight) {
        //彩色灯
        self.roomDeviceIcon = [UIImage imageNamed:@"light_mutable"];
    } else if (roomDeviceType == OMRoomDeviceTypeFan) {
        //吊扇
        self.roomDeviceIcon = [UIImage imageNamed:@"choose_device_type_art_fan"];
    } else if (roomDeviceType == OMRoomDeviceTypeCurtain) {
        //窗帘
        self.roomDeviceIcon = [UIImage imageNamed:@"choose_device_type_intelligent_curtain"];
    }
}

@end