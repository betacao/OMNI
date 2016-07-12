//
//  OMAddTimingViewController.h
//  OMNI
//
//  Created by changxicao on 16/7/5.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseViewController.h"
#import "OMBaseView.h"


@interface OMAddTimingViewController : OMBaseViewController

@property (strong, nonatomic) NSString *timeString;

@end


@interface OMAddTimingSubView : OMBaseView

- (NSDate *)date;

- (void)addLeftTitle:(NSString *)title;

- (void)addRightTitle:(NSString *)title;

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