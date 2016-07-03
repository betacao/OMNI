//
//  OMDeviceConfigView.m
//  OMNI
//
//  Created by changxicao on 16/6/27.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMDeviceConfigView.h"
#import "OMListViewController.h"

@interface OMDeviceConfigView()

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIButton *firstButton;
@property (strong, nonatomic) UIButton *secondButton;
@property (strong, nonatomic) UIButton *thirdButton;
@property (strong, nonatomic) UIView *whiteView;

@property (strong, nonatomic) OMDeviceChangeWifiView *changeWifiView;
@property (strong, nonatomic) OMDeviceDeleteView *deleteView;
@property (strong, nonatomic) OMDeviceRenameView *renameView;

@end

@implementation OMDeviceConfigView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)initView
{
    self.imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"alert_image"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f) resizingMode:UIImageResizingModeStretch]];

    self.firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.firstButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.firstButton setTitle:@"Change Wifi" forState:UIControlStateNormal];
    [self.firstButton setSelected:YES];
    [self.firstButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateSelected];

    self.secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.secondButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.secondButton setTitle:@"Delete" forState:UIControlStateNormal];
    [self.secondButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateSelected];

    self.thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.thirdButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.thirdButton setTitle:@"Rename" forState:UIControlStateNormal];
    [self.thirdButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateSelected];

    self.firstButton.titleLabel.font = self.secondButton.titleLabel.font = self.thirdButton.titleLabel.font = FontFactor(14.0f);

    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = [UIColor whiteColor];

    self.changeWifiView = [[OMDeviceChangeWifiView alloc] init];
    self.deleteView = [[OMDeviceDeleteView alloc] init];
    self.deleteView.hidden = YES;

    self.renameView = [[OMDeviceRenameView alloc] init];
    self.renameView.hidden = YES;
    
    [self sd_addSubviews:@[self.imageView, self.firstButton, self.secondButton, self.thirdButton, self.whiteView, self.changeWifiView, self.deleteView, self.renameView]];
}

- (void)addAutoLayout
{
    self.imageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.firstButton.sd_layout
    .topSpaceToView(self, MarginFactor(25.0f))
    .leftSpaceToView(self, 0.0f)
    .widthRatioToView(self, 1.0f / 3.0f)
    .heightIs(MarginFactor(30.0f));

    self.secondButton.sd_layout
    .topEqualToView(self.firstButton)
    .leftSpaceToView(self.firstButton, 0.0f)
    .widthRatioToView(self.firstButton, 1.0f)
    .heightRatioToView(self.firstButton, 1.0f);

    self.thirdButton.sd_layout
    .topEqualToView(self.firstButton)
    .leftSpaceToView(self.secondButton, 0.0f)
    .widthRatioToView(self.firstButton, 1.0f)
    .heightRatioToView(self.firstButton, 1.0f);

    self.whiteView.sd_layout
    .topSpaceToView(self.firstButton, 0.0f)
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .heightIs(SCALE);

    self.changeWifiView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .topSpaceToView(self.whiteView, MarginFactor(25.0f));

    self.deleteView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .topSpaceToView(self.whiteView, MarginFactor(25.0f));

    self.renameView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .topSpaceToView(self.whiteView, MarginFactor(25.0f));

    self.sd_layout
    .widthIs(MarginFactor(280.0f))
    .heightIs(MarginFactor(320.0f));

    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)addReactiveCocoa
{
    void(^block)(UIButton *button) = ^(UIButton *button) {
        [self.firstButton setSelected:NO];
        [self.secondButton setSelected:NO];
        [self.thirdButton setSelected:NO];
        [button setSelected:YES];
        self.changeWifiView.hidden = YES;
        self.deleteView.hidden = YES;
        self.renameView.hidden = YES;
    };
    [[[self.firstButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:block] subscribeNext:^(id x) {
        self.changeWifiView.hidden = NO;
    }];

    [[[self.secondButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:block] subscribeNext:^(id x) {
        self.deleteView.hidden = NO;
    }];

    [[[self.thirdButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:block] subscribeNext:^(id x) {
        self.renameView.hidden = NO;
    }];

    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(NSNotification *notification) {
        CGRect frame = self.superview.frame;
        frame.origin.y = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y - CGRectGetHeight(frame);
        [UIView animateWithDuration:0.25f animations:^{
            self.superview.frame = frame;
        }];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(NSNotification *notification) {
        [UIView animateWithDuration:0.25f animations:^{
            self.superview.center = self.window.center;
        }];
    }];
}

- (RACSignal *)signal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
    }];
}
@end


@interface OMDeviceChangeWifiView()

@property (strong, nonatomic) UIView *line1;
@property (strong, nonatomic) UIImageView *imageView1;
@property (strong, nonatomic) UITextField *textField1;
@property (strong, nonatomic) UIView *line2;
@property (strong, nonatomic) UIImageView *imageView2;
@property (strong, nonatomic) UITextField *textField2;
@property (strong, nonatomic) UIView *line3;
@property (strong, nonatomic) UIImageView *imageView3;
@property (strong, nonatomic) UITextField *textField3;
@property (strong, nonatomic) UIView *line4;

@property (strong, nonatomic) UIButton *button;

@end

@implementation OMDeviceChangeWifiView

- (void)initView
{
    self.line1 = [[UIView alloc] init];
    self.line1.backgroundColor = [UIColor colorWithWhite:0.6f alpha:0.6f];
    self.imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4_bit_password"]];
    self.textField1 = [[UITextField alloc] init];
    self.textField1.textColor = [UIColor whiteColor];
    self.textField1.font = FontFactor(13.0f);
    self.textField1.placeholder = @"4-bit password";

    self.line2 = [[UIView alloc] init];
    self.line2.backgroundColor = [UIColor colorWithWhite:0.6f alpha:0.6f];
    self.imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_name"]];
    self.textField2 = [[UITextField alloc] init];
    self.textField2.textColor = [UIColor whiteColor];
    self.textField2.font = FontFactor(13.0f);
    self.textField2.placeholder = @"input name";

    self.line3 = [[UIView alloc] init];
    self.line3.backgroundColor = [UIColor colorWithWhite:0.6f alpha:0.6f];
    self.imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_pwd"]];
    self.textField3 = [[UITextField alloc] init];
    self.textField3.textColor = [UIColor whiteColor];
    self.textField3.font = FontFactor(13.0f);
    self.textField3.placeholder = @"input wifi pwd";

    self.line4 = [[UIView alloc] init];
    self.line4.backgroundColor = [UIColor colorWithWhite:0.6f alpha:0.6f];

    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 4.0f;
    self.button.layer.borderColor = [UIColor whiteColor].CGColor;
    self.button.layer.borderWidth = 1 / SCALE;
    [self.button setTitle:@"confirm" forState:UIControlStateNormal];

    self.textField1.tintColor = self.textField2.tintColor = self.textField3.tintColor = [UIColor whiteColor];
    [self.textField1 setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.textField2 setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.textField3 setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

    [self sd_addSubviews:@[self.line1, self.imageView1, self.textField1, self.line2, self.imageView2, self.textField2, self.line3, self.imageView3, self.textField3, self.line4, self.button]];

}

- (void)addAutoLayout
{
    self.line1.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .topSpaceToView(self, 0.0f)
    .heightIs(1 / SCALE);

    self.textField1.sd_layout
    .leftSpaceToView(self, MarginFactor(50.0f))
    .rightSpaceToView(self, MarginFactor(50.0f))
    .topSpaceToView(self.line1, 0.0f)
    .heightIs(MarginFactor(45.0f));

    self.imageView1.sd_layout
    .leftSpaceToView(self, MarginFactor(12.0f))
    .centerYEqualToView(self.textField1)
    .widthIs(self.imageView1.image.size.width)
    .heightIs(self.imageView1.image.size.height);

    self.line2.sd_layout
    .leftEqualToView(self.line1)
    .rightEqualToView(self.line1)
    .topSpaceToView(self.textField1, 0.0f)
    .heightRatioToView(self.line1, 1.0f);

    self.textField2.sd_layout
    .leftEqualToView(self.textField1)
    .rightEqualToView(self.textField1)
    .topSpaceToView(self.line2, 0.0f)
    .heightRatioToView(self.textField1, 1.0f);

    self.imageView2.sd_layout
    .leftEqualToView(self.imageView1)
    .centerYEqualToView(self.textField2)
    .widthIs(self.imageView2.image.size.width)
    .heightIs(self.imageView2.image.size.height);

    self.line3.sd_layout
    .leftEqualToView(self.line1)
    .rightEqualToView(self.line1)
    .topSpaceToView(self.textField2, 0.0f)
    .heightRatioToView(self.line1, 1.0f);

    self.textField3.sd_layout
    .leftEqualToView(self.textField1)
    .rightEqualToView(self.textField1)
    .topSpaceToView(self.line3, 0.0f)
    .heightRatioToView(self.textField1, 1.0f);

    self.imageView3.sd_layout
    .leftEqualToView(self.imageView1)
    .centerYEqualToView(self.textField3)
    .widthIs(self.imageView3.image.size.width)
    .heightIs(self.imageView3.image.size.height);

    self.line4.sd_layout
    .leftEqualToView(self.line1)
    .rightEqualToView(self.line1)
    .topSpaceToView(self.textField3, 0.0f)
    .heightRatioToView(self.line1, 1.0f);

    self.button.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self.line4, MarginFactor(25.0f))
    .widthIs(MarginFactor(150.0f))
    .heightRatioToView(self.textField1, 0.8f);

    [self setupAutoHeightWithBottomView:self.button bottomMargin:MarginFactor(30.0f)];
}


- (void)addReactiveCocoa
{
    [[[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(id value) {
        return [self signal];
    }] subscribeNext:^(NSString *x) {
        if ([x containsString:@"success"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [((OMAlertView *)self.superview.superview) dismissAlert];
                [[OMListViewController shareController] loadData];
            });
        }
    }];
}

- (RACSignal *)signal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [OMGlobleManager changeWifi:@[self.textField1.text, self.textField2.text, self.textField3.text] inView:self block:^(NSArray *array) {
            [subscriber sendNext:array];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

@end


@interface OMDeviceDeleteView()

@property (strong, nonatomic) UIView *line1;
@property (strong, nonatomic) UIImageView *imageView1;
@property (strong, nonatomic) UITextField *textField1;
@property (strong, nonatomic) UIView *line2;

@property (strong, nonatomic) UIButton *button;

@end

@implementation OMDeviceDeleteView

- (void)initView
{
    self.line1 = [[UIView alloc] init];
    self.line1.backgroundColor = [UIColor colorWithWhite:0.6f alpha:0.6f];
    self.imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4_bit_password"]];
    self.textField1 = [[UITextField alloc] init];
    self.textField1.textColor = [UIColor whiteColor];
    self.textField1.font = FontFactor(13.0f);
    self.textField1.placeholder = @"4-bit password";

    self.line2 = [[UIView alloc] init];
    self.line2.backgroundColor = [UIColor colorWithWhite:0.6f alpha:0.6f];

    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 4.0f;
    self.button.layer.borderColor = [UIColor whiteColor].CGColor;
    self.button.layer.borderWidth = 1 / SCALE;
    [self.button setTitle:@"confirm" forState:UIControlStateNormal];

    self.textField1.tintColor = [UIColor whiteColor];
    [self.textField1 setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

    [self sd_addSubviews:@[self.line1, self.imageView1, self.textField1, self.line2, self.button]];
}

- (void)addAutoLayout
{
    self.line1.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .topSpaceToView(self, 0.0f)
    .heightIs(1 / SCALE);

    self.textField1.sd_layout
    .leftSpaceToView(self, MarginFactor(50.0f))
    .rightSpaceToView(self, MarginFactor(50.0f))
    .topSpaceToView(self.line1, 0.0f)
    .heightIs(MarginFactor(45.0f));

    self.imageView1.sd_layout
    .leftSpaceToView(self, MarginFactor(12.0f))
    .centerYEqualToView(self.textField1)
    .widthIs(self.imageView1.image.size.width)
    .heightIs(self.imageView1.image.size.height);

    self.line2.sd_layout
    .leftEqualToView(self.line1)
    .rightEqualToView(self.line1)
    .topSpaceToView(self.textField1, 0.0f)
    .heightRatioToView(self.line1, 1.0f);

    self.button.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self.line2, MarginFactor(25.0f))
    .widthIs(MarginFactor(150.0f))
    .heightRatioToView(self.textField1, 0.8f);

    [self setupAutoHeightWithBottomView:self.button bottomMargin:MarginFactor(30.0f)];
}

- (void)addReactiveCocoa
{
    [[[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(id value) {
        return [self signal];
    }] subscribeNext:^(NSString *x) {
        if ([x containsString:@"success"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [((OMAlertView *)self.superview.superview) dismissAlert];
                [[OMListViewController shareController] loadData];
            });
        }
    }];
}

- (RACSignal *)signal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [OMGlobleManager deleteDevice:@[self.textField1.text] inView:self block:^(NSString *string) {
            [subscriber sendNext:[string lowercaseString]];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}


@end

@interface OMDeviceRenameView()

@property (strong, nonatomic) UIView *line1;
@property (strong, nonatomic) UIImageView *imageView1;
@property (strong, nonatomic) UITextField *textField1;
@property (strong, nonatomic) UIView *line2;

@property (strong, nonatomic) UIButton *button;

@end

@implementation OMDeviceRenameView

- (void)initView
{
    self.line1 = [[UIView alloc] init];
    self.line1.backgroundColor = [UIColor colorWithWhite:0.6f alpha:0.6f];
    self.imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_name"]];
    self.textField1 = [[UITextField alloc] init];
    self.textField1.textColor = [UIColor whiteColor];
    self.textField1.font = FontFactor(13.0f);
    self.textField1.placeholder = @"input name";

    self.line2 = [[UIView alloc] init];
    self.line2.backgroundColor = [UIColor colorWithWhite:0.6f alpha:0.6f];

    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 4.0f;
    self.button.layer.borderColor = [UIColor whiteColor].CGColor;
    self.button.layer.borderWidth = 1 / SCALE;
    [self.button setTitle:@"confirm" forState:UIControlStateNormal];

    self.textField1.tintColor = [UIColor whiteColor];
    [self.textField1 setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

    [self sd_addSubviews:@[self.line1, self.imageView1, self.textField1, self.line2, self.button]];
}

- (void)addAutoLayout
{
    self.line1.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .topSpaceToView(self, 0.0f)
    .heightIs(1 / SCALE);

    self.textField1.sd_layout
    .leftSpaceToView(self, MarginFactor(50.0f))
    .rightSpaceToView(self, MarginFactor(50.0f))
    .topSpaceToView(self.line1, 0.0f)
    .heightIs(MarginFactor(45.0f));

    self.imageView1.sd_layout
    .leftSpaceToView(self, MarginFactor(12.0f))
    .centerYEqualToView(self.textField1)
    .widthIs(self.imageView1.image.size.width)
    .heightIs(self.imageView1.image.size.height);

    self.line2.sd_layout
    .leftEqualToView(self.line1)
    .rightEqualToView(self.line1)
    .topSpaceToView(self.textField1, 0.0f)
    .heightRatioToView(self.line1, 1.0f);

    self.button.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self.line2, MarginFactor(25.0f))
    .widthIs(MarginFactor(150.0f))
    .heightRatioToView(self.textField1, 0.8f);

    [self setupAutoHeightWithBottomView:self.button bottomMargin:MarginFactor(30.0f)];
}

- (void)addReactiveCocoa
{
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(NSString *x) {
        [[NSUserDefaults standardUserDefaults] setObject:self.textField1.text forKey:[NSString stringWithFormat:@"%@.deviceName", kAppDelegate.deviceID]];
        [((OMAlertView *)self.superview.superview) dismissAlert];
        [[OMListViewController shareController] loadData];
    }];
}

@end
