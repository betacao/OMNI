//
//  OMBaseViewController.m
//  OMNI
//
//  Created by changxicao on 16/5/13.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseViewController.h"

@interface OMBaseViewController ()
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation OMBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [self.view addSubview:self.imageView];
    self.imageView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
