//
//  OMAlarm.h
//  OMNI
//
//  Created by changxicao on 16/7/5.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OMAlarmPeriodType)
{
    OMAlarmPeriodTypeNever = 0,
    OMAlarmPeriodTypeEveryDay,
    OMAlarmPeriodTypeEveryWeek,
    OMAlarmPeriodTypeEveryMonth
};

typedef NS_ENUM(NSInteger, OMAlarmWeekType)
{
    OMAlarmWeekTypeNull = 0,
    OMAlarmWeekTypeMon,
    OMAlarmWeekTypeTues,
    OMAlarmWeekTypeWed,
    OMAlarmWeekTypeThur,
    OMAlarmWeekTypeFri,
    OMAlarmWeekTypeSat,
    OMAlarmWeekTypeSun
};

@interface OMAlarmObject : NSObject

@property (strong, nonatomic) NSString *alarmID;
@property (strong, nonatomic) NSString *roomDeviceID;//在哪个设备上起作用
@property (strong, nonatomic) NSDate *fromTime;
@property (strong, nonatomic) NSDate *toTime;

@property (assign, nonatomic) OMAlarmPeriodType periodType;
@property (strong, nonatomic) NSString *periodTypeString;

@property (assign, nonatomic) OMAlarmWeekType weekType;
@property (strong, nonatomic) NSString *weekTypeString;
@property (assign, nonatomic) BOOL isOn;

@end
