//
//  FYUDPNetWork.m
//  SocketDemo
//
//  Created by changxicao on 16/4/10.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMUDPNetWork.h"
#import "OMTCPNetWork.h"

@interface OMUDPNetWork()<GCDAsyncUdpSocketDelegate>

@property (assign, nonatomic) long tag;
@property (assign, nonatomic) BOOL isReceived;
@property (assign, nonatomic) long sendCount;
@property (strong, nonatomic) NSString *code;
@end

@implementation OMUDPNetWork

+ (instancetype)sharedNetWork
{
    static OMUDPNetWork *sharedNetWork = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetWork = [[self alloc] init];
    });
    return sharedNetWork;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSocket];
    }
    return self;
}

- (void)setupSocket
{
    dispatch_queue_t dQueue = dispatch_queue_create("delegateQueue", NULL);
    self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dQueue];
    NSError *error = nil;

    if (![self.socket bindToPort:0 error:&error]) {
        NSLog(@"error------%@", error.description);
        return;
    }
    
    if (![self.socket beginReceiving:&error]) {
        NSLog(@"error------%@", error.description);
        return;
    }
}

- (void)refreshUdpSocket
{
    [self.socket close];
}


- (NSString *)sendMessage:(NSString *)message type:(NSInteger)type inView:(UIView *)view
{
    [view showLoading];
    self.isReceived = NO;
    self.sendCount = 0;
    self.tag++;
    self.code = [@"accept" stringByAppendingFormat:@"%ld", self.tag];

    message = [[NSString stringWithFormat:@"%ld#",self.tag] stringByAppendingFormat:@"%@#",message];
    NSString *request = @"";
    if (type == 1) {
        request = [@"ICP2P0259#" stringByAppendingFormat:@"%@#U#%@#%@#%@",kAppDelegate.deviceID, kAppDelegate.pinCode, kAppDelegate.userID, message];
    } else{
        request = [@"ICP2P0259#" stringByAppendingFormat:@"%@#U#G7S3#%@#%@",kAppDelegate.deviceID, kAppDelegate.userID, message];
    }
    NSData *data = [request dataUsingEncoding:NSUTF8StringEncoding];

    long port = strtoul([kAppDelegate.deviceID UTF8String], 0, 16);
    port = [self getPort:port];

    NSInteger i = 20;
    while (!self.isReceived && self.sendCount < 3) {
        if (i == 20) {
            i = 0;
            self.sendCount++;
            [self.socket sendData:data toHost:@"120.27.151.216" port:port withTimeout:-1 tag:self.tag];
        }
        i++;
        usleep(200 * 1000);
    }
    [view hideHud];
    if (self.sendCount >= 3) {
        [OMGlobleManager clear:type inView:view block:nil];
        [view showWithText:@"设备离线"];
        return @"OFFLINE";
    }
    NSString *steam = kAppDelegate.receivedStream;
    kAppDelegate.receivedStream = @"";

    if ([steam containsString:@"ERROR_PIN"]) {
        [view showWithText:@"PIN码输入错误"];
        return @"ERROR_PIN";
    } else if([steam containsString:@"OFFLINE"]) {
        [view showWithText:@"设备离线"];
        return @"OFFLINE";
    }
    return steam;
}

- (uint16_t)getPort:(long)port
{
    if(port%10==0)
        return 11000;
    else if(port%10==1)
        return 11001;
    else if(port%10==2)
        return 11002;
    else if(port%10==3)
        return 11003;
    else if(port%10==4)
        return 11004;
    else if(port%10==5)
        return 11005;
    else if(port%10==6)
        return 11006;
    else if(port%10==7)
        return 11007;
    else if(port%10==8)
        return 11008;
    else if(port%10==9)
        return 11009;
    else 
        return 11102;
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"发送数据 tag===%ld", tag);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"未能发送数据 tag===%ld", tag);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"udp string:%@",string);
    if ([string containsString:@"ERROR_PIN"]) {
        self.isReceived = YES;
        kAppDelegate.receivedStream = string;
    } else if([string containsString:@"OFFLINE"]) {
        self.isReceived = YES;
        kAppDelegate.receivedStream = string;
    } else {
        NSArray *array = [string componentsSeparatedByString:@"#"];
        NSString *globleString = [array firstObject];
        NSLog(@"code == %@", self.code);
        if ([self.code isEqualToString:globleString]) {
            self.isReceived = YES;
            string = [string substringFromIndex:[string rangeOfString:globleString].length];
            kAppDelegate.receivedStream = string;
        }
    }

}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupSocket];
    });
}

@end
