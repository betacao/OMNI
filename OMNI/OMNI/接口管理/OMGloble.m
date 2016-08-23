//
//  OMGloble.m
//  OMNI
//
//  Created by changxicao on 16/8/23.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMGloble.h"

@interface OMGloble()

@property (strong, nonatomic) YYCache *sceneCache;

@end

@implementation OMGloble

+ (instancetype)globle
{
    static OMGloble *globleInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globleInstance = [[self alloc] init];
    });
    return globleInstance;
}

- (YYCache *)sceneCache
{
    if (!_sceneCache) {
        _sceneCache = [YYCache cacheWithName:@"sceneInfo"];
    }
    return _sceneCache;
}

+ (void)writeScene:(NSArray *)array
{
    [[OMGloble globle].sceneCache setObject:array forKey:@"sceneInfo"];
}

+ (NSArray *)readScene
{
    return (NSArray *)[[OMGloble globle].sceneCache objectForKey:@"sceneInfo"];
}

@end
