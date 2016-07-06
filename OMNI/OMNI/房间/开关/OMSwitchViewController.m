//
//  OMSwitchViewController.m
//  OMNI
//
//  Created by changxicao on 16/7/3.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMSwitchViewController.h"
#import "OMAlarmView.h"

@interface OMSwitchViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation OMSwitchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRightNavigationItem:nil normalImage:[UIImage imageNamed:@"button_edit_normal"] highlightedImage:[UIImage imageNamed:@"button_edit_normal_down"]];
}

- (void)initView
{
    self.title = @"Smart Switch";
    self.imageView.image = [UIImage blurredImageWithImage:self.imageView.image blur:0.8f];
    [self.view addSubview:[OMAlarmView sharedAlarmView]];
}

- (void)addAutoLayout
{
    self.imageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.button.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.view)
    .widthIs(self.button.currentImage.size.width)
    .heightIs(self.button.currentImage.size.height);
}

- (void)addReactiveCocoa
{
    [[[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //这里面button状态要反写
            [OMGlobleManager changeSwitchState:@[self.roomDevice.roomDeviceID, button.isSelected ? @"0" : @"1"] inView:self.view block:^(NSArray *array) {
                [subscriber sendNext:array];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }] subscribeNext:^(id x) {
        [self.button setSelected:!self.button.isSelected];
        self.roomDevice.roomDeviceState = !self.roomDevice.roomDeviceState;
        self.tableViewCell.roomDevice = self.roomDevice;
    }];
}

- (void)loadData
{
    [OMGlobleManager readSwitchState:self.roomDevice.roomDeviceID inView:self.view block:^(NSArray *array) {
        BOOL success = [[array firstObject] isEqualToString:@"SUCCESS"];
        if (success) {
            [self.button setSelected:[[array lastObject] isEqualToString:@"1"]];
            [OMAlarmView sharedAlarmView].roomDevice = self.roomDevice;
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
