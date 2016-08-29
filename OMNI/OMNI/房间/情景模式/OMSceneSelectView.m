//
//  OMSceneSelectView.m
//  OMNI
//
//  Created by changxicao on 16/8/23.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMSceneSelectView.h"
#import "OMScene.h"

@interface OMSceneSelectView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UILabel *topLabel;
@property (strong, nonatomic) UIButton *confirmButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) NSArray *dataArray;

@property (assign, nonatomic) NSInteger index;

@end

@implementation OMSceneSelectView

- (void)initView
{
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor blackColor];

    self.topLabel = [[UILabel alloc] init];
    self.topLabel.textColor = [UIColor whiteColor];
    self.topLabel.font = FontFactor(15.0f);
    self.topLabel.text = @"Choose Scene";

    [self.topView addSubview:self.topLabel];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];

    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = Color(@"9d9d9d");

    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.backgroundColor = self.cancelButton.backgroundColor = Color(@"d9d9d9");
    self.confirmButton.layer.shadowColor = self.cancelButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.confirmButton.layer.shadowOffset = self.cancelButton.layer.shadowOffset = CGSizeMake(1 / SCALE, 1 / SCALE);
    self.confirmButton.titleLabel.font = self.cancelButton.titleLabel.font = FontFactor(14.0f);

    [self.confirmButton setTitle:@"confirm" forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self.bottomView addSubview:self.confirmButton];
    [self.bottomView addSubview:self.cancelButton];

    [self sd_addSubviews:@[self.tableView, self.topView, self.bottomView]];

    WEAK(self, weakSelf);
    [OMGloble readScene:^(NSArray *array) {
        weakSelf.dataArray = [NSArray arrayWithArray:array];
    }];
}

- (void)addAutoLayout
{
    self.topView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .topSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .heightIs(MarginFactor(60.0f));

    self.topLabel.sd_layout
    .leftSpaceToView(self.topView, MarginFactor(10.0f))
    .centerYEqualToView(self.topView)
    .rightSpaceToView(self.topView, MarginFactor(10.0f))
    .heightIs(self.topLabel.font.lineHeight);

    self.bottomView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .bottomSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .heightIs(MarginFactor(60.0f));

    self.cancelButton.sd_layout
    .leftSpaceToView(self.bottomView, MarginFactor(10.0f))
    .bottomSpaceToView(self.bottomView, MarginFactor(10.0f))
    .topSpaceToView(self.bottomView, MarginFactor(10.0f))
    .widthRatioToView(self.bottomView, 0.45f);

    self.confirmButton.sd_layout
    .rightSpaceToView(self.bottomView, MarginFactor(10.0f))
    .bottomSpaceToView(self.bottomView, MarginFactor(10.0f))
    .topSpaceToView(self.bottomView, MarginFactor(10.0f))
    .widthRatioToView(self.bottomView, 0.45f);

    self.tableView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .topSpaceToView(self.topView, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .bottomSpaceToView(self.bottomView, 0.0f);
}

- (void)addReactiveCocoa
{
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        OMAlertView *superView = (OMAlertView *)self.superview;
        [superView dismissAlert];
    }];

    [[self.confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        OMAlertView *superView = (OMAlertView *)self.superview;
        [superView dismissAlert];
        if (self.block) {
            self.block(self.index);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MarginFactor(60.0f);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OMSceneSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OMSceneSelectTableViewCell"];
    if (!cell) {
        cell = [[OMSceneSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OMSceneSelectTableViewCell"];
    }
    OMScene *scene = [self.dataArray objectAtIndex:indexPath.row];
    cell.string = scene.sceneName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.index = indexPath.row;
}

@end

@interface OMSceneSelectTableViewCell()

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIButton *button;

@end

@implementation OMSceneSelectTableViewCell

- (void)initView
{
    self.label = [[UILabel alloc] init];

    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setImage:[UIImage imageNamed:@"remember_normal"] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:@"remember_press"] forState:UIControlStateSelected];
    [self.contentView sd_addSubviews:@[self.label, self.button]];
}

- (void)addAutoLayout
{
    self.label.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(15.0f), 0.0f, 0.0f));

    self.button.sd_layout
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, MarginFactor(30.0f))
    .widthIs(self.button.currentImage.size.width)
    .heightIs(self.button.currentImage.size.height);
}


- (void)setString:(NSString *)string
{
    _string = string;
    self.label.text = string;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.button.selected = selected;
}

@end
