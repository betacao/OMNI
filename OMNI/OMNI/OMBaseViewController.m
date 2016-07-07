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
@property (strong, nonatomic) UIImageView *navImageView;

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
    [self loadData];

    [self addLeftNavigationItem:nil normalImage:[UIImage imageNamed:@"button_back_normal"] highlightedImage:[UIImage imageNamed:@"button_back_normal_down"]];

    self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [self.view addSubview:self.bgImageView];
    [self.view sendSubviewToBack:self.bgImageView];

    self.navImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_top_bg"]];
    [self.view insertSubview:self.navImageView aboveSubview:self.bgImageView];

    self.bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);

    self.navImageView.sd_layout.leftSpaceToView(self.view, 0.0f).rightSpaceToView(self.view, 0.0f).topSpaceToView(self.view, 0.0f).heightIs(self.navImageView.image.size.height);


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

- (void)loadData
{
    
}

- (void)addLeftNavigationItem:(NSString *)title normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:normalImage forState:UIControlStateNormal];
    [leftButton setImage:highlightedImage forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)addRightNavigationItem:(NSString *)title normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:normalImage forState:UIControlStateNormal];
    [rightButton setImage:highlightedImage forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)backButtonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClick:(UIButton *)button
{

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
