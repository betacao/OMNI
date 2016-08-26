//
//  OMTCPNetWork.m
//  OMNI
//
//  Created by changxicao on 16/5/16.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMTCPNetWork.h"

@interface OMTCPNetWork()<GCDAsyncSocketDelegate>

@property (strong, nonatomic) GCDAsyncSocket *sendTcpSocket;
@property (strong, nonatomic) GCDAsyncSocket *sendSpecialTcpSocket;
@property (copy, nonatomic) OMTCPNetWorkFinishBlock finishBlock;
@property (strong, nonatomic) UIView *view;
@property (assign, nonatomic) BOOL isReceived;

@end

@implementation OMTCPNetWork

+ (instancetype) sharedNetWork
{
    static OMTCPNetWork *sharedEngine = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedEngine = [[self alloc] init];
    });
    return sharedEngine;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSocket];
        [[RACObserve(kAppDelegate, ESPDescription) filter:^BOOL(NSString *x) {
            return x && x.length > 0;
        }] subscribeNext:^(NSString *value) {
            dispatch_queue_t dQueue = dispatch_queue_create("client special tdp socket", NULL);
            self.sendSpecialTcpSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dQueue socketQueue:nil];
            uint16_t port = 180;
            self.sendSpecialTcpSocket.IPv4PreferredOverIPv6 = NO;
            [self.sendTcpSocket connectToHost:value onPort:port withTimeout:60 error:nil];
        }];

    }
    return self;
}

- (void)hideHud
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger i = 0;
        while (!weakSelf.isReceived && i < 10) {
            i++;
            usleep(1000 * 1000);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.view hideHud];
            if (!weakSelf.isReceived) {
                [weakSelf.view showWithText:@"命令超时"];
            }
        });
    });
}

- (void)setupSocket
{
    dispatch_queue_t dQueue = dispatch_queue_create("client tdp socket", NULL);
    // 1. 创建一个 udp socket用来和服务端进行通讯
    self.sendTcpSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dQueue socketQueue:nil];
    // 2. 连接服务器端. 只有连接成功后才能相互通讯 如果60s连接不上就出错
    NSString *host = @"121.42.187.151";
    uint16_t port = 11104;
    self.sendTcpSocket.IPv4PreferredOverIPv6 = NO;
    [self.sendTcpSocket connectToHost:host onPort:port withTimeout:60 error:nil];
    // 连接必须服务器在线
}


- (void)sendMessage:(NSString *)message inView:(UIView *)view complete:(OMTCPNetWorkFinishBlock)block
{
    [view showLoading];
    self.isReceived = NO;
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    // 发送消息 这里不需要知道对象的ip地址和端口
    [self.sendTcpSocket writeData:data withTimeout:60 tag:0];
    self.finishBlock = block;
    self.view = view;
    [self hideHud];
}

- (void)sendSpecialMessage:(NSString *)message inView:(UIView *)view complete:(OMTCPNetWorkFinishBlock)block
{
    if (self.sendSpecialTcpSocket) {
        [view showLoading];
        self.isReceived = NO;
        NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
        // 发送消息 这里不需要知道对象的ip地址和端口
        [self.sendSpecialTcpSocket writeData:data withTimeout:60 tag:0];
        self.finishBlock = block;
        self.view = view;
        [self hideHud];
    } else {
        block(@"fail");
    }
}

#pragma mark - 代理方法表示连接成功/失败 回调函数

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"连接成功");
    [sock readDataWithTimeout:-1 tag:0];
}
// 如果对象关闭了 这里也会调用
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    // 断线重连
    NSLog(@"连接失败 %@", err);
    NSString *host = @"121.42.187.151";
    uint16_t port = 11104;
    [self.sendTcpSocket connectToHost:host onPort:port withTimeout:60 error:nil];
}


- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"消息发送成功");
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    self.isReceived = YES;
    __weak typeof(self) weakSelf = self;
    NSString *ip = [sock connectedHost];
    uint16_t port = [sock connectedPort];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"接收到服务器返回的数据 tcp [%@:%d] %@", ip, port, string);
    dispatch_async(dispatch_get_main_queue(), ^{
        if(weakSelf.finishBlock){
            weakSelf.finishBlock(string);
        }
    });
    [sock readDataWithTimeout:-1 tag:0];
}

@end
