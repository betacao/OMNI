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

@end

@implementation OMCurtainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRightNavigationItem:nil normalImage:[UIImage imageNamed:@"button_edit_normal"] highlightedImage:[UIImage imageNamed:@"button_edit_normal_down"]];
}

- (void)initView
{
    self.title = @"Curtain";
    self.imageView.image = [UIImage blurredImageWithImage:self.imageView.image blur:0.8f];
    [self.view addSubview:[OMAlarmView sharedAlarmView]];
}

- (void)addAutoLayout
{
    self.imageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
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
