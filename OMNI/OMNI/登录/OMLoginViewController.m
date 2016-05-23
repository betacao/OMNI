//
//  OMLoginViewController.m
//  OMNI
//
//  Created by changxicao on 16/5/13.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMLoginViewController.h"
#import "OMRegisterViewController.h"
#import "OMListViewController.h"

@interface OMLoginViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *rememberButton;
@property (weak, nonatomic) IBOutlet UILabel *rememberLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *guideButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UILabel *registerLabel;

@end

@implementation OMLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Account";
    self.nameField.text = @"18551796889";
    self.passwordField.text = @"111111";
}

- (void)initView
{
    UIView *leftView1 = [[UIView alloc] init];
    UIImageView *leftImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings_account"]];
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


    self.nameField.leftView = leftView1;
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.leftView = leftView2;
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;

    UIImage *image1 = self.nameField.background;
    image1 = [image1 resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch];
    self.nameField.background = image1;

    UIImage *image2 = self.nameField.background;
    image2 = [image2 resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch];
    self.passwordField.background = image2;
}

- (void)addAutoLayout
{
    self.titleLabel.sd_layout
    .topSpaceToView(self.view, MarginFactor(20.0f))
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(self.titleLabel.font.lineHeight);

    self.nameField.sd_layout
    .leftSpaceToView(self.view, MarginFactor(20.0f))
    .rightSpaceToView(self.view, MarginFactor(20.0f))
    .topSpaceToView(self.titleLabel, MarginFactor(20.0f))
    .heightIs(MarginFactor(40.0f));

    self.passwordField.sd_layout
    .leftSpaceToView(self.view, MarginFactor(20.0f))
    .rightSpaceToView(self.view, MarginFactor(20.0f))
    .topSpaceToView(self.nameField, MarginFactor(20.0f))
    .heightIs(MarginFactor(40.0f));

    self.rememberLabel.sd_layout
    .topSpaceToView(self.passwordField, MarginFactor(10.0f))
    .rightEqualToView(self.passwordField)
    .heightIs(self.rememberLabel.font.lineHeight);
    [self.rememberLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.rememberButton.sd_layout
    .centerYEqualToView(self.rememberLabel)
    .rightSpaceToView(self.rememberLabel, MarginFactor(5.0f))
    .widthIs(self.rememberButton.currentImage.size.width)
    .heightIs(self.rememberButton.currentImage.size.height);

    self.loginButton.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.rememberButton, MarginFactor(30.0f))
    .widthIs(self.loginButton.currentBackgroundImage.size.width)
    .heightIs(self.loginButton.currentBackgroundImage.size.height);

    self.guideButton.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.loginButton, MarginFactor(10.0f))
    .widthIs(self.guideButton.currentBackgroundImage.size.width)
    .heightIs(self.guideButton.currentBackgroundImage.size.height);

    self.registerButton.sd_layout
    .centerXEqualToView(self.view)
    .bottomSpaceToView(self.view, MarginFactor(20.0f))
    .widthIs(self.registerButton.currentBackgroundImage.size.width)
    .heightIs(self.registerButton.currentBackgroundImage.size.height);

    self.registerLabel.sd_layout
    .leftSpaceToView(self.view, MarginFactor(30.0f))
    .rightSpaceToView(self.view, MarginFactor(30.0f))
    .bottomSpaceToView(self.registerButton, MarginFactor(15.0f))
    .autoHeightRatio(0.0f);
}

- (void)addReactiveCocoa
{
//    [[[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(id value) {
//        return [self loginSignal];
//    }] subscribeNext:^(NSString *x) {
//        if ([x containsString:@"success"]) {
//            OMListViewController *controller = [[OMListViewController alloc] init];
//            [self.navigationController pushViewController:controller animated:YES];
//        } else {
//            [self.view showWithText:@"登录失败"];
//        }
//    }];

    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        OMListViewController *controller = [[OMListViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];

    [[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        OMRegisterViewController *controller = [[OMRegisterViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
}

- (RACSignal *)loginSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *request = [NSString stringWithFormat:@"fyzn2015#1#6#%@#%@#",self.nameField.text, self.passwordField.text];
        [[OMTCPNetWork sharedNetWork] sendMessage:request inView:self.view complete:^(NSString *string) {
            [subscriber sendNext:[string lowercaseString]];
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
