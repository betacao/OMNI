//
//  OMDrawerViewController.h
//  OMNI
//
//  Created by changxicao on 16/8/22.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import <MMDrawerController/MMDrawerController.h>

@interface OMDrawerViewController : MMDrawerController

- (void)backButtonClick:(UIButton *)button;
- (void)rightButtonClick:(UIButton *)button;

- (void)addLeftNavigationItem:(NSString *)title normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage;

- (void)addRightNavigationItem:(NSString *)title normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage;

@end
