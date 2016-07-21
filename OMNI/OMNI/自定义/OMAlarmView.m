//
//  OMAlarmView.m
//  OMNI
//
//  Created by changxicao on 16/7/4.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMAlarmView.h"
#import "OMAddTimingViewController.h"
#import "UIViewController+Extend.h"
#import "NSDate+Extend.h"

@interface OMAlarmView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *topButton;

@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) BOOL isEditing;

@property (assign, nonatomic) BOOL isShowing;



@end

@implementation OMAlarmView

+ (instancetype)sharedAlarmView
{
    static OMAlarmView *alarmView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alarmView = [[self alloc] init];
    });
    return alarmView;
}

- (void)initView
{
    UIImage *image = [[UIImage imageNamed:@"timing_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(40.0f, 0.0f, 0.0f, 0.0f) resizingMode:UIImageResizingModeStretch];
    self.imageView = [[UIImageView alloc] initWithImage:image];

    self.topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.topButton setImage:[UIImage imageNamed:@"alarm_on"] forState:UIControlStateNormal];

    self.label = [[UILabel alloc] init];
    self.label.text = @"Timing";
    self.label.textColor = Color(@"537525");
    self.label.font = FontFactor(14.0f);

    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setImage:[UIImage imageNamed:@"timing_edit"] forState:UIControlStateNormal];

    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setImage:[UIImage imageNamed:@"timing_add"] forState:UIControlStateNormal];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.backgroundColor = self.tableView.backgroundColor = [UIColor clearColor];
    
    [self sd_addSubviews:@[self.imageView, self.topButton , self.label, self.leftButton, self.rightButton, self.tableView]];
}

- (void)addAutoLayout
{
    self.imageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.topButton.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self, MarginFactor(10.0f))
    .widthIs(self.topButton.currentImage.size.width)
    .heightIs(self.topButton.currentImage.size.height);

    self.label.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self.topButton, 0.0f)
    .heightIs(self.label.font.lineHeight);
    [self.label setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.leftButton.sd_layout
    .leftSpaceToView(self, MarginFactor(30.0f))
    .topSpaceToView(self.label, 0.0f)
    .widthIs(self.leftButton.currentImage.size.width)
    .heightIs(self.leftButton.currentImage.size.height);

    self.rightButton.sd_layout
    .rightSpaceToView(self, MarginFactor(30.0f))
    .topEqualToView(self.leftButton)
    .widthIs(self.rightButton.currentImage.size.width)
    .heightIs(self.rightButton.currentImage.size.height);

    self.tableView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .topSpaceToView(self.rightButton, MarginFactor(20.0f))
    .heightIs(MarginFactor(200.0f));

    [self setupAutoHeightWithBottomView:self.tableView bottomMargin:0.0f];
}

- (void)addReactiveCocoa
{
    [[self.topButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.isShowing = !self.isShowing;
    }];

    [[self.leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.isEditing = !self.isEditing;
    }];

    [[self.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.isEditing) {
            self.isEditing = !self.isEditing;
        } else {
            OMAddTimingViewController *controller = [[OMAddTimingViewController alloc] init];
            controller.roomDevice = self.roomDevice;
            [[UIViewController findSourceViewController:self.superview].navigationController pushViewController:controller animated:YES];
        }
    }];

}

- (void)loadData
{
    if (self.roomDevice) {
        WEAK(self, weakSelf);
        [OMGlobleManager readTimeTask:self.roomDevice.roomDeviceID inView:self.superview block:^(NSArray *array) {
            [weakSelf.dataArray removeAllObjects];
            NSInteger taskCount = [[array firstObject] integerValue];
            for (NSInteger i = 0; i < taskCount; i++) {
                OMAlarmObject *alarm = [[OMAlarmObject alloc] init];
                alarm.alarmID = [array objectAtIndex:i * 7 + 1];
                alarm.isOn = [[array objectAtIndex:i * 7 + 2] boolValue];
                alarm.fromTime = [NSDate convertDateFromString:[array objectAtIndex:i * 7 + 3] format:@"yyyy-MM-dd HH:mm"];
                alarm.toTime = [NSDate convertDateFromString:[array objectAtIndex:i * 7 + 4] format:@"yyyy-MM-dd HH:mm"];
                alarm.roomDeviceID = [array objectAtIndex:i * 7 + 5];
                alarm.periodType = [[array objectAtIndex:i * 7 + 6] integerValue];
                alarm.weekTypeString = [array objectAtIndex:i * 7 + 7];

                [weakSelf.dataArray addObject:alarm];
            }
            [weakSelf.tableView reloadData];
        }];
    }
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)setRoomDevice:(OMRoomDevice *)roomDevice
{
    _roomDevice = roomDevice;
    [self loadData];
}

- (void)setIsEditing:(BOOL)isEditing
{
    _isEditing = isEditing;
    self.leftButton.hidden = isEditing;
    [self.rightButton setImage:isEditing ? [UIImage imageNamed:@"btn_save_time"] : [UIImage imageNamed:@"timing_add"] forState:UIControlStateNormal];
    [self.tableView setEditing:isEditing animated:YES];
}

- (void)setIsShowing:(BOOL)isShowing
{
    _isShowing = isShowing;
    if (isShowing) {
        [self showWithAnimated];
    } else {
        [self hideWithAnimated];
    }
}

- (void)showWithAnimated
{
    [UIView animateWithDuration:0.25f animations:^{
        self.sd_resetNewLayout
        .leftSpaceToView(self.superview, 0.0f)
        .rightSpaceToView(self.superview, 0.0f)
        .yIs(SCREENHEIGHT - CGRectGetHeight([UIViewController findSourceViewController:self.superview].navigationController.navigationBar.frame) - CGRectGetHeight(self.frame));
    }];
}

- (void)showWithNoAnimated
{
    self.sd_resetNewLayout
    .leftSpaceToView(self.superview, 0.0f)
    .rightSpaceToView(self.superview, 0.0f)
    .yIs(SCREENHEIGHT - CGRectGetHeight([UIViewController findSourceViewController:self.superview].navigationController.navigationBar.frame) - CGRectGetHeight(self.frame));

}

- (void)hideWithAnimated
{
    [UIView animateWithDuration:0.25f animations:^{
        self.sd_resetNewLayout
        .leftSpaceToView(self.superview, 0.0f)
        .rightSpaceToView(self.superview, 0.0f)
        .yIs(SCREENHEIGHT - CGRectGetHeight([UIViewController findSourceViewController:self.superview].navigationController.navigationBar.frame) - self.topButton.currentImage.size.height);
    }];
}

- (void)hideWithNoAnimated
{
    self.sd_resetNewLayout
    .leftSpaceToView(self.superview, 0.0f)
    .rightSpaceToView(self.superview, 0.0f)
    .yIs(SCREENHEIGHT - CGRectGetHeight([UIViewController findSourceViewController:self.superview].navigationController.navigationBar.frame) - self.topButton.currentImage.size.height);
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.superview) {
        self.isEditing = NO;
        [self hideWithNoAnimated];
        _isShowing = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MarginFactor(60.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OMAlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OMAlarmTableViewCell"];
    if (!cell) {
        cell = [[OMAlarmTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OMAlarmTableViewCell"];
    }
    cell.alarm = [self.dataArray objectAtIndex:indexPath.row];
    cell.roomDevice = self.roomDevice;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAK(self, weakSelf);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        OMAlarmObject *alarm = [self.dataArray objectAtIndex:indexPath.row];
        [OMGlobleManager deleteTimeTask:@[alarm.alarmID, self.roomDevice.roomDeviceID] inView:self.superview block:^(NSArray *array) {
            if ([[array firstObject] isEqualToString:@"01"]) {
                [weakSelf.dataArray removeObject:alarm];
                [weakSelf.tableView reloadData];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OMAddTimingViewController *controller = [[OMAddTimingViewController alloc] init];
    controller.roomDevice = self.roomDevice;
    controller.alarm = [self.dataArray objectAtIndex:indexPath.row];
    [[UIViewController findSourceViewController:self.superview].navigationController pushViewController:controller animated:YES];
}

- (void)removeFromSuperview
{
    self.roomDevice = nil;
    [super removeFromSuperview];
}

@end


@interface OMAlarmTableViewCell()

@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UILabel *fromLabel;
@property (strong, nonatomic) UILabel *toLabel;
@property (strong, nonatomic) UILabel *periodLabel;
@property (strong, nonatomic) UISwitch *switchControl;
@property (strong, nonatomic) UIImageView *accessoryImageView;


@end

@implementation OMAlarmTableViewCell

- (void)initView
{
    self.bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"home_choose_device"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 10.0f, 20.0f, 10.0f) resizingMode:UIImageResizingModeStretch]];

    self.fromLabel = [[UILabel alloc] init];
    self.fromLabel.textColor = Color(@"537525");
    self.fromLabel.font = FontFactor(12.0f);

    self.toLabel = [[UILabel alloc] init];
    self.toLabel.textColor = Color(@"537525");
    self.toLabel.font = FontFactor(12.0f);

    self.periodLabel = [[UILabel alloc] init];
    self.periodLabel.textColor = Color(@"537525");
    self.periodLabel.font = FontFactor(12.0f);

    self.switchControl = [[UISwitch alloc] init];

    self.accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_arrow"]];

    [self.contentView sd_addSubviews:@[self.bgImageView, self.fromLabel, self.toLabel, self.periodLabel, self.switchControl, self.accessoryImageView]];
}

- (void)addAutoLayout
{
    self.bgImageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    CGFloat margin = (MarginFactor(60.0f) - 2.0f * self.fromLabel.font.lineHeight) / 3.0f;

    self.fromLabel.sd_layout
    .topSpaceToView(self.contentView, margin)
    .leftSpaceToView(self.contentView, MarginFactor(15.0f))
    .heightIs(self.fromLabel.font.lineHeight);
    [self.fromLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.toLabel.sd_layout
    .bottomSpaceToView(self.contentView, margin)
    .leftEqualToView(self.fromLabel)
    .heightIs(self.toLabel.font.lineHeight);
    [self.toLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.periodLabel.sd_layout
    .leftSpaceToView(self.toLabel, MarginFactor(10.0f))
    .bottomEqualToView(self.toLabel)
    .heightIs(self.periodLabel.font.lineHeight);
    [self.periodLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.switchControl.sd_layout
    .rightSpaceToView(self.contentView, MarginFactor(15.0f))
    .centerYEqualToView(self.contentView);

    self.accessoryImageView.sd_layout
    .rightEqualToView(self.switchControl)
    .centerYEqualToView(self.contentView)
    .widthIs(self.accessoryImageView.size.width)
    .heightIs(self.accessoryImageView.size.height);
}

- (void)setAlarm:(OMAlarmObject *)alarm
{
    _alarm = alarm;
    self.fromLabel.text = [@"on:" stringByAppendingString:[NSDate stringFromDate:alarm.fromTime format:@"yyyy-MM-dd HH:mm:ss"]];
    self.toLabel.text = [@"off:" stringByAppendingString:[NSDate stringFromDate:alarm.toTime format:@"yyyy-MM-dd HH:mm:ss"]];
    self.periodLabel.text = alarm.periodTypeString;
}

- (void)addReactiveCocoa
{
    [[self.switchControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        [OMGlobleManager changeTimeTaskState:@[self.alarm.alarmID, self.roomDevice.roomDeviceID, self.switchControl.isOn ? @"1" : @"0"] inView:[OMAlarmView sharedAlarmView].superview block:^(NSArray *array) {

        }];
    }];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    self.switchControl.hidden = editing;
    self.accessoryImageView.hidden = !editing;
}

@end
