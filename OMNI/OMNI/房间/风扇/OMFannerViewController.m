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

@property (weak, nonatomic) IBOutlet UIButton *displayButton1;
@property (weak, nonatomic) IBOutlet UIButton *displayButton2;
@property (weak, nonatomic) IBOutlet UIButton *displayButton3;
@property (weak, nonatomic) IBOutlet UIButton *displayButton4;
@property (weak, nonatomic) IBOutlet UIButton *displayButton5;

@property (strong, nonatomic) NSArray *actionButtonArray;
@property (strong, nonatomic) NSArray *buttonImageArray;

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
    self.title = @"Art Fan";
    self.imageView.image = [UIImage blurredImageWithImage:self.imageView.image blur:0.8f];

    [OMAlarmView sharedAlarmView].tableViewCell = self.tableViewCell;
    [self.view addSubview:[OMAlarmView sharedAlarmView]];

    self.actionButtonArray = @[self.displayButton1, self.displayButton2, self.displayButton3, self.displayButton4, self.displayButton5];
    self.buttonImageArray = @[[UIImage imageNamed:@"fanner_1"], [UIImage imageNamed:@"fanner_2"], [UIImage imageNamed:@"fanner_3"], [UIImage imageNamed:@"fanner_4"], [UIImage imageNamed:@"fanner_5"]];
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

    self.displayButton1.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.diskImageView)
    .widthIs(self.displayButton1.currentImage.size.width)
    .heightIs(self.displayButton1.currentImage.size.height);

    self.displayButton2.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.diskImageView)
    .widthIs(self.displayButton2.currentImage.size.width)
    .heightIs(self.displayButton2.currentImage.size.height);

    self.displayButton3.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.diskImageView)
    .widthIs(self.displayButton3.currentImage.size.width)
    .heightIs(self.displayButton3.currentImage.size.height);

    self.displayButton4.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.diskImageView)
    .widthIs(self.displayButton4.currentImage.size.width)
    .heightIs(self.displayButton4.currentImage.size.height);

    self.displayButton5.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.diskImageView)
    .widthIs(self.displayButton5.currentImage.size.width)
    .heightIs(self.displayButton5.currentImage.size.height);

    //
    self.firstButton.sd_layout
    .centerXEqualToView(self.view)
    .offset(-64.0f)
    .centerYEqualToView(self.view)
    .offset(39.0f + MarginFactor(-60.0f))
    .widthIs(65.0f)
    .heightIs(72.0f);
    
    self.secondButton.sd_layout
    .centerXEqualToView(self.view)
    .offset(-68.0f)
    .centerYEqualToView(self.view)
    .offset(-35.0f + MarginFactor(-60.0f))
    .widthIs(63.0f)
    .heightIs(77.0f);

    self.thirdButton.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.view)
    .offset(-74.0f + MarginFactor(-60.0f))
    .widthIs(90.0f)
    .heightIs(38.0f);

    self.fourthButton.sd_layout
    .centerXEqualToView(self.view)
    .offset(68.0f)
    .centerYEqualToView(self.view)
    .offset(-37.0f + MarginFactor(-60.0f))
    .widthIs(63.0f)
    .heightIs(77.0f);

    self.fifthButton.sd_layout
    .centerXEqualToView(self.view)
    .offset(64.0f)
    .centerYEqualToView(self.view)
    .offset(39.0f + MarginFactor(-60.0f))
    .widthIs(65.0f)
    .heightIs(72.0f);
    //

    self.button.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.diskImageView)
    .widthIs(self.button.currentImage.size.width)
    .heightIs(self.button.currentImage.size.height);

    self.iconImageView.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.button, MarginFactor(5.0f))
    .widthIs(self.iconImageView.image.size.width)
    .heightIs(self.iconImageView.image.size.height);

    self.label.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.iconImageView, 0.0f)
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
            self.currentGear = self.currentGear;
            self.isOn = self.button.isSelected;
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
    [OMGlobleManager readFannerState:self.roomDevice.roomDeviceID inView:self.view block:^(NSArray *array) {
        BOOL success = [[array firstObject] isEqualToString:@"SUCCESS"];
        if (success) {
            [self.button setSelected:[[array objectAtIndex:3] isEqualToString:@"1"]];
            self.currentGear = [[array objectAtIndex:4] integerValue];
            self.isOn = self.button.isSelected;
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
    if (!isOn) {
        [self.actionButtonArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setImage:nil forState:UIControlStateNormal];
        }];
    }
}

- (void)setCurrentGear:(NSInteger)currentGear
{
    //如果关闭状态默认把档位写成0
    _currentGear = currentGear;
    [self.actionButtonArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setImage:nil forState:UIControlStateNormal];
    }];
    if (currentGear != 0) {
        UIButton *button = [self.actionButtonArray objectAtIndex:currentGear - 1];
        [button setImage:[self.buttonImageArray objectAtIndex:currentGear - 1] forState:UIControlStateNormal];
    }
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
