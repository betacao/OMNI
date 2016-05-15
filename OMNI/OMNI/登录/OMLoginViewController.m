//
//  OMLoginViewController.m
//  OMNI
//
//  Created by changxicao on 16/5/13.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMLoginViewController.h"

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
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Account";
    label.font = FontFactor(17.0f);
    label.textColor = Color(@"64a23f");
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
}

- (void)initView
{
    self.titleLabel.text = @"Login";
    self.titleLabel.textColor = Color(@"ffffff");

    UIImageView *leftImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings_account"]];
    [leftImageView1 sizeToFit];

    UIImageView *leftImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_password"]];

    [leftImageView2 sizeToFit];

    self.nameField.leftView = leftImageView1;
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.leftView = leftImageView2;
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;

}

- (void)addAutoLayout
{
    self.titleLabel.sd_layout.topSpaceToView(self.view, 0.0f).leftSpaceToView(self.view, 0.0f).rightSpaceToView(self.view, 0.0f).heightIs(self.titleLabel.font.lineHeight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
