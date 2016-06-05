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
    long type = strtoul([roomDeviceType UTF8String], 0, 16);
    if (type == 0x0102) {
        _roomDeviceType = @"开关";
    } else if (type == 0x0103) {
        _roomDeviceType = @"单色灯";
    } else if (type == 0x0104) {
        _roomDeviceType = @"双色灯";
    } else if (type == 0x0105) {
        _roomDeviceType = @"彩色灯";
    } else if (type == 0x0106) {
        _roomDeviceType = @"吊扇";
    } else if (type == 0x0107) {
        _roomDeviceType = @"窗帘";
    }
}

@end