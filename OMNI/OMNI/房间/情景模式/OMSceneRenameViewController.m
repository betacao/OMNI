//
//  OMSceneRenameViewController.m
//  OMNI
//
//  Created by changxicao on 16/8/23.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMSceneRenameViewController.h"
#import "OMSceneSelectView.h"
#import "OMAlertView.h"
#import "OMScene.h"

@interface OMSceneRenameViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *topButton;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIView *sectionView;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) OMScene *scene;

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation OMSceneRenameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initView
{
    self.title = @"Scene Rename";
    self.topButton.backgroundColor = [UIColor clearColor];

    self.topLabel.font = FontFactor(15.0f);

    self.sectionView.backgroundColor = Color(@"6c8f57");
    self.sectionLabel.font = FontFactor(13.0f);

    self.tableView.backgroundColor = [UIColor clearColor];

    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_device_name"]];
    [leftImageView sizeToFit];
    leftImageView.origin = CGPointMake(MarginFactor(10.0f), 0.0f);
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0.0f, 0.0f, CGRectGetMaxX(leftImageView.frame), CGRectGetHeight(leftImageView.frame));
    [leftView addSubview:leftImageView];

    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_arrow"]];
    [rightImageView sizeToFit];
    UIView *rightView = [[UIView alloc] init];
    rightView.frame = CGRectMake(0.0f, 0.0f, CGRectGetMaxX(rightImageView.frame) + MarginFactor(10.0f), CGRectGetHeight(rightImageView.frame));
    [rightView addSubview:rightImageView];

    self.textField.leftView = leftView;
    self.textField.rightView = rightView;
    self.textField.leftViewMode = self.textField.rightViewMode = UITextFieldViewModeAlways;
    self.textField.backgroundColor = Color(@"9cc681");

    self.scrollView.bounces = NO;
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:self.scrollView]) {
            [self.scrollView addSubview:obj];
        }
    }];

    [self addRightNavigationItem:nil normalImage:[UIImage imageNamed:@"button_save_normal"] highlightedImage:[UIImage imageNamed:@"button_save_normal_down"]];
}

- (void)addAutoLayout
{
    self.topButton.sd_layout
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f)
    .topSpaceToView(self.scrollView, 0.0f)
    .heightIs(MarginFactor(60.0f));

    self.topImageView.sd_layout
    .centerYEqualToView(self.topButton)
    .heightIs(self.topImageView.image.size.height)
    .rightSpaceToView(self.scrollView, 0.0f)
    .widthIs(MarginFactor(60.0f));

    self.topLabel.sd_layout
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f)
    .heightRatioToView(self.topButton, 1.0f)
    .centerYEqualToView(self.topButton);

    self.sectionView.sd_layout
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f)
    .topSpaceToView(self.topButton, 0.0f)
    .heightIs(MarginFactor(24.0f));

    self.sectionLabel.sd_layout
    .leftSpaceToView(self.sectionView, MarginFactor(5.0f))
    .rightSpaceToView(self.sectionView, 0.0f)
    .centerYEqualToView(self.sectionView)
    .heightRatioToView(self.sectionView, 1.0f);

    self.textField.sd_layout
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f)
    .bottomSpaceToView(self.scrollView, MarginFactor(60.0f))
    .heightIs(MarginFactor(60.0f));

    self.tableView.sd_layout
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f)
    .topSpaceToView(self.sectionView, 0.0f)
    .bottomSpaceToView(self.textField, 0.0f);
}

- (void)addReactiveCocoa
{
    WEAK(self, weakSelf);
    UIButton *button = self.navigationItem.rightBarButtonItem.customView;
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (!self.scene) {
            [self.view showWithText:@"please choose scene"];
            return;
        }
        if (self.textField.text.length == 0) {
            [self.view showWithText:@"please input scene name"];
            return;
        }
        [OMGlobleManager changeSceneIcon:@[@(self.scene.sceneID), @(self.index), self.textField.text] inView:self.view block:^(NSArray *array) {
            if ([[array firstObject] isEqualToString:@"01"]) {
                [weakSelf.view showWithText:@"success"];
                [OMGlobleManager readSceneModeInfoInView:weakSelf.view block:^(NSArray *array) {
                    [OMGloble writeScene:array];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            } else {
                [weakSelf.view showWithText:@"failure"];
            }
        }];
    }];
    
    [[self.topButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        OMSceneSelectView *view = [[OMSceneSelectView alloc] init];
        view.block = ^(NSInteger index){
            weakSelf.scene = [[OMGloble readScene] objectAtIndex:index];
        };
        view.frame = CGRectMake(0.0f, 0.0f, SCREENWIDTH - MarginFactor(30.0f), SCREENHEIGHT - MarginFactor(30.0f));
        OMAlertView *alertView = [[OMAlertView alloc] initWithCustomView:view leftButtonTitle:nil rightButtonTitle:nil];
        [alertView show];
    }];
}


- (void)setScene:(OMScene *)scene
{
    _scene = scene;
    self.topLabel.text = scene.sceneName;
    self.textField.text = scene.sceneName;
    if (!self.dataArray) {
        self.dataArray = [NSMutableArray array];
        for (NSInteger i = 0; i < 16; i++) {
            NSString *imageName = @"";
            if (i == 14 || i == 15) {
                imageName = [NSString stringWithFormat:@"s_%ld_n",(long)i + 2];
            } else {
                imageName = [NSString stringWithFormat:@"s_%ld_n",(long)i + 1];
            }
            UIImage *image = [UIImage imageNamed:imageName];
            [self.dataArray addObject:image];
        }
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MarginFactor(40.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OMSceneRenameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OMSceneRenameTableViewCell"];
    if (!cell) {
        cell = [[OMSceneRenameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OMSceneRenameTableViewCell"];
    }
    NSInteger index = indexPath.row;
    cell.image = [self.dataArray objectAtIndex:index];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.index = indexPath.row;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

@interface OMSceneRenameTableViewCell ()

@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIView *spliteView;

@end

@implementation OMSceneRenameTableViewCell

- (void)initView
{
    self.contentView.backgroundColor = Color(@"9db48b");
    self.icon = [[UIImageView alloc] init];
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setImage:[UIImage imageNamed:@"remember_normal"] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:@"remember_press"] forState:UIControlStateSelected];
    self.spliteView = [[UIView alloc] init];
    self.spliteView.backgroundColor = [UIColor grayColor];
    [self.contentView sd_addSubviews:@[self.icon, self.button, self.spliteView]];
}

- (void)addAutoLayout
{
    self.icon.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, MarginFactor(80.0f))
    .widthIs(MarginFactor(30.0f))
    .heightEqualToWidth();

    self.button.sd_layout
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, MarginFactor(80.0f))
    .widthIs(MarginFactor(30.0f))
    .heightEqualToWidth();

    self.spliteView.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .bottomSpaceToView(self.contentView, 0.0f)
    .heightIs(1 / SCALE);
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.icon.image = image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.button.selected = selected;
}

@end
