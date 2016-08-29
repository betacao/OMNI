//
//  OMMutibleSlider.m
//  OMNI
//
//  Created by changxicao on 16/8/2.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMMutibleSlider.h"
#import "OMAlarmView.h"
#import "UIViewController+Extend.h"
#import "OMMutiableLightThemeViewController.h"
#import "OMMutiableLightColorViewController.h"

@interface OMMutibleSlider()

@property (strong, nonatomic) UISegmentedControl *segmentControl;
@property (strong, nonatomic) OMDynamicControlView *dynamicControlView;
@property (strong, nonatomic) OMStaticControlView *staticControlView;
@property (strong, nonatomic) OMMutibleCircleView *circleView;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation OMMutibleSlider

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];
    self.segmentControl = [[UISegmentedControl alloc] init];
    self.segmentControl.tintColor = [UIColor clearColor];
    UIImage *dynamic = [[UIImage imageNamed:@"dynamic_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.segmentControl insertSegmentWithImage:dynamic atIndex:0 animated:NO];

    UIImage *static_ = [[UIImage imageNamed:@"static_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.segmentControl insertSegmentWithImage:static_ atIndex:1 animated:NO];

    self.dynamicControlView = [[OMDynamicControlView alloc] init];

    self.staticControlView = [[OMStaticControlView alloc] init];
    self.staticControlView.hidden = YES;

    self.circleView = [[OMMutibleCircleView alloc] init];

    [self sd_addSubviews:@[self.dynamicControlView, self.staticControlView, self.circleView, self.segmentControl]];
}

- (void)addAutoLayout
{
    CGFloat width = [self.segmentControl imageForSegmentAtIndex:0].size.width + [self.segmentControl imageForSegmentAtIndex:1].size.width;
    CGFloat height = MAX([self.segmentControl imageForSegmentAtIndex:0].size.height, [self.segmentControl imageForSegmentAtIndex:1].size.height);
    self.segmentControl.sd_layout
    .topSpaceToView(self, MarginFactor(30.0f))
    .centerXEqualToView(self)
    .widthIs(width)
    .heightIs(height);

    self.dynamicControlView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .topSpaceToView(self.segmentControl, 0.0f)
    .heightIs(MarginFactor([UIImage imageNamed:@"choose_scene"].size.height));

    self.staticControlView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .topSpaceToView(self.segmentControl, 0.0f)
    .heightIs(MarginFactor([UIImage imageNamed:@"choose_color"].size.height));

    self.circleView.sd_layout
    .topSpaceToView(self.dynamicControlView, -MarginFactor(100.0f))
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .bottomSpaceToView(self, 0.0f);
}

- (void)addReactiveCocoa
{
    [[self.segmentControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl *segmentControl) {
        NSInteger index = segmentControl.selectedSegmentIndex;
        self.selectedIndex = index;
    }];
}

- (void)setRoomDevice:(OMRoomDevice *)roomDevice
{
    _roomDevice = roomDevice;
    self.circleView.roomDevice = roomDevice;
    self.dynamicControlView.roomDevice = roomDevice;
    self.staticControlView.roomDevice = roomDevice;
    [self loadData];
}

- (void)setTableViewCell:(OMRoomTableViewCell *)tableViewCell
{
    _tableViewCell = tableViewCell;
    self.circleView.tableViewCell = tableViewCell;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    if (selectedIndex == 1) {
        [self.segmentControl setImage:[[UIImage imageNamed:@"dynamic_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
        [self.segmentControl setImage:[[UIImage imageNamed:@"static_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
    } else {
        [self.segmentControl setImage:[[UIImage imageNamed:@"dynamic_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
        [self.segmentControl setImage:[[UIImage imageNamed:@"static_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
    }
    self.dynamicControlView.hidden = selectedIndex;
    self.staticControlView.hidden = !selectedIndex;
}

- (void)loadData
{
    if (self.roomDevice) {
        [OMGlobleManager readColorLightState:self.roomDevice.roomDeviceID inView:self.superview block:^(NSArray *array) {
            if ([[array firstObject] isEqualToString:@"SUCCESS"]) {
                self.selectedIndex = [[array objectAtIndex:2] integerValue];
                self.staticControlView.colorIndex = [[array objectAtIndex:5] integerValue];
                self.dynamicControlView.speed = [[array objectAtIndex:6] floatValue];
                self.dynamicControlView.theme = [[array objectAtIndex:7] integerValue];
            }
            self.circleView.dataArray = array;
        }];
    }
}

@end


@interface OMDynamicControlView()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *sceneLabel;
@property (strong, nonatomic) UILabel *sceneTypeLabel;
@property (strong, nonatomic) UIButton *detailButton;
@property (strong, nonatomic) UILabel *speedLabel;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) OMSlider *slider;

@end

@implementation OMDynamicControlView


- (void)initView
{
    self.imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"choose_scene"] resizableImageWithCapInsets:UIEdgeInsetsMake(35.0f, 10.0f, 35.0f, 10.0f) resizingMode:UIImageResizingModeStretch]];
    self.sceneLabel = [[UILabel alloc] init];
    self.sceneLabel.text = @"Scene";

    self.sceneTypeLabel = [[UILabel alloc] init];
    self.sceneTypeLabel.text = @"happy";

    self.detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.detailButton setImage:[UIImage imageNamed:@"rgb_light_detail"] forState:UIControlStateNormal];
    [self.detailButton setEnlargeEdgeWithTop:10.0f right:10.0f bottom:10.0f left:100.0f];

    self.speedLabel = [[UILabel alloc] init];
    self.speedLabel.text = @"Blink speed";

    self.slider = [[OMSlider alloc] init];

    self.sceneLabel.font = self.sceneTypeLabel.font = self.speedLabel.font = FontFactor(13.0f);
    self.sceneLabel.textColor = self.sceneTypeLabel.textColor = self.speedLabel.textColor = Color(@"a9b82f");

    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setImage:[UIImage imageNamed:@"button_rgb_light_left"] forState:UIControlStateNormal];
    [self.leftButton setImage:[UIImage imageNamed:@"button_rgb_light_left_down"] forState:UIControlStateHighlighted];

    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setImage:[UIImage imageNamed:@"button_rgb_light_right"] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"button_rgb_light_right_down"] forState:UIControlStateHighlighted];

    [self sd_addSubviews:@[self.imageView, self.detailButton, self.sceneLabel, self.sceneTypeLabel, self.speedLabel, self.slider, self.leftButton, self.rightButton]];
}

- (void)addAutoLayout
{
    self.imageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.detailButton.sd_layout
    .rightSpaceToView(self, MarginFactor(10.0f))
    .topSpaceToView(self, MarginFactor(35.0f))
    .widthIs(self.detailButton.currentImage.size.width)
    .heightIs(self.detailButton.currentImage.size.height);

    self.sceneTypeLabel.sd_layout
    .rightSpaceToView(self.detailButton, MarginFactor(10.0f))
    .centerYEqualToView(self.detailButton)
    .heightIs(self.sceneTypeLabel.font.lineHeight);
    [self.sceneTypeLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.sceneLabel.sd_layout
    .leftSpaceToView(self, MarginFactor(30.0f))
    .centerYEqualToView(self.detailButton)
    .heightIs(self.sceneLabel.font.lineHeight);
    [self.sceneLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.speedLabel.sd_layout
    .leftEqualToView(self.sceneLabel)
    .bottomSpaceToView(self.slider, MarginFactor(5.0f))
    .heightIs(self.speedLabel.font.lineHeight);
    [self.speedLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.leftButton.sd_layout
    .leftEqualToView(self.speedLabel)
    .bottomSpaceToView(self, MarginFactor(35.0f))
    .widthIs(self.leftButton.currentImage.size.width)
    .heightIs(self.leftButton.currentImage.size.height);

    self.rightButton.sd_layout
    .rightSpaceToView(self, MarginFactor(10.0f))
    .centerYEqualToView(self.leftButton)
    .widthIs(self.rightButton.currentImage.size.width)
    .heightIs(self.rightButton.currentImage.size.height);

    self.slider.sd_layout
    .centerYEqualToView(self.leftButton)
    .rightSpaceToView(self.rightButton, MarginFactor(10.0f))
    .leftSpaceToView(self.leftButton, MarginFactor(10.0f));
}

- (void)addReactiveCocoa
{
    [[self.leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        CGFloat value = self.slider.value;
        value -= 1.0f;
        value = MAX(value, self.slider.minimumValue);
        [self.slider setValue:value animated:NO];
    }];

    [[self.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        CGFloat value = self.slider.value;
        value += 1.0f;
        value = MIN(value, self.slider.maximumValue);
        [self.slider setValue:value animated:NO];
    }];

    WEAK(self, weakSelf);
    [[self.detailButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        OMMutiableLightThemeViewController *controller = [[OMMutiableLightThemeViewController alloc] init];
        controller.theme = self.theme;
        controller.roomDevice = self.roomDevice;
        controller.block = ^(OMDynamicTheme theme){
            weakSelf.theme = theme;
        };
        [[UIViewController findSourceViewController:self].navigationController pushViewController:controller animated:YES];
    }];
}

- (void)setRoomDevice:(OMRoomDevice *)roomDevice
{
    _roomDevice = roomDevice;
    self.slider.roomDevice = roomDevice;
}

- (void)setSpeed:(CGFloat)speed
{
    _speed = speed;
    [self.slider setValue:speed animated:YES];
}

- (void)setTheme:(OMDynamicTheme)theme
{
    _theme = theme;
    if (theme == OMDynamicThemeHappy) {
        self.sceneTypeLabel.text = @"happy";
    } else if (theme == OMDynamicThemeDinner) {
        self.sceneTypeLabel.text = @"dinner";
    } else if (theme == OMDynamicThemeGardon) {
        self.sceneTypeLabel.text = @"gardon";
    } else if (theme == OMDynamicThemeRomantic) {
        self.sceneTypeLabel.text = @"romantic";
    } else if (theme == OMDynamicThemeRock) {
        self.sceneTypeLabel.text = @"rock";
    } else if (theme == OMDynamicThemeWinnerNight) {
        self.sceneTypeLabel.text = @"winner night";
    }
}


@end


@interface OMStaticControlView()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *colorLabel;
@property (strong, nonatomic) UIButton *colorButton;
@property (strong, nonatomic) UIImageView *detailImageView;

@end


@implementation OMStaticControlView

- (void)initView
{
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_color"]];

    self.colorLabel = [[UILabel alloc] init];
    self.colorLabel.text = @"Color";

    self.colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.colorButton.backgroundColor = [UIColor whiteColor];

    self.detailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rgb_light_detail"]];

    self.colorLabel.font = FontFactor(13.0f);
    self.colorLabel.textColor = Color(@"a9b82f");

    [self sd_addSubviews:@[self.imageView, self.colorLabel, self.colorButton, self.detailImageView]];
}

- (void)addAutoLayout
{
    self.imageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.detailImageView.sd_layout
    .rightSpaceToView(self, MarginFactor(10.0f))
    .topSpaceToView(self, MarginFactor(35.0f))
    .widthIs(self.detailImageView.image.size.width)
    .heightIs(self.detailImageView.image.size.height);

    self.colorButton.sd_layout
    .rightSpaceToView(self.detailImageView, MarginFactor(10.0f))
    .centerYEqualToView(self.detailImageView)
    .widthIs(MarginFactor(30.0f))
    .heightEqualToWidth();

    self.colorLabel.sd_layout
    .leftSpaceToView(self, MarginFactor(30.0f))
    .centerYEqualToView(self.detailImageView)
    .heightIs(self.colorLabel.font.lineHeight);
    [self.colorLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];
}

- (void)addReactiveCocoa
{
    WEAK(self, weakSelf);
    [[self.colorButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        OMMutiableLightColorViewController *controller = [[OMMutiableLightColorViewController alloc] init];
        controller.colorIndex = self.colorIndex;
        controller.roomDevice = self.roomDevice;
        controller.block = ^(NSInteger colorIndex){
            weakSelf.colorIndex = colorIndex;
        };
        [[UIViewController findSourceViewController:self].navigationController pushViewController:controller animated:YES];
    }];
}

- (void)setColorIndex:(NSInteger)colorIndex
{
    _colorIndex = MAX(0, colorIndex - 1);
    self.colorButton.backgroundColor = Color([colorArray objectAtIndex:_colorIndex]);
}

@end



@interface OMSlider()

@end

@implementation OMSlider

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.minimumValue = 1.0f;
    self.maximumValue = 8.0f;
    [self setMaximumTrackImage:[UIImage imageNamed:@"blink_speed_bar_empty"] forState:UIControlStateNormal];
    [self setMinimumTrackImage:[UIImage imageNamed:@"blink_speed_bar_full"] forState:UIControlStateNormal];
    [self setThumbImage:[UIImage imageNamed:@"blink_speed_bar_handle"] forState:UIControlStateNormal];
    [self sizeToFit];
}

- (void)setValue:(float)value animated:(BOOL)animated
{
    [super setValue:value animated:animated];
    if (!animated) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(changeColorlightSpeed) withObject:nil afterDelay:0.4f];
    }
}

- (void)changeColorlightSpeed
{
    NSNumber *value = @(lrintf(self.value));
    [OMGlobleManager changeColorLightSpeed:@[self.roomDevice.roomDeviceID, value] inView:self.superview.superview block:^(NSArray *array) {

    }];
}

@end


#pragma mark -------OMMutibleCircleView
@interface OMMutibleCircleView()

@property (strong, nonatomic) UIImageView *circleImageView1;
@property (strong, nonatomic) UIImageView *pointImageView1;
@property (strong, nonatomic) UIImageView *diskImageView;
@property (strong, nonatomic) UIImageView *circleImageView2;
@property (strong, nonatomic) UIImageView *pointImageView2;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIImageView *typeImageView1;
@property (strong, nonatomic) UILabel *typeLabel1;
@property (strong, nonatomic) UIImageView *typeImageView2;
@property (strong, nonatomic) UILabel *typeLabel2;

@property (assign, nonatomic) BOOL isOnInline;
@property (assign, nonatomic) CGPoint circleCenter;
@property (assign, nonatomic) CGFloat radial;//半径
@property (assign, nonatomic) CGFloat rotateAngle;//旋转角度
@property (assign, nonatomic) CGPoint northPoint;
@property (assign, nonatomic) BOOL gestureLock;

@property (assign, nonatomic) BOOL isOnOutline;
@property (assign, nonatomic) CGFloat outRadial;//半径
@property (assign, nonatomic) CGPoint outNorthPoint;
@property (assign, nonatomic) BOOL outGestureLock;

@property (assign, nonatomic) CGFloat limitAngle;

@property (assign, nonatomic) NSRange inValueRange;
@property (assign, nonatomic) NSRange outValueRange;
@property (assign, nonatomic) CGFloat inValue;
@property (assign, nonatomic) CGFloat outValue;

@end

@implementation OMMutibleCircleView

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];

    self.diskImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightCircle_bg"]];

    self.circleImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doublelight_out_circle"]];

    self.circleImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colorlight_in_circle"]];

    self.typeImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"light_mutable"]];
    self.typeImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colorlight_icon"]];

    self.pointImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sliderButton_normal"]];
    self.pointImageView1.hidden = YES;

    self.pointImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sliderButton_normal"]];
    self.pointImageView2.hidden = YES;

    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setImage:[UIImage imageNamed:@"roomDevice_SwitchOff"] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:@"roomDevice_SwitchOn"] forState:UIControlStateSelected];

    self.typeLabel1 = [[UILabel alloc] init];
    self.typeLabel1.text = @"Brightness";
    self.typeLabel1.textColor = [UIColor lightGrayColor];

    self.typeLabel2 = [[UILabel alloc] init];
    self.typeLabel2.text = @"Tone";
    self.typeLabel2.textColor = [UIColor lightGrayColor];

    [self sd_addSubviews:@[self.diskImageView, self.circleImageView1, self.circleImageView2, self.pointImageView1, self.pointImageView2, self.button, self.typeImageView1, self.typeImageView2, self.typeLabel1, self.typeLabel2]];

    self.limitAngle = 140.0f;
    self.outValueRange = NSMakeRange(0, 100);
    self.inValueRange = NSMakeRange(0, 100);

}

- (void)addAutoLayout
{
    self.diskImageView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .widthIs(self.diskImageView.image.size.width)
    .heightIs(self.diskImageView.image.size.height);

    self.circleImageView1.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .widthIs(self.circleImageView1.image.size.width)
    .heightIs(self.circleImageView1.image.size.height);
    WEAK(self, weakSelf);
    self.circleImageView1.didFinishAutoLayoutBlock = ^(CGRect rect){
        weakSelf.circleCenter = weakSelf.circleImageView1.center;
        weakSelf.outRadial = CGRectGetHeight(rect) / 2.0f - self.pointImageView1.image.size.height / 2.0f;
        weakSelf.outNorthPoint = CGPointMake(weakSelf.circleCenter.x, weakSelf.circleCenter.y - weakSelf.radial);
    };

    self.circleImageView2.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .widthIs(self.circleImageView2.image.size.width)
    .heightIs(self.circleImageView2.image.size.height);

    self.circleImageView2.didFinishAutoLayoutBlock = ^(CGRect rect){
        weakSelf.radial = CGRectGetHeight(rect) / 2.0f - self.pointImageView1.image.size.height / 2.0f + 4.0f;
        weakSelf.northPoint = CGPointMake(weakSelf.circleCenter.x, weakSelf.circleCenter.y - weakSelf.outRadial);
    };

    self.button.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .widthIs(self.button.currentImage.size.width)
    .heightIs(self.button.currentImage.size.height);

    self.typeImageView1.sd_layout
    .centerXEqualToView(self)
    .offset(-40.0f)
    .topSpaceToView(self.diskImageView, -20.0f)
    .widthIs(self.typeImageView1.image.size.width)
    .heightIs(self.typeImageView1.image.size.height);

    self.typeLabel1.sd_layout
    .centerXEqualToView(self)
    .offset(20.0f)
    .centerYEqualToView(self.typeImageView1)
    .heightIs(self.typeLabel1.font.lineHeight);
    [self.typeLabel1 setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.typeImageView2.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self.button, MarginFactor(5.0f))
    .widthIs(self.typeImageView2.image.size.width)
    .heightIs(self.typeImageView2.image.size.height);

    self.typeLabel2.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self.typeImageView2, MarginFactor(5.0f))
    .heightIs(self.typeLabel2.font.lineHeight);
    [self.typeLabel2 setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];
}

- (void)addReactiveCocoa
{
    [[[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //这里面button状态要反写
            [OMGlobleManager changeColorLightState:@[self.roomDevice.roomDeviceID, button.isSelected ? @"0" : @"1"] inView:self.superview.superview block:^(NSArray *array) {
                [subscriber sendNext:array];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
        return nil;
    }] subscribeNext:^(id x) {
        if (![[x firstObject] isEqualToString:@"OFFLINE"]) {
            [self.button setSelected:!self.button.isSelected];
            self.roomDevice.roomDeviceState = !self.roomDevice.roomDeviceState;
            self.tableViewCell.roomDevice = self.roomDevice;
        }
    }];
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self.button setSelected:[[dataArray objectAtIndex:1] isEqualToString:@"1"]];
    self.outValue = [[dataArray objectAtIndex:3] floatValue];
    self.inValue = [[dataArray objectAtIndex:4] floatValue];
    [self initSliderPosition];
    [OMAlarmView sharedAlarmView].roomDevice = self.roomDevice;

}

- (void)initSliderPosition
{
    self.pointImageView1.hidden = NO;
    self.pointImageView2.hidden = NO;
    CGFloat maxAngle = self.limitAngle * 2.0f;
    CGFloat vpc = self.inValueRange.length / maxAngle;   //内部每度表示多少值
    CGFloat angle = 0.0f;
    if (self.inValue >= self.inValueRange.length / 2.0f) {
        angle = (self.inValue - self.inValueRange.location) / vpc - self.limitAngle;
        angle -= 90.0f;
    } else {
        angle = self.limitAngle - (self.inValue - self.inValueRange.location) / vpc;
        angle = 270.0f - angle;
    }
    CGFloat radian = DEGREE_TO_RADIAN(angle);
    [self.pointImageView2 setCenter:CGPointMake(self.circleCenter.x + self.radial * cos(radian), self.circleCenter.y + self.radial * sin(radian))];

    vpc = self.outValueRange.length / maxAngle; //内部每度表示多少值
    if (self.outValue >= self.outValueRange.length / 2.0f) {
        angle = (self.outValue - self.outValueRange.location) / vpc - self.limitAngle;
        angle -= 90.0f;
    } else {
        angle = self.limitAngle - (self.outValue - self.outValueRange.location) / vpc;
        angle = 270.0f - angle;
    }
    radian = DEGREE_TO_RADIAN(angle);
    [self.pointImageView1 setCenter:CGPointMake(self.circleCenter.x + self.outRadial * cos(radian), self.circleCenter.y + self.outRadial * sin(radian))];
}

- (void)slideMutablelightInState
{
    NSNumber *value = @(lrintf(self.inValue));
    [OMGlobleManager changeColorLightInState:@[self.roomDevice.roomDeviceID, value] inView:self.superview.superview block:^(NSArray *array) {

    }];
}

- (void)slideMutablelightOutState
{
    NSNumber *value = @(lrintf(self.outValue));
    [OMGlobleManager changeColorLightOutState:@[self.roomDevice.roomDeviceID, value] inView:self.superview.superview block:^(NSArray *array) {

    }];
}


- (void)setRoomDevice:(OMRoomDevice *)roomDevice
{
    _roomDevice = roomDevice;
    [self loadData];
}

- (CGFloat)lengthOfTowPoint:(CGPoint)p1 point2:(CGPoint)p2
{
    CGFloat a = fabs(p1.x - p2.x);
    CGFloat b = fabs(p1.y - p2.y);
    return sqrt(a*a + b*b);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if([self isOnLine:touchPoint radial:self.radial]){
        self.isOnInline = YES;
        [self moveCircle:touchPoint];
    }
    if([self isOnLine:touchPoint radial:self.outRadial]){
        self.isOnOutline = YES;
        [self moveOutCircle:touchPoint];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if(self.isOnInline){
        [self moveCircle:touchPoint];
    }
    if(self.isOnOutline){
        [self moveOutCircle:touchPoint];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self.pointImageView2 setImage:[UIImage imageNamed:@"sliderButton_normal"]];
    [self.pointImageView1 setImage:[UIImage imageNamed:@"sliderButton_normal"]];
    self.isOnInline = NO;
    self.isOnOutline = NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if(self.isOnInline){
        [self performSelector:@selector(slideMutablelightInState) withObject:nil afterDelay:0.4f];
    }
    if(self.isOnOutline){
        [self performSelector:@selector(slideMutablelightOutState) withObject:nil afterDelay:0.4f];
    }
    [self.pointImageView2 setImage:[UIImage imageNamed:@"sliderButton_normal"]];
    [self.pointImageView1 setImage:[UIImage imageNamed:@"sliderButton_normal"]];
    self.isOnInline = NO;
    self.isOnOutline = NO;
}


- (void)moveCircle:(CGPoint)touchPoint
{
    [self.pointImageView2 setImage:[UIImage imageNamed:@"sliderButton_hightlighted"]];
    if (self.pointImageView2.center.x < self.circleCenter.x) {
        //位于左边
        if (touchPoint.x < self.pointImageView2.center.x) {
            self.gestureLock = NO;
        }
    }else{
        //位于右边
        if (touchPoint.x > self.pointImageView2.center.x) {
            self.gestureLock = NO;
        }
    }
    if (self.gestureLock) {
        return;
    }

    CGFloat lineC = [self lengthOfTowPoint:touchPoint point2:self.northPoint];
    CGFloat lineA = [self lengthOfTowPoint:self.northPoint point2:self.circleCenter];
    CGFloat lineB = [self lengthOfTowPoint:touchPoint point2:self.circleCenter];
    CGFloat cosDetal = (lineA*lineA + lineB*lineB - lineC*lineC) / (2 * lineA*lineB);
    cosDetal = [[NSString stringWithFormat:@"%.2f",cosDetal] floatValue];
    CGFloat detal = acosf(cosDetal);
    CGFloat angle = RADIAN_TO_DEGREE(detal);

    CGFloat maxAngle = self.limitAngle * 2;
    CGFloat vpc = self.inValueRange.length / maxAngle;    //每度表示多少值
    if (angle > self.limitAngle) {
        angle = self.limitAngle;
        self.gestureLock = YES;
    }

    if (touchPoint.x >= self.circleCenter.x) {
        CGFloat value = (self.limitAngle + angle) * vpc + self.inValueRange.location;
        self.inValue = value;
        angle -= 90.0f;
        NSLog(@"%.2f",value);
    }else{
        CGFloat value = (self.limitAngle - angle) * vpc + self.inValueRange.location;
        self.inValue = value;
        angle = 270.0f - angle;
        NSLog(@"%.2f",value);
    }

    CGFloat radian = DEGREE_TO_RADIAN(angle);
    [self.pointImageView2 setCenter:CGPointMake(self.circleCenter.x + self.radial * cos(radian), self.circleCenter.y + self.radial * sin(radian))];
}

- (void)moveOutCircle:(CGPoint) touchPoint
{
    [self.pointImageView1 setImage:[UIImage imageNamed:@"sliderButton_hightlighted"]];
    if (self.pointImageView1.center.x < self.circleCenter.x) {
        //位于左边
        if (touchPoint.x < self.pointImageView1.center.x) {
            self.outGestureLock = NO;
        }
    }else{
        //位于右边
        if (touchPoint.x > self.pointImageView1.center.x) {
            self.outGestureLock = NO;
        }
    }
    if (self.outGestureLock) {
        return;
    }

    CGFloat lineC = [self lengthOfTowPoint:touchPoint point2:self.outNorthPoint];
    CGFloat lineA = [self lengthOfTowPoint:self.outNorthPoint point2:self.circleCenter];
    CGFloat lineB = [self lengthOfTowPoint:touchPoint point2:self.circleCenter];
    CGFloat cosDetal = (lineA*lineA + lineB*lineB - lineC*lineC) / (2*lineA*lineB);
    cosDetal = [[NSString stringWithFormat:@"%.2f",cosDetal] floatValue];
    CGFloat detal = acosf(cosDetal);
    CGFloat angle = RADIAN_TO_DEGREE(detal);

    CGFloat maxAngle = self.limitAngle * 2;
    CGFloat vpc = self.outValueRange.length / maxAngle;   //每度表示多少值
    if (angle > self.limitAngle) {
        angle = self.limitAngle;
        self.outGestureLock = YES;
    }

    if (touchPoint.x >= self.circleCenter.x) {
        CGFloat value = (self.limitAngle + angle) * vpc + self.outValueRange.location;
        self.outValue = value;
        angle -= 90.0f;
        NSLog(@"%.2f",value);
    }else{
        CGFloat value = (self.limitAngle - angle) * vpc + self.outValueRange.location;
        self.outValue = value;
        angle = 270.0f - angle;
        NSLog(@"%.2f",value);
    }
    CGFloat radian = DEGREE_TO_RADIAN(angle);
    [self.pointImageView1 setCenter:CGPointMake(self.circleCenter.x + self.outRadial * cos(radian), self.circleCenter.y + self.outRadial * sin(radian))];
}

- (BOOL)isOnLine:(CGPoint) point radial:(CGFloat) radial
{
    CGFloat length = [self lengthOfTowPoint:point point2:self.circleCenter];
    return length < radial + self.pointImageView1.image.size.width / 2.0f && length > radial - self.pointImageView1.image.size.width / 2.0f;
}

@end
