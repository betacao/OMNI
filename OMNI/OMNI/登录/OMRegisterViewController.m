//
//  OMRegisterViewController.m
//  OMNI
//
//  Created by changxicao on 16/5/16.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMRegisterViewController.h"

@interface OMRegisterViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIImageView *middleImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UITextField *confirmField;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation OMRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Create new acc.";
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


    UIView *leftView3 = [[UIView alloc] init];
    UIImageView *leftImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_password"]];
    [leftView3 addSubview:leftImageView3];
    leftImageView3.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(10.0f), 0.0f, MarginFactor(10.0f)));

    leftView3.sd_layout
    .heightIs(leftImageView3.image.size.height)
    .widthIs(leftImageView3.image.size.width + MarginFactor(20.0f));

    self.nameField.leftView = leftView1;
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.leftView = leftView2;
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.confirmField.leftView = leftView3;
    self.confirmField.leftViewMode = UITextFieldViewModeAlways;

    self.lineView1.backgroundColor = self.lineView2.backgroundColor = Color(@"c3ce9f");

    UIImage *image = [UIImage imageNamed:@"input"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch];
    self.middleImageView.image = image;
}

- (void)addAutoLayout
{
    self.titleLabel.sd_layout
    .topSpaceToView(self.view, MarginFactor(20.0f))
    .leftSpaceToView(self.view, MarginFactor(20.0f))
    .rightSpaceToView(self.view, MarginFactor(20.0f))
    .autoHeightRatio(0.0f);

    self.nameField.sd_layout
    .leftSpaceToView(self.middleView, 0.0f)
    .rightSpaceToView(self.middleView, 0.0f)
    .topSpaceToView(self.middleView, 0.0f)
    .heightIs(MarginFactor(60.0f));

    self.lineView1.sd_layout
    .leftSpaceToView(self.middleView, 0.0f)
    .rightSpaceToView(self.middleView, 0.0f)
    .topSpaceToView(self.nameField, 0.0f)
    .heightIs(1.0f / SCALE);

    self.passwordField.sd_layout
    .leftSpaceToView(self.middleView, 0.0f)
    .rightSpaceToView(self.middleView, 0.0f)
    .topSpaceToView(self.lineView1, 0.0f)
    .heightRatioToView(self.nameField, 1.0f);

    self.lineView2.sd_layout
    .leftSpaceToView(self.middleView, 0.0f)
    .rightSpaceToView(self.middleView, 0.0f)
    .topSpaceToView(self.passwordField, 0.0f)
    .heightIs(1.0f / SCALE);

    self.confirmField.sd_layout
    .leftSpaceToView(self.middleView, 0.0f)
    .rightSpaceToView(self.middleView, 0.0f)
    .topSpaceToView(self.lineView2, 0.0f)
    .heightRatioToView(self.nameField, 1.0f);

    self.middleView.sd_layout
    .leftSpaceToView(self.view, MarginFactor(20.0f))
    .rightSpaceToView(self.view, MarginFactor(30.0f))
    .topSpaceToView(self.titleLabel, MarginFactor(20.0f));
    [self.middleView setupAutoHeightWithBottomView:self.confirmField bottomMargin:0.0f];

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
    [[[self.commitButton rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(id value) {
        return [self commitSignal];
    }] subscribeNext:^(id x) {

    }];
}

- (RACSignal *)commitSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [OMGlobleManager regist:@[] inView:self.view block:^(NSString *string) {
            [subscriber sendNext:string];
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
