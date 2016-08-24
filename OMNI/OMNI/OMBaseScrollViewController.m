//
//  OMBaseScrollViewController.m
//  OMNI
//
//  Created by changxicao on 16/6/7.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseScrollViewController.h"

@interface OMBaseScrollViewController ()<UIScrollViewDelegate>


@end

@implementation OMBaseScrollViewController

- (void)viewDidLoad
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    self.scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(NSNotification *notification) {
        for (UIView *view in self.scrollView.subviews) {
            if ([view isFirstResponder]) {
                CGFloat keyboradHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
                CGPoint point = CGPointMake(0.0f, CGRectGetMinY(view.frame) + kNavigationBarHeight);
                point = [view.superview convertPoint:point toView:self.scrollView];
                point.y = MAX(0.0f, keyboradHeight + point.y - CGRectGetHeight(self.view.frame));

                [self.scrollView setContentOffset:point animated:YES];
                break;
            }
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(0.0f, CGRectGetHeight(self.scrollView.frame) + 1.0f);
}

- (void)viewWillDisappear:(BOOL)animated
{

}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isFirstResponder]) {
            [obj resignFirstResponder];
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(subObjectResignFirstResponder) withObject:nil afterDelay:0.1f];
        }
    }];
}

- (void)subObjectResignFirstResponder
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
