//
//  OMRoom.h
//  OMNI
//
//  Created by changxicao on 16/6/5.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OMRoomDeviceType)
{
    OMRoomDeviceTypeSwitch = 258,
    OMRoomDeviceTypeSinglelight = 259,
    OMRoomDeviceTypeDoublelight = 260,
    OMRoomDeviceTypeMutablelight = 261,
    OMRoomDeviceTypeFan = 262,
    OMRoomDeviceTypeCurtain = 263,
};

@interface OMRoom : NSObject

@property (strong, nonatomic) NSString *roomName;
@property (strong, nonatomic) NSString *roomNumber;
@property (strong, nonatomic) UIImage *roomThumbnail;

@end


@interface OMRoomDevice : NSObject

@property (strong, nonatomic) NSString *roomDeviceID;
@property (strong, nonatomic) NSString *roomDeviceName;
@property (strong, nonatomic) NSString *roomNumber;
@property (assign, nonatomic) OMRoomDeviceType roomDeviceType;
@property (strong, nonatomic) NSString *roomDeviceFlag;
@property (assign, nonatomic) BOOL roomDeviceState;
@property (strong, nonatomic) UIImage *roomDeviceIcon;

@end