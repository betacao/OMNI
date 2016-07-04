//
//  OMRoomTableViewCell.m
//  OMNI
//
//  Created by changxicao on 16/6/5.
//  Copyright © 1016年 changxicao. All rights reserved.
//

#import "OMRoomTableViewCell.h"

@interface OMRoomTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UIView *effectiveView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;

@property (weak, nonatomic) IBOutlet UILabel *addDeviceLabel;

@end

@implementation OMRoomTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)initView
{
    self.nameLabel.textColor = [UIColor lightGrayColor];

    self.addDeviceLabel.textColor = Color(@"668823");
    self.addDeviceLabel.text = @"+Add a new device";
    self.addDeviceLabel.textAlignment = NSTextAlignmentCenter;

    self.backgroundImageView.image = [UIImage imageNamed:@"home_choose_device"];

    self.timeImageView.image = [UIImage imageNamed:@"alarm_on"];
    self.arrowImageView.image = [UIImage imageNamed:@"choose_arrow"];
}

- (void)addAutoLayout
{
    self.backgroundImageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.effectiveView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.iconImageView.sd_resetLayout
    .centerYEqualToView(self.effectiveView)
    .leftSpaceToView(self.effectiveView, MarginFactor(10.0f));

    self.nameLabel.sd_resetLayout
    .centerYEqualToView(self.effectiveView)
    .leftSpaceToView(self.iconImageView, MarginFactor(10.0f))
    .heightIs(self.nameLabel.font.lineHeight);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.arrowImageView.sd_layout
    .centerYEqualToView(self.effectiveView)
    .rightSpaceToView(self.effectiveView, MarginFactor(10.0f))
    .widthIs(self.arrowImageView.image.size.width)
    .heightIs(self.arrowImageView.image.size.height);

    self.switchControl.sd_layout
    .centerYEqualToView(self.effectiveView)
    .rightSpaceToView(self.arrowImageView, MarginFactor(10.0f));

    self.timeImageView.sd_layout
    .centerYEqualToView(self.effectiveView)
    .rightSpaceToView(self.switchControl, MarginFactor(10.0f))
    .widthIs(self.timeImageView.image.size.width)
    .heightIs(self.timeImageView.image.size.height);

    self.addDeviceLabel.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

}

- (void)addReactiveCocoa
{
    [[[self.switchControl rac_signalForControlEvents:UIControlEventValueChanged] flattenMap:^RACStream *(UISwitch *value) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [OMGlobleManager changeRoomDeviceState:@[@(self.roomDevice.roomDeviceType), self.roomDevice.roomDeviceID, value.isOn ? @"1" : @"0"] inView:self.controller.view block:^(NSArray *array) {
                [subscriber sendNext:array];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }] subscribeNext:^(id x) {
        
    }];
}

- (void)setRoomDevice:(OMRoomDevice *)roomDevice
{
    _roomDevice = roomDevice;
    self.addDeviceLabel.hidden = YES;
    self.effectiveView.hidden = YES;
    if (roomDevice.roomDeviceName.length == 0) {
        self.addDeviceLabel.hidden = NO;
    } else {
        self.effectiveView.hidden = NO;
        self.nameLabel.text = roomDevice.roomDeviceName;
        self.iconImageView.image = roomDevice.roomDeviceIcon;

        self.iconImageView.sd_resetLayout
        .centerYEqualToView(self.effectiveView)
        .leftSpaceToView(self.effectiveView, MarginFactor(10.0f))
        .widthIs(self.iconImageView.image.size.width)
        .heightIs(self.iconImageView.image.size.height);

        [self.switchControl setOn:[roomDevice.roomDeviceState isEqualToString:@"1"] animated:NO];
        if ([roomDevice.roomDeviceFlag isEqualToString:@"1"] ) {
            self.timeImageView.image = [UIImage imageNamed:@"alarm_on"];
        } else {
            self.timeImageView.image = [UIImage imageNamed:@"alarm_off"];
        }
    }
}

@end
