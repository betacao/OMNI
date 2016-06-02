//
//  OMListViewController.m
//  OMNI
//
//  Created by changxicao on 16/5/16.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMListViewController.h"
#import "OMListTableViewCell.h"
#import "OMAddAccountViewController.h"

@interface OMListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addDeviceButton;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *guideButton;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation OMListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Account";
}

- (void)initView
{
    [self addRightNavigationItem:nil normalImage:[UIImage imageNamed:@"button_edit_normal"] highlightedImage:[UIImage imageNamed:@"button_edit_normal_down"]];
    self.tableView.tableFooterView = self.footerView;
}

- (void)addAutoLayout
{
    self.tableView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.guideButton, MarginFactor(15.0f));

    self.footerView.sd_layout
    .centerXEqualToView(self.addDeviceButton.superview)
    .widthIs(SCREENWIDTH)
    .heightIs(MarginFactor(90.0f));

    self.addDeviceButton.sd_layout
    .centerXEqualToView(self.footerView)
    .centerYEqualToView(self.footerView)
    .widthIs(self.addDeviceButton.currentBackgroundImage.size.width)
    .heightIs(self.addDeviceButton.currentBackgroundImage.size.height);

    self.guideButton.sd_layout
    .centerXEqualToView(self.view)
    .bottomSpaceToView(self.view, MarginFactor(15.0f))
    .widthIs(self.guideButton.currentBackgroundImage.size.width)
    .heightIs(self.guideButton.currentBackgroundImage.size.height);
    
}

- (void)loadData
{
//[NSString stringWithFormat:@"%@%@#",kListAddress,kAppDelegate.userID]
}

- (void)backButtonClick:(UIButton *)button
{
    exit(0);
}

- (IBAction)addAccount:(UIButton *)sender
{
    OMAddAccountViewController *controller = [[OMAddAccountViewController alloc] init];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
