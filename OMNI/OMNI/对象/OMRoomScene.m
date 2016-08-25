//
//  OMRoomScene.m
//  OMNI
//
//  Created by changxicao on 16/8/25.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMRoomScene.h"

@implementation OMRoomScene

- (NSString *)displayName
{
    return [NSString stringWithFormat:@"%@->%@->%@",self.roomName, self.deviceName, self.displayState];
}

@end
