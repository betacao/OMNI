//
//  OMGloble.m
//  OMNI
//
//  Created by changxicao on 16/8/23.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMGloble.h"
#import "OMScene.h"

@interface OMGloble()

@property (strong, nonatomic) YYMemoryCache *sceneCache;
@property (strong, nonatomic) YYCache *thumbnailImageCache;

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

- (YYMemoryCache *)sceneCache
{
    if (!_sceneCache) {
        _sceneCache = [YYMemoryCache new];
    }
    return _sceneCache;
}

- (YYCache *)thumbnailImageCache
{
    if (!_thumbnailImageCache) {
        _thumbnailImageCache = [YYCache cacheWithName:@"roomThumbnailImage"];
    }
    return _thumbnailImageCache;
}

+ (void)writeScene:(NSArray *)array
{
    NSMutableArray *result = [NSMutableArray array];
    if (array) {
        for (NSInteger i = 0; i < array.count / 2.0f; i++) {
            OMScene *scene = [[OMScene alloc] init];
            scene.modeID = i;
            scene.sceneImageID = [[array objectAtIndex:i * 2] integerValue];
            scene.sceneName = [array objectAtIndex:i * 2 + 1];
            [result addObject:scene];
        }
        [[OMGloble globle].sceneCache setObject:result forKey:@"sceneInfo"];
    }
}

+ (void)readScene:(void (^)(NSArray *))block
{
    NSArray *array = (NSArray *)[[OMGloble globle].sceneCache objectForKey:@"sceneInfo"];
    if (array.count == 0) {
        [OMGlobleManager readSceneModeInfoInView:[UIApplication sharedApplication].keyWindow block:^(NSArray *array) {
            [OMGloble writeScene:array];
            block(array);
        }];
    } else {
        block(array);
    };
}

+ (void)writeRoomThumbnail:(UIImage *)image forRoom:(OMRoom *)room
{
    NSString *key = [kAppDelegate.deviceID stringByAppendingString:room.roomNumber];
    [[OMGloble globle].thumbnailImageCache setObject:image forKey:key];
}

+ (UIImage *)thumbnailImageForRoom:(OMRoom *)room
{
    NSString *key = [kAppDelegate.deviceID stringByAppendingString:room.roomNumber];
    UIImage *image = (UIImage *)[[OMGloble globle].thumbnailImageCache objectForKey:key];
    return image;
}

@end
