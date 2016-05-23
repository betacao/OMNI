//
//  OMBaseViewController.h
//  OMNI
//
//  Created by changxicao on 16/5/13.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMBaseViewController : UIViewController

- (void)backButtonClick:(UIButton *)button;
- (void)initView;
- (void)addAutoLayout;
- (void)addReactiveCocoa;

- (void)addLeftNavigationItem:(NSString *)title normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage;

- (void)addRightNavigationItem:(NSString *)title normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage;

@end
