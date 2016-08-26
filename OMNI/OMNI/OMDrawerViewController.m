//
//  OMDrawerViewController.m
//  OMNI
//
//  Created by changxicao on 16/8/22.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMDrawerViewController.h"

@interface OMDrawerViewController ()

@end

@implementation OMDrawerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addLeftNavigationItem:nil normalImage:[UIImage imageNamed:@"button_back_normal"] highlightedImage:[UIImage imageNamed:@"button_back_normal_down"]];
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
    [self closeDrawerAnimated:YES completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)rightButtonClick:(UIButton *)button
{
    if (self.leftDrawerViewController) {
        [self.leftDrawerViewController performSelector:@selector(rightButtonClick:) withObject:button];
    }
    if (self.centerViewController) {
        [self.centerViewController performSelector:@selector(rightButtonClick:) withObject:button];
    }
    if (self.rightDrawerViewController) {
        [self.rightDrawerViewController performSelector:@selector(rightButtonClick:) withObject:button];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
