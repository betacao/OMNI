//
//  FYUDPNetWork.h
//  SocketDemo
//
//  Created by changxicao on 16/4/10.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GCDAsyncUdpSocket.h"

@interface OMUDPNetWork : NSObject

@property (strong, nonatomic) GCDAsyncUdpSocket *socket;

+ (instancetype)sharedNetWork;

- (void)refreshUdpSocket;

- (NSString *)sendMessage:(NSString *)message type:(NSInteger)type inView:(UIView *)view;

@end
