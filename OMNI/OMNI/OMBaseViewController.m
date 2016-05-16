//
//  OMBaseViewController.m
//  OMNI
//
//  Created by changxicao on 16/5/13.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseViewController.h"

@interface OMBaseViewController ()

@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UIImageView *topImageView;

@end

@implementation OMBaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self addAutoLayout];
    [self addReactiveCocoa];

    self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [self.view addSubview:self.bgImageView];
    [self.view sendSubviewToBack:self.bgImageView];

    self.topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_top_bg"]];
    [self.view insertSubview:self.topImageView aboveSubview:self.bgImageView];

    self.bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);

    self.topImageView.sd_layout.leftSpaceToView(self.view, 0.0f).rightSpaceToView(self.view, 0.0f).topSpaceToView(self.view, 0.0f).heightIs(self.topImageView.image.size.height);

    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normalImage = [UIImage imageNamed:@"button_back_normal"];
    UIImage *highlightedImage = [UIImage imageNamed:@"button_back_normal_down"];
    [leftButton setImage:normalImage forState:UIControlStateNormal];
    [leftButton setImage:highlightedImage forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)initView
{

}

- (void)addAutoLayout
{

}

- (void)addReactiveCocoa
{

}

- (void)backButtonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
