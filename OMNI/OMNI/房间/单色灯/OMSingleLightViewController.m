//
//  OMSingleLightViewController.m
//  OMNI
//
//  Created by changxicao on 16/7/7.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMSingleLightViewController.h"
#import "OMAlarmView.h"
#import "OMSingleSlider.h"

@interface OMSingleLightViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet OMSingleSlider *slider;

@end

@implementation OMSingleLightViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRightNavigationItem:nil normalImage:[UIImage imageNamed:@"button_edit_normal"] highlightedImage:[UIImage imageNamed:@"button_edit_normal_down"]];
}

- (void)initView
{
    self.title = @"Single Light";
    self.imageView.image = [UIImage blurredImageWithImage:self.imageView.image blur:0.8f];
    self.slider.roomDevice = self.roomDevice;
    self.slider.tableViewCell = self.tableViewCell;
    [self.view addSubview:[OMAlarmView sharedAlarmView]];
}

- (void)addAutoLayout
{
    self.imageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.slider.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
