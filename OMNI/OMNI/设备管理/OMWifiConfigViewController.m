//
//  OMWifiConfigViewController.m
//  OMNI
//
//  Created by changxicao on 16/5/23.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMWifiConfigViewController.h"

@interface OMWifiConfigViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIButton *configButton;
@property (weak, nonatomic) IBOutlet UITextField *wifiNameField;
@property (weak, nonatomic) IBOutlet UITextField *wifiPWDField;

@end

@implementation OMWifiConfigViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Wifi Config";
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
    UIImageView *leftImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_ssid"]];
    [leftView2 addSubview:leftImageView2];
    leftImageView2.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(10.0f), 0.0f, MarginFactor(10.0f)));

    leftView2.sd_layout
    .heightIs(leftImageView2.image.size.height)
    .widthIs(leftImageView2.image.size.width + MarginFactor(20.0f));


    self.wifiNameField.leftView = leftView1;
    self.wifiNameField.leftViewMode = UITextFieldViewModeAlways;
    self.wifiPWDField.leftView = leftView2;
    self.wifiPWDField.leftViewMode = UITextFieldViewModeAlways;

    UIImage *image1 = self.wifiNameField.background;
    image1 = [image1 resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch];
    self.wifiNameField.background = image1;

    UIImage *image2 = self.wifiNameField.background;
    image2 = [image2 resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch];
    self.wifiPWDField.background = image2;
}

- (void)addAutoLayout
{
    self.imageView.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, MarginFactor(50.0f))
    .widthIs(self.imageView.image.size.width)
    .heightIs(self.imageView.image.size.height);

    self.introduceLabel.sd_layout
    .leftSpaceToView(self.view, MarginFactor(20.0f))
    .rightSpaceToView(self.view, MarginFactor(20.0f))
    .topSpaceToView(self.imageView, MarginFactor(10.0f))
    .autoHeightRatio(0.0f);

    self.wifiNameField.sd_layout
    .leftSpaceToView(self.view, MarginFactor(20.0f))
    .rightSpaceToView(self.view, MarginFactor(20.0f))
    .topSpaceToView(self.introduceLabel, MarginFactor(20.0f))
    .heightIs(MarginFactor(40.0f));

    self.wifiPWDField.sd_layout
    .leftSpaceToView(self.view, MarginFactor(20.0f))
    .rightSpaceToView(self.view, MarginFactor(20.0f))
    .topSpaceToView(self.wifiNameField, MarginFactor(20.0f))
    .heightIs(MarginFactor(40.0f));

    self.configButton.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.wifiPWDField, MarginFactor(30.0f))
    .widthIs(self.configButton.currentBackgroundImage.size.width)
    .heightIs(self.configButton.currentBackgroundImage.size.height);

    self.bottomLabel.sd_layout
    .leftSpaceToView(self.view, MarginFactor(20.0f))
    .rightSpaceToView(self.view, MarginFactor(20.0f))
    .topSpaceToView(self.configButton, MarginFactor(10.0f))
    .autoHeightRatio(0.0f);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
