//
//  OMSingleLightViewController.m
//  OMNI
//
//  Created by changxicao on 16/7/7.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMSingleLightViewController.h"
#import "OMAlarmView.h"

@interface OMSingleLightViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;

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

    
    [self.view addSubview:[OMAlarmView sharedAlarmView]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
