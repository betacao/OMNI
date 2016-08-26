//
//  OMDoubleSlider.m
//  OMNI
//
//  Created by changxicao on 16/7/16.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMDoubleSlider.h"
#import "OMAlarmView.h"

@interface OMDoubleSlider()

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

@property (assign, nonatomic) NSRange valueRange;
@property (assign, nonatomic) CGFloat inValue;
@property (assign, nonatomic) CGFloat outValue;

@end

@implementation OMDoubleSlider

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];

    self.diskImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightCircle_bg"]];

    self.circleImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doublelight_out_circle"]];

    self.circleImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doublelight_in_circle"]];

    self.typeImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"light_double"]];
    self.typeImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doublelight_icon"]];

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
    self.typeLabel2.text = @"CT";
    self.typeLabel2.textColor = [UIColor lightGrayColor];

    [self sd_addSubviews:@[self.diskImageView, self.circleImageView1, self.circleImageView2, self.pointImageView1, self.pointImageView2, self.button, self.typeImageView1, self.typeImageView2, self.typeLabel1, self.typeLabel2]];

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
            [OMGlobleManager changeDoubleLightState:@[self.roomDevice.roomDeviceID, button.isSelected ? @"0" : @"1"] inView:self block:^(NSArray *array) {
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

- (void)loadData
{
    if (self.roomDevice) {
        [OMGlobleManager readDoubleLightState:self.roomDevice.roomDeviceID inView:self.superview block:^(NSArray *array) {
            BOOL success = [[array firstObject] isEqualToString:@"SUCCESS"];
            if (success) {
                [self.button setSelected:[[array objectAtIndex:1] isEqualToString:@"1"]];
                self.outValue = [[array objectAtIndex:2] floatValue];
                self.inValue = [[array lastObject] floatValue];
                [self initSliderPosition];
                [OMAlarmView sharedAlarmView].roomDevice = self.roomDevice;
            }
        }];
    }
}

- (void)initSliderPosition
{
    self.pointImageView1.hidden = NO;
    self.pointImageView2.hidden = NO;
    CGFloat maxAngle = self.limitAngle * 2.0f;
    CGFloat vpc = self.valueRange.length / maxAngle;   //每度表示多少值
    CGFloat angle = 0.0f;
    if (self.inValue >= self.valueRange.length / 2.0f) {
        angle = (self.inValue - self.valueRange.location) / vpc - self.limitAngle;
        angle -= 90.0f;
    } else {
        angle = self.limitAngle - (self.inValue - self.valueRange.location) / vpc;
        angle = 270.0f - angle;
    }
    CGFloat radian = DEGREE_TO_RADIAN(angle);
    [self.pointImageView2 setCenter:CGPointMake(self.circleCenter.x + self.radial * cos(radian), self.circleCenter.y + self.radial * sin(radian))];

    if (self.outValue >= self.valueRange.length / 2.0f) {
        angle = (self.outValue - self.valueRange.location) / vpc - self.limitAngle;
        angle -= 90.0f;
    } else {
        angle = self.limitAngle - (self.outValue - self.valueRange.location) / vpc;
        angle = 270.0f - angle;
    }
    radian = DEGREE_TO_RADIAN(angle);
    [self.pointImageView1 setCenter:CGPointMake(self.circleCenter.x + self.outRadial * cos(radian), self.circleCenter.y + self.outRadial * sin(radian))];
}

- (void)slideDoublelightInState
{
    [OMGlobleManager slideDoubleLightInState:@[self.roomDevice.roomDeviceID, @(self.inValue)] inView:self block:^(NSArray *array) {

    }];
}

- (void)slideDoublelightOutState
{
    [OMGlobleManager slideDoubleLightOutState:@[self.roomDevice.roomDeviceID, @(self.outValue)] inView:self block:^(NSArray *array) {

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
        [self performSelector:@selector(slideDoublelightInState) withObject:nil afterDelay:0.4f];
    }
    if(self.isOnOutline){
        [self performSelector:@selector(slideDoublelightOutState) withObject:nil afterDelay:0.4f];
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
    CGFloat vpc = self.valueRange.length / maxAngle;    //每度表示多少值
    if (angle > self.limitAngle) {
        angle = self.limitAngle;
        self.gestureLock = YES;
    }

    if (touchPoint.x >= self.circleCenter.x) {
        CGFloat value = (self.limitAngle + angle) * vpc + self.valueRange.location;
        self.inValue = value;
        angle -= 90.0f;
        NSLog(@"%.2f",value);
    }else{
        CGFloat value = (self.limitAngle - angle) * vpc + self.valueRange.location;
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
    CGFloat vpc = self.valueRange.length / maxAngle;   //每度表示多少值
    if (angle > self.limitAngle) {
        angle = self.limitAngle;
        self.outGestureLock = YES;
    }

    if (touchPoint.x >= self.circleCenter.x) {
        CGFloat value = (self.limitAngle + angle) * vpc + self.valueRange.location;
        self.outValue = value;
        angle -= 90.0f;
        NSLog(@"%.2f",value);
    }else{
        CGFloat value = (self.limitAngle - angle) * vpc + self.valueRange.location;
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
