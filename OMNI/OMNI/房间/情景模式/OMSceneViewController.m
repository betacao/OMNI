//
//  OMSceneViewController.m
//  OMNI
//
//  Created by changxicao on 16/8/22.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMSceneViewController.h"
#import "OMSceneRenameViewController.h"
#import "OMSceneConfigViewController.h"
#import "OMScene.h"

@interface OMSceneViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *spliteView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation OMSceneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadData];
}

- (void)initView
{
    self.contentView.backgroundColor = ColorA(@"54a979", 0.8);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = FontFactor(15.0f);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.bounces = NO;

    self.spliteView.backgroundColor = [UIColor whiteColor];
}

- (void)addAutoLayout
{
    self.contentView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.tableView.sd_resetLayout
    .rightSpaceToView(self.contentView, 0.0f)
    .leftSpaceToView(self.contentView, 0.0f)
    .centerYEqualToView(self.contentView)
    .offset(MarginFactor(-60.0f))
    .heightIs(MarginFactor(324.0f));

    self.titleLabel.sd_layout
    .centerXEqualToView(self.contentView)
    .bottomSpaceToView(self.tableView, MarginFactor(20.0f))
    .heightIs(self.titleLabel.font.lineHeight);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];
    self.titleLabel.text = @"SCENE";

    self.spliteView.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .topSpaceToView(self.tableView, 0.0f)
    .heightIs(1.0f);

    self.leftButton.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(50.0f))
    .topSpaceToView(self.spliteView, MarginFactor(30.0f))
    .widthIs(self.leftButton.currentImage.size.width)
    .heightIs(self.leftButton.currentImage.size.height);

    self.rightButton.sd_layout
    .rightSpaceToView(self.contentView, MarginFactor(50.0f))
    .topSpaceToView(self.spliteView, MarginFactor(30.0f))
    .widthIs(self.rightButton.currentImage.size.width)
    .heightIs(self.rightButton.currentImage.size.height);
}

- (void)addReactiveCocoa
{
    [[self.leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        OMSceneConfigViewController *controller = [[OMSceneConfigViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    
    [[self.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        OMSceneRenameViewController *controller = [[OMSceneRenameViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
}

- (void)loadData
{
    [self.dataArray removeAllObjects];
    NSArray *array = [OMGloble readScene];
    if (array) {
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
    }
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count / 2.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MarginFactor(40.0f);
}

- (OMSceneTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OMSceneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OMSceneTableViewCell"];
    if (!cell) {
        cell = [[OMSceneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OMSceneTableViewCell"];
    }
    NSInteger index = 2.0f * indexPath.section + indexPath.row;
    cell.scene = [self.dataArray objectAtIndex:index];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger index = 2.0f * indexPath.section + indexPath.row;
    OMScene *scene = [self.dataArray objectAtIndex:index];
    NSString *sceneID = [NSString stringWithFormat:@"%ld", (long)scene.sceneID];
    WEAK(self, weakSelf);
    [OMGlobleManager changeToScene:sceneID inView:self.navigationController.view block:^(NSArray *array) {
        if ([[array firstObject] isEqualToString:@"01"]) {
            [weakSelf.navigationController.view showWithText:@"sent!"];
        }
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

@interface OMSceneTableViewCell()

@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *name;

@end

@implementation OMSceneTableViewCell

- (void)initView
{
    self.backgroundColor = self.contentView.backgroundColor = [UIColor clearColor];
    self.icon = [[UIImageView alloc] init];
    self.name = [[UILabel alloc] init];
    self.name.textColor = [UIColor whiteColor];
    self.name.font = FontFactor(14.0f);
    [self.contentView sd_addSubviews:@[self.icon, self.name]];
}

- (void)addAutoLayout
{
    self.icon.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, MarginFactor(30.0f))
    .widthIs(MarginFactor(30.0f))
    .heightIs(MarginFactor(30.0f));

    self.name.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.icon, MarginFactor(10.0f))
    .heightIs(self.name.font.lineHeight);
    [self.name setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];
}

- (void)setScene:(OMScene *)scene
{
    _scene = scene;
    self.icon.image = scene.sceneImageN;
    self.name.text = scene.sceneName;
}

@end
