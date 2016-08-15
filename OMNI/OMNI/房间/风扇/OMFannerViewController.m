//
//  OMFannerViewController.m
//  OMNI
//
//  Created by changxicao on 16/8/15.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMFannerViewController.h"
#import "OMEditRoomDeviceViewController.h"
#import "OMAlarmView.h"

@interface OMFannerViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *diskImageView;
@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;

@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;
@property (weak, nonatomic) IBOutlet UIButton *fourthButton;
@property (weak, nonatomic) IBOutlet UIButton *fifthButton;
@property (strong, nonatomic) NSArray *actionButtonArray;

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *directionButton;

@property (assign, nonatomic) BOOL isOn;
@property (assign, nonatomic) NSInteger currentGear;

@end

@implementation OMFannerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRightNavigationItem:nil normalImage:[UIImage imageNamed:@"button_edit_normal"] highlightedImage:[UIImage imageNamed:@"button_edit_normal_down"]];
}

- (void)initView
{
    self.title = @"Fan";
    self.imageView.image = [UIImage blurredImageWithImage:self.imageView.image blur:0.8f];
    self.firstButton.hidden = self.secondButton.hidden = self.thirdButton.hidden = self.fourthButton.hidden = self.fifthButton.hidden = YES;
    [self.view addSubview:[OMAlarmView sharedAlarmView]];

    self.actionButtonArray = @[self.firstButton, self.secondButton, self.thirdButton, self.fourthButton, self.fifthButton];
}

- (void)addAutoLayout
{
    self.imageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.diskImageView.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.view)
    .offset(MarginFactor(-60.0f))
    .widthIs(self.diskImageView.image.size.width)
    .heightIs(self.diskImageView.image.size.height);

    self.circleImageView.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.diskImageView)
    .widthIs(self.circleImageView.image.size.width)
    .heightIs(self.circleImageView.image.size.height);

    self.firstButton.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.diskImageView)
    .widthIs(self.firstButton.currentImage.size.width)
    .heightIs(self.firstButton.currentImage.size.height);

    self.secondButton.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.diskImageView)
    .widthIs(self.secondButton.currentImage.size.width)
    .heightIs(self.secondButton.currentImage.size.height);

    self.thirdButton.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.diskImageView)
    .widthIs(self.thirdButton.currentImage.size.width)
    .heightIs(self.thirdButton.currentImage.size.height);

    self.fourthButton.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.diskImageView)
    .widthIs(self.fourthButton.currentImage.size.width)
    .heightIs(self.fourthButton.currentImage.size.height);

    self.fifthButton.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.diskImageView)
    .widthIs(self.fifthButton.currentImage.size.width)
    .heightIs(self.fifthButton.currentImage.size.height);

    self.button.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.diskImageView)
    .widthIs(self.button.currentImage.size.width)
    .heightIs(self.button.currentImage.size.height);

    self.iconImageView.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.button, 0.0f)
    .widthIs(self.iconImageView.image.size.width)
    .heightIs(self.iconImageView.image.size.height);

    self.label.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.iconImageView, MarginFactor(-2.0f))
    .heightIs(self.label.font.lineHeight);
    [self.label setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.directionButton.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.diskImageView, MarginFactor(40.0f))
    .widthIs(self.directionButton.currentImage.size.width)
    .heightIs(self.directionButton.currentImage.size.height);

}

- (void)addReactiveCocoa
{
    [[[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //这里面button状态要反写
            [OMGlobleManager changeFannerState:@[self.roomDevice.roomDeviceID, button.isSelected ? @"0" : @"1", @(self.currentGear)] inView:self.view block:^(NSArray *array) {
                [subscriber sendNext:array];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }] subscribeNext:^(NSArray *x) {
        if (![[x firstObject] isEqualToString:@"OFFLINE"]) {
            [self.button setSelected:!self.button.isSelected];
            self.roomDevice.roomDeviceState = !self.roomDevice.roomDeviceState;
            self.tableViewCell.roomDevice = self.roomDevice;
        }
    }];

    [[self.directionButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [OMGlobleManager changeFannerDireaction:self.roomDevice.roomDeviceID inView:self.view block:^(NSArray *array) {

        }];
    }];

    [[[self.firstButton rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(id value) {
        return [self signalWithIndex:1];
    }] subscribeNext:^(id x) {
        self.currentGear = 1;
    }];

    [[[self.secondButton rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(id value) {
        return [self signalWithIndex:2];
    }] subscribeNext:^(id x) {
        self.currentGear = 2;
    }];

    [[[self.thirdButton rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(id value) {
        return [self signalWithIndex:3];
    }] subscribeNext:^(id x) {
        self.currentGear = 3;
    }];

    [[[self.fourthButton rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(id value) {
        return [self signalWithIndex:4];
    }] subscribeNext:^(id x) {
        self.currentGear = 4;
    }];

    [[[self.fifthButton rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(id value) {
        return [self signalWithIndex:5];
    }] subscribeNext:^(id x) {
        self.currentGear = 5;
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

- (RACSignal *)signalWithIndex:(NSInteger)index
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [OMGlobleManager changeFannerGear:@[self.roomDevice.roomDeviceID, @(index)] inView:self.view block:^(NSArray *array) {
            [subscriber sendNext:array];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (void)setIsOn:(BOOL)isOn
{
    _isOn = isOn;
    if (isOn) {

    } else {

    }
}

- (void)setCurrentGear:(NSInteger)currentGear
{
    _currentGear = currentGear;
    [self.actionButtonArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
}

- (void)rightButtonClick:(UIButton *)button
{
    OMEditRoomDeviceViewController *controller = [[OMEditRoomDeviceViewController alloc] init];
    controller.roomDevice = self.roomDevice;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
