//
//  OMTCPNetWork.m
//  OMNI
//
//  Created by changxicao on 16/5/16.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMTCPNetWork.h"

@interface OMTCPNetWork()<GCDAsyncSocketDelegate>

@property (strong, nonatomic) GCDAsyncSocket *socket;
@property (assign, nonatomic) long tag;
@property (assign, nonatomic) BOOL isReceived;
@property (assign, nonatomic) long sendCount;
@property (strong, nonatomic) NSString *code;

@end


@implementation OMTCPNetWork

+ (instancetype)sharedNetWork
{
    static OMTCPNetWork *sharedNetWork = nil;
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
    dispatch_queue_t dQueue = dispatch_queue_create("client tdp socket", NULL);
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dQueue socketQueue:nil];
    NSString *host = @"121.42.187.151";
    uint16_t port = 11104;
    [self.socket connectToHost:host onPort:port withTimeout:60 error:nil];
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
    [self.socket writeData:data withTimeout:60 tag:0];

    NSInteger i = 20;
    while (!self.isReceived && self.sendCount < 3) {
        if (i == 20) {
            i = 0;
            self.sendCount++;
        }
        i++;
        usleep(200 * 1000);
    }
    [view hideHud];
    if (self.sendCount >= 3) {
        [view showWithText:@"设备离线"];
        return @"OFFLINE";
    }

    NSString *steam = kAppDelegate.receivedStream;
    kAppDelegate.receivedStream = @"";
    return steam;
}


- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"连接成功");
    [sock readDataWithTimeout:-1 tag:0];
}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"连接失败 %@", err);
    // 断线重连
    NSString *host = @"121.42.187.151";
    uint16_t port = 11104;
    [self.socket connectToHost:host onPort:port withTimeout:60 error:nil];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"消息发送成功");
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *ip = [sock connectedHost];
    uint16_t port = [sock connectedPort];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"接收到服务器返回的数据 tcp [%@:%d] %@", ip, port, string);

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

    [sock readDataWithTimeout:-1 tag:0];;
}

@end
