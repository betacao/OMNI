//
//  OMAlarmView.h
//  OMNI
//
//  Created by changxicao on 16/7/4.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseView.h"
#import "OMBaseTableViewCell.h"
#import "OMAlarm.h"

@interface OMAlarmView : OMBaseView

+ (instancetype)sharedAlarmView;

@property (strong, nonatomic) OMRoomDevice *roomDevice;

@end

@interface OMAlarmTableViewCell : OMBaseTableViewCell

@property (strong, nonatomic) OMRoomDevice *roomDevice;

@property (strong, nonatomic) OMAlarmObject *alarm;

@end