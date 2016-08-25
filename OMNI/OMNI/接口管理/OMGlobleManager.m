//
//  OMGlobleManager.m
//  OMNI
//
//  Created by changxicao on 16/6/1.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMGlobleManager.h"

@implementation OMGlobleManager

+ (instancetype)shareManager
{
    static OMGlobleManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

+ (void)login:(NSArray *)array inView:(UIView *)view block:(OMTCPNetWorkFinishBlock)block
{
    NSString *request = [NSString stringWithFormat:@"fyzn2015#1#6#%@#%@#", [array firstObject], [array lastObject]];
    [[OMTCPNetWork sharedNetWork] sendMessage:request inView:view complete:block];
}

+ (void)regist:(NSArray *)array inView:(UIView *)view block:(OMTCPNetWorkFinishBlock)block
{
    NSString *request = [NSString stringWithFormat:@"fyzn2015#1#7#%@#%@#0#0#0#1111#", [array firstObject], [array lastObject]];
    [[OMTCPNetWork sharedNetWork] sendMessage:request inView:view complete:block];
}

+ (void)clear:(NSInteger)type inView:(UIView *)view block:(OMTCPNetWorkFinishBlock)block
{
    NSString *request = @"";
    //tcp清理掉数据
    if (type == 1) {
        request = [NSString stringWithFormat:@"fyzn2015#1#11#%@#%@#%@#", kAppDelegate.deviceID, kAppDelegate.pinCode, kAppDelegate.userID];
    } else{
        request = [NSString stringWithFormat:@"fyzn2015#1#11#%@#G7S3#%@#", kAppDelegate.deviceID, kAppDelegate.userID];
    }
    [[OMTCPNetWork sharedNetWork] sendMessage:request inView:view complete:block];
}

+ (void)getListInView:(UIView *)view block:(OMTCPNetWorkFinishBlock)block
{
    NSString *request = [@"fyzn2015#1#8#" stringByAppendingString:kAppDelegate.userID];
    [[OMTCPNetWork sharedNetWork] sendMessage:request inView:view complete:block];
}

+ (void)getGatewayID:(UIView *)view block:(OMTCPNetWorkFinishBlock)block
{
    NSString *request = @"LOCAL_GET_ID#120.27.151.216#";
    [[OMTCPNetWork sharedNetWork] sendSpecialMessage:request inView:view complete:block];
}

+ (void)addDevice:(NSArray *)array inView:(UIView *)view block:(OMTCPNetWorkFinishBlock)block
{
    NSString *request = [NSString stringWithFormat:@"fyzn2015#1#12#%@#%@#%@#%@#0#",[array firstObject], [array lastObject], kAppDelegate.userID, kAppDelegate.password];
    [[OMTCPNetWork sharedNetWork] sendMessage:request inView:view complete:block];
}

+ (void)deleteDevice:(NSArray *)array inView:(UIView *)view block:(OMTCPNetWorkFinishBlock)block
{
    NSString *request = [NSString stringWithFormat:@"fyzn2015#1#13#%@#%@#%@#",kAppDelegate.deviceID, [array firstObject], kAppDelegate.userID];
    [[OMTCPNetWork sharedNetWork] sendMessage:request inView:view complete:block];
}

//UDP

+ (void)changeWifi:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *string = [NSString stringWithFormat:@"change_wifi$%@$%@$", [array firstObject], [array objectAtIndex:1]];
        kAppDelegate.pinCode = [[array lastObject] stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *responseString = [[OMUDPNetWork sharedNetWork] sendMessage:string type:1 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:responseString]);
            }
        });
    });
}

+ (void)readTimeTask:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"read_timetask$%@$", string];
        NSString *responseString = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:responseString]);
            }
        });
    });
}

+ (void)readRoomsInView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:@"read_rooms" type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });

}

+ (void)readRoomDevicesInView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:@"read_devices" type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });

}

+ (void)createRoom:(NSString *)roomName inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"create_room$%@$", roomName];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)editeRoom:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"edit_room$%@$%@$", [array firstObject], [array lastObject]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)createRoomDevice:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"create_device$%@$%@$%d$", [array firstObject], [array lastObject], arc4random()%999 + 1];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)editeRoomDevice:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"edit_device$%@$%@$%@$", [array firstObject], [array objectAtIndex:1], [array lastObject]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)deleteRoomDevice:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"delete_device$%@$", string];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)pairRoomDevice:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"match_code$%@$", string];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)panelRoomDevice:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    block(@[]);
}


+ (void)changeRoomDeviceState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_dev_priv$%@$%@$%@$", [array firstObject], [array objectAtIndex:1], [array lastObject]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)addTimeTask:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"device_timetask$%@$%@$%@$100$%@$%@$%@$%@$%@$%@$%@$%@$%@$%@$%@$", [array firstObject], [array objectAtIndex:1], [array objectAtIndex:2], [array objectAtIndex:3], [array objectAtIndex:4], [array objectAtIndex:5], [array objectAtIndex:6], [array objectAtIndex:7], [array objectAtIndex:8], [array objectAtIndex:9], [array objectAtIndex:10], [array objectAtIndex:11], [array objectAtIndex:12], [array objectAtIndex:13]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)changeTimeTaskState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_taskenable$%@$%@$%@$", [array firstObject], [array objectAtIndex:1], [array lastObject]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)deleteTimeTask:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"delete_task$%@$%@$", [array firstObject], [array lastObject]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)editTimeTask:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"edit_timetask$%@$%@$%@$%@$%@$%@$%@$%@$%@$%@$%@$%@$%@$", [array firstObject], [array objectAtIndex:1], [array objectAtIndex:2], [array objectAtIndex:3], [array objectAtIndex:4], [array objectAtIndex:5], [array objectAtIndex:6], [array objectAtIndex:7], [array objectAtIndex:8], [array objectAtIndex:9], [array objectAtIndex:10], [array objectAtIndex:11], [array objectAtIndex:12]];

        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)readSwitchState:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"read_switch$%@$", string];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)changeSwitchState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_switch_priv$%@$%@$", [array firstObject], [array lastObject]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)readSingleLightState:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"read_singlelight$%@$", string];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)changeSingleLightState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_single_priv$%@$%@$255$", [array firstObject], [array lastObject]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)slideSingleLightState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_single_priv$%@$255$%@$", [array firstObject], [array lastObject]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)readDoubleLightState:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"read_doublelight$%@$", string];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)slideDoubleLightInState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_double_priv$%@$255$255$%@$", [array firstObject], [array lastObject]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)slideDoubleLightOutState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_double_priv$%@$255$%@$255$", [array firstObject], [array lastObject]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)changeDoubleLightState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_double_priv$%@$%@$255$255$", [array firstObject], [array lastObject]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)readColorLightState:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"read_colorlight$%@$", string];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)changeColorLightState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_color_priv$%@$%@$255$255$255$255$255$255$", [array firstObject], [array lastObject]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)changeColorLightSpeed:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_color_priv$%@$255$255$255$255$255$%@$255$", [array firstObject], [array lastObject]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)changeColorLightInState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_color_priv$%@$255$255$255$%@$255$255$255$", [array firstObject], [array lastObject]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)changeColorLightOutState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_color_priv$%@$255$255$%@$255$255$255$255$", [array firstObject], [array lastObject]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)changeColorLightTheme:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_color_priv$%@$1$255$255$255$255$255$%@$", [array firstObject], [array lastObject]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)changeColorLightColor:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_color_priv$%@$255$255$255$255$%@$255$255$", [array firstObject], [array lastObject]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}


+ (void)readFannerState:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"read_fan$%@$", string];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)changeFannerState:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_fan_priv$%@$255$255$%@$%@$255$", [array firstObject], [array objectAtIndex:1], [array lastObject]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)changeFannerGear:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_fan_priv$%@$255$255$1$%@$255$", [array firstObject], [array lastObject]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)changeFannerDireaction:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_fan_priv$%@$255$255$255$255$1$", string];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)changeCurtainUp:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_curtain_priv$%@$1$1$255$255$", string];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)changeCurtainPause:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_curtain_priv$%@$1$0$255$255$", string];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)changeCurtainDown:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_curtain_priv$%@$1$2$255$255$", string];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)readSceneModeInfoInView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = @"read_mode_info$";
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)changeToScene:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_mode$%@$", string];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)changeSceneIcon:(NSArray *)array inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"set_mode_info$%@$%@$%@$", [array firstObject], [array objectAtIndex:1], [array lastObject]];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

+ (void)readSceneModeConfig:(NSString *)string inView:(UIView *)view block:(OMUDPNetWorkFinishBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"read_mode_config$%@$", string];
        NSString *string = [[OMUDPNetWork sharedNetWork] sendMessage:request type:0 inView:view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([OMGlobleManager stringToArray:string]);
            }
        });
    });
}

//通用函数
+ (NSArray *)stringToArray:(NSString *)string
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[string componentsSeparatedByCharactersInSet:[NSCharacterSet formUnionWithArray:@[@"^", @"&"]]]];
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj && obj.length == 0) {
            [array removeObject:obj];
        }
    }];
    return array;
}
@end
