//
//  OMAddGateWayViewController.m
//  OMNI
//
//  Created by changxicao on 16/5/23.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMAddGateWayViewController.h"
#import "OMListViewController.h"

@interface OMAddGateWayViewController ()

@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIImageView *middleImageView;
@property (weak, nonatomic) IBOutlet UITextField *countNameField;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UITextField *gatewayIDField;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation OMAddGateWayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Add Gateway";
}

- (void)initView
{
    UIView *leftView1 = [[UIView alloc] init];
    UIImageView *leftImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_password"]];
    [leftView1 addSubview:leftImageView1];
    leftImageView1.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(10.0f), 0.0f, MarginFactor(10.0f)));

    leftView1.sd_layout
    .heightIs(leftImageView1.image.size.height)
    .widthIs(leftImageView1.image.size.width + MarginFactor(20.0f));


    UIView *leftView2 = [[UIView alloc] init];
    UIImageView *leftImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_password"]];
    [leftView2 addSubview:leftImageView2];
    leftImageView2.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(10.0f), 0.0f, MarginFactor(10.0f)));

    leftView2.sd_layout
    .heightIs(leftImageView2.image.size.height)
    .widthIs(leftImageView2.image.size.width + MarginFactor(20.0f));


    UIView *leftView3 = [[UIView alloc] init];
    UIImageView *leftImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_password"]];
    [leftView3 addSubview:leftImageView3];
    leftImageView3.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(10.0f), 0.0f, MarginFactor(10.0f)));

    leftView3.sd_layout
    .heightIs(leftImageView3.image.size.height)
    .widthIs(leftImageView3.image.size.width + MarginFactor(20.0f));

    self.countNameField.leftView = leftView1;
    self.countNameField.leftViewMode = UITextFieldViewModeAlways;
    self.countNameField.text = kAppDelegate.userID;

    self.gatewayIDField.leftView = leftView2;
    self.gatewayIDField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.leftView = leftView3;
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;

    self.lineView1.backgroundColor = self.lineView2.backgroundColor = Color(@"c3ce9f");

    UIImage *image = [UIImage imageNamed:@"input"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch];
    self.middleImageView.image = image;
}

- (void)addAutoLayout
{
    self.countNameField.sd_layout
    .leftSpaceToView(self.middleView, 0.0f)
    .rightSpaceToView(self.middleView, 0.0f)
    .topSpaceToView(self.middleView, 0.0f)
    .heightIs(MarginFactor(60.0f));

    self.lineView1.sd_layout
    .leftSpaceToView(self.middleView, 0.0f)
    .rightSpaceToView(self.middleView, 0.0f)
    .topSpaceToView(self.countNameField, 0.0f)
    .heightIs(1.0f / SCALE);

    self.gatewayIDField.sd_layout
    .leftSpaceToView(self.middleView, 0.0f)
    .rightSpaceToView(self.middleView, 0.0f)
    .topSpaceToView(self.lineView1, 0.0f)
    .heightRatioToView(self.countNameField, 1.0f);

    self.lineView2.sd_layout
    .leftSpaceToView(self.middleView, 0.0f)
    .rightSpaceToView(self.middleView, 0.0f)
    .topSpaceToView(self.gatewayIDField, 0.0f)
    .heightIs(1.0f / SCALE);

    self.passwordField.sd_layout
    .leftSpaceToView(self.middleView, 0.0f)
    .rightSpaceToView(self.middleView, 0.0f)
    .topSpaceToView(self.lineView2, 0.0f)
    .heightRatioToView(self.countNameField, 1.0f);

    self.middleView.sd_layout
    .leftSpaceToView(self.view, MarginFactor(20.0f))
    .rightSpaceToView(self.view, MarginFactor(30.0f))
    .topSpaceToView(self.view, MarginFactor(20.0f));
    [self.middleView setupAutoHeightWithBottomView:self.passwordField bottomMargin:0.0f];

    self.middleImageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.commitButton.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.middleView, MarginFactor(30.0f))
    .widthIs(self.commitButton.currentBackgroundImage.size.width)
    .heightIs(self.commitButton.currentBackgroundImage.size.height);
}

- (void)addReactiveCocoa
{
    RACSignal *gatewayIDSignal = [[self.gatewayIDField rac_textSignal] map:^id(NSString *value) {
        return @(value.length > 0);
    }];

    RACSignal *passwordSignal = [[self.passwordField rac_textSignal] map:^id(NSString *value) {
        return @(value.length > 0);
    }];

    RACSignal *signal = [RACSignal combineLatest:@[gatewayIDSignal, passwordSignal] reduce:^id(NSNumber *idValid, NSNumber *passwordValid){
        return @([idValid boolValue] && [passwordValid boolValue]);
    }];

    RAC(self.commitButton, enabled) = [signal map:^id(NSNumber *value) {
        return value;
    }];

    [[[self.commitButton rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(id value) {
        return [self commitSignal];
    }] subscribeNext:^(NSString *x) {
        if ([x containsString:@"success"]) {
            [self.view showWithText:@"添加设备成功"];
            UIViewController *controller = nil;
            for (UIViewController *subController in self.navigationController.viewControllers) {
                if ([subController isKindOfClass:[OMListViewController class]]) {
                    controller = subController;
                    break;
                }
            }
            [(OMListViewController *)controller loadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToViewController:controller animated:YES];
            });
        } else {
            [self.view showWithText:@"添加设备失败"];
        }
    }];
}

- (RACSignal *)commitSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [OMGlobleManager addDevice:@[self.gatewayIDField.text, self.passwordField.text] InView:self.view block:^(NSString *string) {
            [subscriber sendNext: [string lowercaseString]];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
