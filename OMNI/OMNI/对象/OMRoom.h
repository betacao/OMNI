//
//  OMRoom.h
//  OMNI
//
//  Created by changxicao on 16/6/5.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMRoom : NSObject

@property (strong, nonatomic) NSString *roomName;
@property (assign, nonatomic) NSInteger roomIndex;
@property (strong, nonatomic) NSString *deviceID;
@property (strong, nonatomic) NSString *deviceState;

@end
