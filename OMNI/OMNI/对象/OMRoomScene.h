//
//  OMRoomScene.h
//  OMNI
//
//  Created by changxicao on 16/8/25.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OMRoomSceneState)
{
    OMRoomSceneStateClose = 0,
    OMRoomSceneStateOpen = 1,
    OMRoomSceneStateNone = 2,
    OMRoomSceneStateOther = 255
};

@interface OMRoomScene : NSObject

@property (strong, nonatomic) NSString *roomName;
@property (strong, nonatomic) NSString *deviceName;
@property (strong, nonatomic) NSString *deviceID;
@property (assign, nonatomic) OMRoomSceneState state;

@property (strong, nonatomic) NSString *displayState;
@property (strong, nonatomic) NSString *displayName;

@end
