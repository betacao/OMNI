//
//  OMRoom.h
//  OMNI
//
//  Created by changxicao on 16/6/5.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMRoom : NSObject

@property (strong, nonatomic) NSString *roomName;
@property (strong, nonatomic) NSString *roomNumber;

@end


@interface OMRoomDevice : NSObject

@property (strong, nonatomic) NSString *roomDeviceID;
@property (strong, nonatomic) NSString *roomDeviceName;
@property (strong, nonatomic) NSString *roomNumber;
@property (strong, nonatomic) NSString *roomDeviceType;
@property (strong, nonatomic) NSString *roomDeviceFlag;
@property (strong, nonatomic) NSString *roomDeviceState;


@end