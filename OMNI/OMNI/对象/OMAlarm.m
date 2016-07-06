//
//  OMAlarm.m
//  OMNI
//
//  Created by changxicao on 16/7/5.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMAlarm.h"

@implementation OMAlarm

- (void)setWeekTypeString:(NSString *)weekTypeString
{
    _weekTypeString = weekTypeString;

    if ([weekTypeString isEqualToString:@"null"]) {
        self.weekType = OMAlarmWeekTypeNull;
    } else if ([weekTypeString isEqualToString:@"Mon"]) {
        self.weekType = OMAlarmWeekTypeMon;
    } else if ([weekTypeString isEqualToString:@"Tues"]) {
        self.weekType = OMAlarmWeekTypeTues;
    } else if ([weekTypeString isEqualToString:@"Wed"]) {
        self.weekType = OMAlarmWeekTypeWed;
    } else if ([weekTypeString isEqualToString:@"Thur"]) {
        self.weekType = OMAlarmWeekTypeThur;
    } else if ([weekTypeString isEqualToString:@"Fri"]) {
        self.weekType = OMAlarmWeekTypeFri;
    } else if ([weekTypeString isEqualToString:@"Sat"]) {
        self.weekType = OMAlarmWeekTypeSat;
    } else if ([weekTypeString isEqualToString:@"Sun"]) {
        self.weekType = OMAlarmWeekTypeSun;
    }
}

- (void)setPeriodType:(OMAlarmPeriodType)periodType
{
    _periodType = periodType;
    switch (periodType) {
        case OMAlarmPeriodTypeNever:
            self.periodTypeString = @"Never";
            break;
        case OMAlarmPeriodTypeEveryDay:
            self.periodTypeString = @"Every Day";
            break;
        case OMAlarmPeriodTypeEveryWeek:
            self.periodTypeString = @"Every Week";
            break;
        case OMAlarmPeriodTypeEveryMonth:
            self.periodTypeString = @"Every Month";
            break;
        default:
            break;
    }
}

@end
