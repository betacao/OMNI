//
//  OMSceneConfigViewController.m
//  OMNI
//
//  Created by changxicao on 16/8/24.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMSceneConfigViewController.h"
#import "OMRoomViewController.h"
#import "OMSceneSelectView.h"
#import "OMScene.h"

@interface OMSceneConfigViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *topButton;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) OMScene *scene;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation OMSceneConfigViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initView
{
    self.title = @"Scene Config";
    self.topButton.backgroundColor = [UIColor clearColor];

    self.topLabel.font = FontFactor(15.0f);

    self.scrollView.backgroundColor = Color(@"80a165");

    [self addRightNavigationItem:nil normalImage:[UIImage imageNamed:@"button_save_normal"] highlightedImage:[UIImage imageNamed:@"button_save_normal_down"]];
}

- (void)addAutoLayout
{
    self.topButton.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(60.0f));

    self.topImageView.sd_layout
    .centerYEqualToView(self.topButton)
    .heightIs(self.topImageView.image.size.height)
    .rightSpaceToView(self.view, 0.0f)
    .widthIs(MarginFactor(60.0f));

    self.topLabel.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightRatioToView(self.topButton, 1.0f)
    .centerYEqualToView(self.topButton);

    self.scrollView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.topButton, 0.0f)
    .bottomSpaceToView(self.view, MarginFactor(60.0f));
}

- (void)addReactiveCocoa
{
    WEAK(self, weakSelf);
    [[self.topButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        OMSceneSelectView *view = [[OMSceneSelectView alloc] init];
        view.block = ^(NSInteger index){
            weakSelf.scene = [[OMGloble readScene] objectAtIndex:index];
        };
        view.frame = CGRectMake(0.0f, 0.0f, SCREENWIDTH - MarginFactor(30.0f), SCREENHEIGHT - MarginFactor(30.0f));
        OMAlertView *alertView = [[OMAlertView alloc] initWithCustomView:view leftButtonTitle:nil rightButtonTitle:nil];
        [alertView show];
    }];

    UIButton *button = self.navigationItem.rightBarButtonItem.customView;
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [OMGlobleManager setSceneModeConfig:[weakSelf requestString] inView:self.view block:^(NSArray *array) {
            [weakSelf.view showWithText:@"operation success"];
            for (OMBaseViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[OMRoomViewController class]]) {
                    [controller loadData];
                }
            }
        }];
    }];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)setScene:(OMScene *)scene
{
    _scene = scene;
    WEAK(self, weakSelf);
    self.topLabel.text = scene.sceneName;
    
    [OMGlobleManager readSceneModeConfig:[NSString stringWithFormat:@"%ld",(long)scene.modeID] inView:self.view block:^(NSArray *array) {
        [weakSelf.dataArray removeAllObjects];
        if (array.count > 1) {
            NSInteger count = [[array firstObject] integerValue];
            for (NSInteger i = 0; i < count; i++) {
                OMRoomScene *roomScene = [[OMRoomScene alloc] init];
                roomScene.roomName = [array objectAtIndex:i * 4 + 1];
                roomScene.deviceName = [array objectAtIndex:i * 4 + 2];
                roomScene.deviceID = [array objectAtIndex:i * 4 + 3];
                roomScene.state = [[array objectAtIndex:i * 4 + 4] integerValue];

                roomScene.displayState = @"open";
                [weakSelf.dataArray addObject:roomScene];

                roomScene = [[OMRoomScene alloc] init];
                roomScene.roomName = [array objectAtIndex:i * 4 + 1];
                roomScene.deviceName = [array objectAtIndex:i * 4 + 2];
                roomScene.deviceID = [array objectAtIndex:i * 4 + 3];
                roomScene.state = [[array objectAtIndex:i * 4 + 4] integerValue];

                roomScene.displayState = @"close";
                [weakSelf.dataArray addObject:roomScene];
            }
        }
        [weakSelf resetView];
    }];
}

- (void)resetView
{
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[OMSceneConfigView class]]) {
            [view removeFromSuperview];
        }
    }
    UIView *lastView = nil;
    for (NSInteger i = 0; i < self.dataArray.count / 2; i++) {
        NSArray *array = @[[self.dataArray objectAtIndex:2 * i], [self.dataArray objectAtIndex:2 * i + 1]];
        OMSceneConfigView *view = [[OMSceneConfigView alloc] init];
        view.array = array;
        [self.scrollView addSubview:view];
        view.sd_layout
        .leftSpaceToView(self.scrollView, 0.0f)
        .rightSpaceToView(self.scrollView, 0.0f)
        .topSpaceToView(lastView ? lastView : self.scrollView, 0.0f)
        .heightIs(MarginFactor(80.0f));
        lastView = view;
    }
    if (lastView) {
        [self.scrollView setupAutoContentSizeWithBottomView:lastView bottomMargin:0.0f];
    }
}

- (NSString *)requestString
{
    NSString *string = @"";
    for (OMSceneConfigView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[OMSceneConfigView class]]) {
            string = [string stringByAppendingString:[view requestString]];
        }
    }
    string = [NSString stringWithFormat:@"set_mode_action$%@$%@$%@", @(self.scene.modeID), @(self.dataArray.count  / 2), string];
    return string;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end


@interface OMSceneConfigView()

@property (strong, nonatomic) UILabel *topLabel;
@property (strong, nonatomic) UIButton *topButton;
@property (strong, nonatomic) UIView *topSpliteView;

@property (strong, nonatomic) UILabel *bottomLabel;
@property (strong, nonatomic) UIButton *bottomButton;
@property (strong, nonatomic) UIView *bottomSpliteView;

@property (strong, nonatomic) OMRoomScene *topRoomScene;
@property (strong, nonatomic) OMRoomScene *bottonRoomScene;

@end

@implementation OMSceneConfigView

- (void)initView
{
    self.backgroundColor = Color(@"9db48b");

    self.topLabel = [[UILabel alloc] init];
    self.topLabel.font = FontFactor(14.0f);
    self.topLabel.textColor = [UIColor whiteColor];

    self.topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.topButton setImage:[UIImage imageNamed:@"remember_normal"] forState:UIControlStateNormal];
    [self.topButton setImage:[UIImage imageNamed:@"remember_press"] forState:UIControlStateSelected];

    self.topSpliteView = [[UIView alloc] init];
    self.topSpliteView.backgroundColor = [UIColor grayColor];

    [self sd_addSubviews:@[self.topLabel, self.topButton, self.topSpliteView]];

    self.bottomLabel = [[UILabel alloc] init];
    self.bottomLabel.font = FontFactor(14.0f);
    self.bottomLabel.textColor = [UIColor whiteColor];

    self.bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomButton setImage:[UIImage imageNamed:@"remember_normal"] forState:UIControlStateNormal];
    [self.bottomButton setImage:[UIImage imageNamed:@"remember_press"] forState:UIControlStateSelected];

    self.bottomSpliteView = [[UIView alloc] init];
    self.bottomSpliteView.backgroundColor = [UIColor grayColor];

    [self sd_addSubviews:@[self.bottomLabel, self.bottomButton, self.bottomSpliteView]];
}

- (void)addAutoLayout
{
    self.topLabel.sd_layout
    .topSpaceToView(self, 0.0f)
    .leftSpaceToView(self, MarginFactor(20.0f))
    .heightRatioToView(self, 0.5f)
    .widthRatioToView(self, 1.0f);

    self.topButton.sd_layout
    .centerYEqualToView(self.topLabel)
    .rightSpaceToView(self, MarginFactor(20.0f))
    .widthIs(MarginFactor(30.0f))
    .heightEqualToWidth();

    self.topSpliteView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .topSpaceToView(self.topLabel, 0.0f)
    .heightIs(1 / SCALE);

    self.bottomSpliteView.sd_layout
    .leftEqualToView(self.topSpliteView)
    .rightEqualToView(self.topSpliteView)
    .bottomSpaceToView(self, 0.0f)
    .heightIs(1 / SCALE);

    self.bottomLabel.sd_layout
    .topSpaceToView(self.topSpliteView, 0.0f)
    .leftEqualToView(self.topLabel)
    .bottomSpaceToView(self.bottomSpliteView, 0.0f)
    .widthRatioToView(self, 1.0f);

    self.bottomButton.sd_layout
    .centerYEqualToView(self.bottomLabel)
    .rightEqualToView(self.topButton)
    .widthRatioToView(self.topButton, 1.0f)
    .heightEqualToWidth();
}

- (void)setArray:(NSArray<OMRoomScene *> *)array
{
    _array = array;
    self.topRoomScene = [array firstObject];
    self.bottonRoomScene = [array lastObject];

    self.topLabel.text = [array firstObject].displayName;
    self.bottomLabel.text = [array lastObject].displayName;
    self.topButton.selected = ([array firstObject].state == OMRoomSceneStateOpen);
    self.bottomButton.selected = ([array lastObject].state == OMRoomSceneStateClose);
}

- (NSString *)requestString
{
    NSString *state = @"0";
    if (self.topButton.isSelected) {
        state = @"1";
    }
    if (self.bottomButton.isSelected) {
        state = @"0";
    }
    if (!self.topButton.isSelected && !self.bottomButton.isSelected ) {
        state = @"2";
    }
    return [NSString stringWithFormat:@"%@$%@$", self.topRoomScene.deviceID, state];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.topLabel.frame, touchPoint)) {
        self.topButton.selected = !self.topButton.isSelected;
        if (self.bottomButton.isSelected) {
            self.bottomButton.selected = !self.bottomButton.isSelected;
        }
    } else {
        self.bottomButton.selected = !self.bottomButton.isSelected;
        if (self.topButton.isSelected) {
            self.topButton.selected = !self.topButton.isSelected;
        }
    }
}


@end
