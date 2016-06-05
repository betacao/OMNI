//
//  NSMutableDictionary+Room.m
//  OMNI
//
//  Created by changxicao on 16/6/5.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "NSMutableDictionary+Room.h"

@implementation NSMutableDictionary (Room)

- (void)addRoomProperty
{
    OMRoom *room = [[OMRoom alloc] init];
    [self setObject:room forKey:@"room"];

    NSMutableArray *array = [NSMutableArray array];
    [self setObject:array forKey:@"roomDeviceArray"];
}

@end
