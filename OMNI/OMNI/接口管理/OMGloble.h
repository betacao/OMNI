//
//  OMGloble.h
//  OMNI
//
//  Created by changxicao on 16/8/23.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMGloble : NSObject

+ (instancetype)globle;

+ (void)writeScene:(NSArray *)array;

+ (NSArray *)readScene;

@end
