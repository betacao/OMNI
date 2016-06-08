//
//  OMWifiConfigViewController.m
//  OMNI
//
//  Created by changxicao on 16/5/23.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMWifiConfigViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "ESPTouchTask.h"
#import "OMAddGateWayViewController.h"

@interface OMWifiConfigViewController ()<UIAlertViewDelegate, UIScrollViewDelegate, TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIButton *configButton;
@property (weak, nonatomic) IBOutlet UITextField *wifiNameField;
@property (weak, nonatomic) IBOutlet UITextField *wifiPWDField;

@property (atomic, strong) ESPTouchTask *esptouchTask;
@property (nonatomic, assign) BOOL isConfirmState;
@property (nonatomic, assign) BOOL isConfirmSuccess;
@property (nonatomic, strong) NSCondition *condition;
@property (strong, nonatomic) NSString *bssid;

@end

@implementation OMWifiConfigViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Wifi Config";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf getDeviceSSID:^(NSDictionary *dictionary) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.wifiNameField.text = [dictionary objectForKey:@"SSID"];
                weakSelf.bssid = [dictionary objectForKey:@"BSSID"];
            });
        }];
    });
}


- (void)initView
{
    self.scrollView.delegate = self;

    self.isConfirmState = NO;
    self.condition = [[NSCondition alloc] init];
    [self enableConfirmBtn];

    UIView *leftView1 = [[UIView alloc] init];
    UIImageView *leftImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_password"]];
    [leftView1 addSubview:leftImageView1];
    leftImageView1.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(10.0f), 0.0f, MarginFactor(10.0f)));

    leftView1.sd_layout
    .heightIs(leftImageView1.image.size.height)
    .widthIs(leftImageView1.image.size.width + MarginFactor(20.0f));


    UIView *leftView2 = [[UIView alloc] init];
    UIImageView *leftImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_ssid"]];
    [leftView2 addSubview:leftImageView2];
    leftImageView2.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(10.0f), 0.0f, MarginFactor(10.0f)));

    leftView2.sd_layout
    .heightIs(leftImageView2.image.size.height)
    .widthIs(leftImageView2.image.size.width + MarginFactor(20.0f));


    self.wifiNameField.leftView = leftView1;
    self.wifiNameField.leftViewMode = UITextFieldViewModeAlways;
    self.wifiPWDField.leftView = leftView2;
    self.wifiPWDField.leftViewMode = UITextFieldViewModeAlways;

    UIImage *image1 = self.wifiNameField.background;
    image1 = [image1 resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch];
    self.wifiNameField.background = image1;

    UIImage *image2 = self.wifiNameField.background;
    image2 = [image2 resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch];
    self.wifiPWDField.background = image2;

    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:self.scrollView]) {
            [self.scrollView addSubview:obj];
        }
    }];

    self.bottomLabel.text = @"Have account already? Please login";
    self.bottomLabel.font = FontFactor(13.0f);
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.bottomLabel.linkAttributes];
    [dictionary setObject:[UIColor redColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    self.bottomLabel.linkAttributes = dictionary;
    [self.bottomLabel addLinkToURL:[NSURL URLWithString:@"123"] withRange:[self.bottomLabel.text rangeOfString:@"login"]];
}

- (void)addAutoLayout
{
    self.imageView.sd_layout
    .centerXEqualToView(self.scrollView)
    .topSpaceToView(self.scrollView, MarginFactor(50.0f))
    .widthIs(self.imageView.image.size.width)
    .heightIs(self.imageView.image.size.height);

    self.introduceLabel.sd_layout
    .leftSpaceToView(self.scrollView, MarginFactor(20.0f))
    .rightSpaceToView(self.scrollView, MarginFactor(20.0f))
    .topSpaceToView(self.imageView, MarginFactor(10.0f))
    .autoHeightRatio(0.0f);

    self.wifiNameField.sd_layout
    .leftSpaceToView(self.scrollView, MarginFactor(20.0f))
    .rightSpaceToView(self.scrollView, MarginFactor(20.0f))
    .topSpaceToView(self.introduceLabel, MarginFactor(20.0f))
    .heightIs(MarginFactor(40.0f));

    self.wifiPWDField.sd_layout
    .leftSpaceToView(self.scrollView, MarginFactor(20.0f))
    .rightSpaceToView(self.scrollView, MarginFactor(20.0f))
    .topSpaceToView(self.wifiNameField, MarginFactor(20.0f))
    .heightIs(MarginFactor(40.0f));

    self.configButton.sd_layout
    .centerXEqualToView(self.scrollView)
    .topSpaceToView(self.wifiPWDField, MarginFactor(30.0f))
    .widthIs(self.configButton.currentBackgroundImage.size.width)
    .heightIs(self.configButton.currentBackgroundImage.size.height);

    self.bottomLabel.sd_layout
    .leftSpaceToView(self.scrollView, MarginFactor(20.0f))
    .rightSpaceToView(self.scrollView, MarginFactor(20.0f))
    .topSpaceToView(self.configButton, MarginFactor(10.0f))
    .autoHeightRatio(0.0f);
    self.bottomLabel.isAttributedContent = YES;
}


- (void)addReactiveCocoa
{
    [[self.configButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self commit];
    }];

    [[self rac_signalForSelector:@selector(attributedLabel:didSelectLinkWithURL:) fromProtocol:@protocol(TTTAttributedLabelDelegate)] subscribeNext:^(RACTuple *tuple) {
        OMAddGateWayViewController *controller = [[OMAddGateWayViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
}

- (void)getDeviceSSID:(void(^)(NSDictionary *dictionary))completion
{
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dctySSID = (NSDictionary *)info;
    completion(dctySSID);
}

- (void)commit
{
    if (self.isConfirmState) {
        [self.scrollView showWithText:@"正在配置，请稍等..." enable:NO duration:0.0f];
        [self enableCancelBtn];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSArray *esptouchResultArray = [self executeForResults];
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.scrollView hideHud];
                [self enableConfirmBtn];

                ESPTouchResult *firstResult = [esptouchResultArray objectAtIndex:0];
                if (!firstResult.isCancelled) {
                    NSMutableString *mutableStr = [[NSMutableString alloc]init];
                    NSUInteger count = 0;
                    const int maxDisplayCount = 5;
                    if ([firstResult isSuc]) {
                        for (NSInteger i = 0; i < [esptouchResultArray count]; ++i) {
                            ESPTouchResult *resultInArray = [esptouchResultArray objectAtIndex:i];
                            [mutableStr appendString:[resultInArray description]];
                            [mutableStr appendString:@"\n"];
                            count++;
                            if (count >= maxDisplayCount) {
                                break;
                            }
                        }

                        if (count < [esptouchResultArray count]) {
                            [mutableStr appendString:[NSString stringWithFormat:@"\nthere's %lu more result(s) without showing\n",(unsigned long)([esptouchResultArray count] - count)]];
                        }
                        self.isConfirmSuccess = YES;
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"配置成功" message:mutableStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        alert.delegate = self;
                        [alert show];
                    } else {
                        self.isConfirmSuccess = NO;
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"配置失败" message:@"Esptouch fail" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        alert.delegate = self;
                        [alert show];
                    }
                }

            });
        });
    } else {
        [self.scrollView hideHud];
        [self enableConfirmBtn];
        [self cancel];
    }
}

- (void) cancel
{
    [self.condition lock];
    if (self.esptouchTask != nil) {
        [self.esptouchTask interrupt];
    }
    [self.condition unlock];
}

- (NSArray *) executeForResults
{
    [self.condition lock];
    NSString *apSsid = self.wifiNameField.text;
    NSString *apPwd = self.wifiPWDField.text;
    NSString *apBssid = self.bssid;
    self.esptouchTask =
    [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd andIsSsidHiden:NO];
    [self.condition unlock];
    NSArray * esptouchResults = [self.esptouchTask executeForResults:1];
    NSLog(@"ESPViewController executeForResult() result is: %@",esptouchResults);
    return esptouchResults;
}


- (void)enableConfirmBtn
{
    self.isConfirmState = YES;
    [self.configButton setTitle:@"Configuration" forState:UIControlStateNormal];
}

- (void)enableCancelBtn
{
    self.isConfirmState = NO;
    [self.configButton setTitle:@"Cancel" forState:UIControlStateNormal];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.isConfirmSuccess) {
        [self.scrollView showWithText:@"设备已入网，请等待12秒钟，设备重启"];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scrollView hideHud];
            OMAddGateWayViewController *controller = [[OMAddGateWayViewController alloc] init];
            [weakSelf.navigationController pushViewController:controller animated:YES];
        });
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
