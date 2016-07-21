//
//  OMAddTimingViewController.h
//  OMNI
//
//  Created by changxicao on 16/7/5.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseViewController.h"
#import "OMBaseView.h"
#import "OMBaseTableViewCell.h"
#import "OMAlarm.h"


@interface OMAddTimingViewController : OMBaseViewController

@property (strong, nonatomic) OMRoomDevice *roomDevice;

@property (strong, nonatomic) OMAlarmObject *alarm;

@end


@interface OMAddTimingSubView : OMBaseView

- (NSDate *)date;

- (void)addLeftTitle:(NSString *)title;

- (void)addRightTitle:(NSString *)title;

- (NSString *)rightText;

//时间排序错误（截止时间小于开始时间）
- (void)setTitleColor:(UIColor *)color;

@end

typedef void(^OMAddTimingPickerViewBlock)(NSString *);

@interface OMAddTimingPickerContentView : OMBaseView

@property (strong, nonatomic) NSString *timeString;

@property (assign, nonatomic) NSInteger numberOfComponents;

@property (copy, nonatomic) OMAddTimingPickerViewBlock block;

@end


@interface OMAddTimingPickerView : UIPickerView


@end


typedef void(^OMAddTimingPeriodViewBlock)(NSString *);

@interface OMAddTimingPeriodViewController : OMBaseViewController

@property (strong, nonatomic) NSArray *periodArray;

@property (strong, nonatomic) NSString *defaultPeriod;

@property (copy, nonatomic) OMAddTimingPeriodViewBlock block;

@end


@interface OMAddTimePeriodTableViewCell : OMBaseTableViewCell

@property (strong, nonatomic) NSString *text;

@end





