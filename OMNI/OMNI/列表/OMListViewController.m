//
//  OMListViewController.m
//  OMNI
//
//  Created by changxicao on 16/5/16.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMListViewController.h"
#import "OMListTableViewCell.h"
#import "OMWifiConfigViewController.h"
#import "OMGuideViewController.h"
#import "OMRoomViewController.h"
#import "OMRoomViewController.h"
#import "OMGuideViewController.h"
#import "OMAddTimingViewController.h"

@interface OMListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *footerButton;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation OMListViewController

+ (instancetype)shareController
{
    static OMListViewController *controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] init];
    });
    return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Gateway List";
}

- (void)initView
{
    self.dataArray = [NSMutableArray array];

    [self addRightNavigationItem:nil normalImage:[UIImage imageNamed:@"button_edit_help"] highlightedImage:[UIImage imageNamed:@"button_edit_help_down"]];
    self.tableView.tableFooterView = self.footerView;
}

- (void)addAutoLayout
{
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.footerView.sd_layout
    .centerXEqualToView(self.footerButton.superview)
    .widthIs(SCREENWIDTH)
    .heightIs(MarginFactor(90.0f));

    self.footerButton.sd_layout
    .centerXEqualToView(self.footerView)
    .centerYEqualToView(self.footerView)
    .widthIs(self.footerButton.currentBackgroundImage.size.width)
    .heightIs(self.footerButton.currentBackgroundImage.size.height);

    self.tableView.tableFooterView = self.footerView;

}

- (void)loadData
{
    WEAK(self, weakSelf);
    [OMGlobleManager getListInView:self.view block:^(NSString *string) {
        [weakSelf.dataArray removeAllObjects];
        NSArray *array = [string componentsSeparatedByString:@"#"];
        if (array.count > 2) {
            array = [array subarrayWithRange:NSMakeRange(2, array.count - 2)];
            for (NSInteger i = 0; i < array.count / 3; i++) {
                NSArray *subArray = [array subarrayWithRange:NSMakeRange(i * 3, 3)];
                OMDevice *device = [[OMDevice alloc] init];
                device.deviceID = [subArray firstObject];
                device.deviceNumber = [subArray objectAtIndex:1];
                device.deviceState = [subArray lastObject];
                [weakSelf.dataArray addObject:device];
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)backButtonClick:(UIButton *)button
{
    exit(0);
}

- (void)rightButtonClick:(UIButton *)button
{
    OMGuideViewController *controller = [[OMGuideViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)footerButtonClick:(UIButton *)button
{
    OMWifiConfigViewController *controller = [[OMWifiConfigViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark ------tableview代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MarginFactor(120.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OMListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OMListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OMListTableViewCell" owner:self options:nil] firstObject];
    }
    cell.device = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OMRoomViewController *controller = [[OMRoomViewController alloc] init];
    controller.device = [self.dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
