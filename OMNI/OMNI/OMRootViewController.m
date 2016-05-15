//
//  ViewController.m
//  OMNI
//
//  Created by changxicao on 16/5/11.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMRootViewController.h"
#import "OMLoginViewController.h"

@interface OMRootViewController ()

@end

@implementation OMRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", (long)SCREENHEIGHT]];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:imageView];
    imageView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        OMLoginViewController *controller = [[OMLoginViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navigationController animated:YES completion:nil];
    });
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
