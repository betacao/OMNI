//
//  OMSingleSlider.h
//  OMNI
//
//  Created by changxicao on 16/7/13.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMSingleSlider.h"
#import "OMAlarmView.h"

@interface OMSingleSlider()

@property (strong, nonatomic) UIImageView *diskImageView;
@property (strong, nonatomic) UIImageView *pointImageView;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIImageView *circleImageView;
@property (strong, nonatomic) UIImageView *typeImageView;
@property (strong, nonatomic) UILabel *label;


@property (assign, nonatomic) BOOL isOnline;
@property (assign, nonatomic) CGPoint circleCenter;
@property (assign, nonatomic) CGFloat radial;//半径
@property (assign, nonatomic) CGPoint northPoint;
@property (assign, nonatomic) BOOL gestureLock;

@property (assign, nonatomic) CGFloat limitAngle;

@property (assign, nonatomic) NSRange valueRange;
@property (assign, nonatomic) CGFloat currentValue;

@end

@implementation OMSingleSlider

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];

    self.diskImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightCircle_bg"]];

    self.circleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"singleLightCircle"]];

    self.typeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"light_single"]];

    self.pointImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sliderButton_normal"]];
    self.pointImageView.hidden = YES;

    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setImage:[UIImage imageNamed:@"roomDevice_SwitchOff"] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:@"roomDevice_SwitchOn"] forState:UIControlStateSelected];

    self.label = [[UILabel alloc] init];
    self.label.text = @"Brightness";
    self.label.textColor = [UIColor lightGrayColor];

    [self sd_addSubviews:@[self.diskImageView, self.circleImageView, self.typeImageView, self.label, self.button, self.pointImageView]];

    self.limitAngle = 140.0f;
    self.valueRange = NSMakeRange(5, 95);
}

- (void)addAutoLayout
{
    self.diskImageView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .widthIs(self.diskImageView.image.size.width)
    .heightIs(self.diskImageView.image.size.height);

    self.circleImageView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .widthIs(self.circleImageView.image.size.width)
    .heightIs(self.circleImageView.image.size.height);

    WEAK(self, weakSelf);
    self.circleImageView.didFinishAutoLayoutBlock = ^(CGRect rect){
        weakSelf.circleCenter = weakSelf.circleImageView.center;
        weakSelf.radial = CGRectGetHeight(rect) / 2.0f - self.pointImageView.image.size.height / 2.0f + 4.0f;
        weakSelf.northPoint = CGPointMake(weakSelf.circleCenter.x, weakSelf.circleCenter.y - weakSelf.radial);
    };

    self.button.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .widthIs(self.button.currentImage.size.width)
    .heightIs(self.button.currentImage.size.height);

    self.typeImageView.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self.button, MarginFactor(5.0f))
    .widthIs(self.typeImageView.image.size.width)
    .heightIs(self.typeImageView.image.size.height);

    self.label.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self.typeImageView, 0.0f)
    .heightIs(self.label.font.lineHeight);
    [self.label setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];
}

- (void)addReactiveCocoa
{
    [[[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //这里面button状态要反写
            [OMGlobleManager changeSingleLightState:@[self.roomDevice.roomDeviceID, button.isSelected ? @"0" : @"1"] inView:self block:^(NSArray *array) {
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

- (void)setRoomDevice:(OMRoomDevice *)roomDevice
{
    _roomDevice = roomDevice;
    [self loadData];
}

- (void)loadData
{
    if (self.roomDevice) {
        [OMGlobleManager readSingleLightState:self.roomDevice.roomDeviceID inView:self.superview block:^(NSArray *array) {
            BOOL success = [[array firstObject] isEqualToString:@"SUCCESS"];
            if (success) {
                [self.button setSelected:[[array objectAtIndex:1] isEqualToString:@"1"]];
                self.currentValue = [[array lastObject] floatValue];
                [self initSliderPosition];
                [OMAlarmView sharedAlarmView].roomDevice = self.roomDevice;
            }
        }];
    }
}

- (void)initSliderPosition
{
    self.pointImageView.hidden = NO;
    CGFloat maxAngle = self.limitAngle * 2.0f;
    CGFloat vpc = self.valueRange.length / maxAngle;   //每度表示多少值
    CGFloat angle = 0.0f;
    if (self.currentValue >= self.valueRange.length / 2.0f) {
        angle = (self.currentValue - self.valueRange.location) / vpc - self.limitAngle;
        angle -= 90.0f;
    } else {
        angle = self.limitAngle - (self.currentValue - self.valueRange.location) / vpc;
        angle = 270.0f - angle;
    }
    CGFloat radian = DEGREE_TO_RADIAN(angle);
    [self.pointImageView setCenter:CGPointMake(self.circleCenter.x + self.radial * cos(radian), self.circleCenter.y + self.radial * sin(radian))];
}

- (void)slideSingleLightState
{
    [OMGlobleManager slideSingleLightState:@[self.roomDevice.roomDeviceID, @(self.currentValue)] inView:self block:^(NSArray *array) {

    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if([self isOnLine:touchPoint]) {
        self.isOnline = YES;
        [self moveCirclr:touchPoint];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if(self.isOnline) {
        [self moveCirclr:touchPoint];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isOnline = NO;
    self.pointImageView.image = [UIImage imageNamed:@"sliderButton_normal"];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isOnline = NO;
    self.pointImageView.image = [UIImage imageNamed:@"sliderButton_normal"];
    [self performSelector:@selector(slideSingleLightState) withObject:nil afterDelay:0.4f];
}

- (BOOL)isOnLine:(CGPoint) point
{
    CGFloat length =[self lengthOfTowPoint:point point2:self.circleCenter];
    return length < (self.radial + self.pointImageView.image.size.height / 2.0f + 5.0f) && length > (self.radial - self.pointImageView.image.size.height / 2.0f - 5.0f);
}

- (CGFloat)lengthOfTowPoint:(CGPoint)p1 point2:(CGPoint)p2
{
    CGFloat a = fabs(p1.x - p2.x);
    CGFloat b = fabs(p1.y - p2.y);
    return sqrt(a*a + b*b);
}

- (void)moveCirclr:(CGPoint)touchPoint
{
    self.pointImageView.image = [UIImage imageNamed:@"sliderButton_hightlighted"];
    if (self.pointImageView.center.x < self.circleCenter.x) {
        //位于左边
        if (touchPoint.x < self.pointImageView.center.x) {
            self.gestureLock = NO;
        }
    } else {
        //位于右边
        if (touchPoint.x > self.pointImageView.center.x) {
            self.gestureLock = NO;
        }
    }
    if (self.gestureLock) {
        return;
    }

    CGFloat lineC = [self lengthOfTowPoint:touchPoint point2:self.northPoint];
    CGFloat lineA = [self lengthOfTowPoint:self.northPoint point2:self.circleCenter];
    CGFloat lineB = [self lengthOfTowPoint:touchPoint point2:self.circleCenter];
    //根据余弦定理
    CGFloat cosDetal = (lineA*lineA + lineB*lineB - lineC*lineC) / (2*lineA*lineB);
    cosDetal = [[NSString stringWithFormat:@"%.2f",cosDetal] floatValue];
    CGFloat detal = acosf(cosDetal);
    CGFloat angle = RADIAN_TO_DEGREE(detal);

    CGFloat maxAngle = self.limitAngle * 2.0f;
    CGFloat vpc = self.valueRange.length / maxAngle;   //每度表示多少值
    if (angle > self.limitAngle) {
        angle = self.limitAngle;
        self.gestureLock = YES;
    }

    if (touchPoint.x >= self.circleCenter.x) {
        CGFloat value = (self.limitAngle + angle) * vpc + self.valueRange.location;
        self.currentValue = value;
        angle -= 90.0f;
        NSLog(@"%.2f",value);
    }else{
        CGFloat value = (self.limitAngle - angle) * vpc + self.valueRange.location;
        self.currentValue = value;
        angle = 270.0f - angle;
        NSLog(@"%.2f",value);
    }
    CGFloat radian = DEGREE_TO_RADIAN(angle);
    [self.pointImageView setCenter:CGPointMake(self.circleCenter.x + self.radial * cos(radian), self.circleCenter.y + self.radial * sin(radian))];
}

@end
