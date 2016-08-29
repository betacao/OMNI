//
//  OMWebViewController.m
//  OMNI
//
//  Created by changxicao on 16/8/29.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMWebViewController.h"

@interface OMWebViewController ()

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation OMWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initView
{
    self.webView = [[UIWebView alloc] init];
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    if (self.filePath) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.filePath]]];
    }
}

- (void)addAutoLayout
{
    self.webView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
