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

typedef void (^OMTCPNetWorkFinishBlock) (NSString *string);

@interface OMTCPNetWork : NSObject

+ (instancetype) sharedNetWork;

- (void)sendMessage:(NSString *)message inView:(UIView *)view complete:(OMTCPNetWorkFinishBlock)block;

- (void)sendSpecialMessage:(NSString *)message inView:(UIView *)view complete:(OMTCPNetWorkFinishBlock)block;

@end
