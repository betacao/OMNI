//
//  OMAddTimingViewController.m
//  OMNI
//
//  Created by changxicao on 16/7/5.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMAddTimingViewController.h"

@interface OMAddTimingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OMAddTimingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRightNavigationItem:nil normalImage:[UIImage imageNamed:@"button_save_normal"] highlightedImage:[UIImage imageNamed:@"button_save_normal_down"]];
}

- (void)initView
{
    self.title = @"Add Timing";
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;

        default:
            return 2;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end


@interface OMAddTimingTableViewCell()

@end

@implementation OMAddTimingTableViewCell



@end
