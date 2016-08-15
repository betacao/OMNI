//
//  OMCurtainViewController.m
//  OMNI
//
//  Created by changxicao on 16/8/15.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMCurtainViewController.h"
#import "OMEditRoomDeviceViewController.h"
#import "OMAlarmView.h"

@interface OMCurtainViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *hookImageView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *curtainImageView;
@property (weak, nonatomic) IBOutlet UIButton *topButton;
@property (weak, nonatomic) IBOutlet UIButton *middleButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@end

@implementation OMCurtainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRightNavigationItem:nil normalImage:[UIImage imageNamed:@"button_edit_normal"] highlightedImage:[UIImage imageNamed:@"button_edit_normal_down"]];
}

- (void)initView
{
    self.title = @"Intelligent Curtain";
    self.imageView.image = [UIImage blurredImageWithImage:self.imageView.image blur:0.8f];
    [self.view addSubview:[OMAlarmView sharedAlarmView]];
}

- (void)addAutoLayout
{
    self.imageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.hookImageView.sd_layout
    .topSpaceToView(self.view, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(ceilf(SCREENWIDTH * self.hookImageView.image.size.height / self.hookImageView.image.size.width));

    CGFloat height = ceilf((SCREENWIDTH - MarginFactor(44.0f)) * self.curtainImageView.image.size.height / self.curtainImageView.image.size.width);
    self.contentView.sd_layout
    .topSpaceToView(self.hookImageView, -MarginFactor(30.0f))
    .leftSpaceToView(self.view, MarginFactor(22.0f))
    .rightSpaceToView(self.view, MarginFactor(22.0f))
    .heightIs(height);

    self.curtainImageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.topButton.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(self.contentView, height / 6.0f)
    .widthIs(self.topButton.currentImage.size.width)
    .heightIs(self.topButton.currentImage.size.height);

    self.middleButton.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(self.contentView, height / 2.0f)
    .widthIs(self.middleButton.currentImage.size.width)
    .heightIs(self.middleButton.currentImage.size.height);

    self.bottomButton.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(self.contentView, 5.0f * height / 6.0f)
    .widthIs(self.bottomButton.currentImage.size.width)
    .heightIs(self.bottomButton.currentImage.size.height);
}

- (void)addReactiveCocoa
{
    [[self.topButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [OMGlobleManager changeCurtainUp:self.roomDevice.roomDeviceID inView:self.view block:^(NSArray *array) {

        }];
    }];

    [[self.middleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [OMGlobleManager changeCurtainPause:self.roomDevice.roomDeviceID inView:self.view block:^(NSArray *array) {

        }];
    }];

    [[self.bottomButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [OMGlobleManager changeCurtainDown:self.roomDevice.roomDeviceID inView:self.view block:^(NSArray *array) {

        }];
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
