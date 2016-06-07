//
//  OMDevice.m
//  OMNI
//
//  Created by changxicao on 16/5/18.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMDevice.h"

@implementation OMDevice

- (void)setDeviceNumber:(NSString *)deviceNumber
{
    _deviceNumber = deviceNumber;
    if ([deviceNumber isEqualToString:@"1"]) {
        self.deviceName = @"Gateway";
    }
}

- (void)setDeviceState:(NSString *)deviceState
{
    if ([deviceState isEqualToString:@"0"]) {
        _deviceState = @"offline";
    } else {
        _deviceState = @"online";
    }
}

@end
