//
//  OMAddRoomDeviceViewController.m
//  OMNI
//
//  Created by changxicao on 16/6/6.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMAddRoomDeviceViewController.h"

@interface OMAddRoomDeviceViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OMAddRoomDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Add a new device";
}

- (void)initView
{
    self.tipLabel.textColor = [UIColor lightGrayColor];
    self.tipLabel.font = FontFactor(12.0f);

    self.deviceTypeLabel.textColor = [UIColor whiteColor];
    self.deviceTypeLabel.font = FontFactor(16.0f);

    self.button.titleLabel.font = FontFactor(14.0f);
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    

}

- (void)addAutoLayout
{
    self.tipLabel.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f)
    .autoHeightRatio(0.0f);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
