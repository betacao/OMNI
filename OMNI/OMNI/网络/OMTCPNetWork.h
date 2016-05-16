//
//  OMTCPNetWork.h
//  OMNI
//
//  Created by changxicao on 16/5/16.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"

@interface OMTCPNetWork : NSObject

+ (instancetype) sharedNetWork;

- (NSString *)sendMessage:(NSString *)message type:(NSInteger)type inView:(UIView *)view;

@end
