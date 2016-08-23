//
//  OMScene.h
//  OMNI
//
//  Created by changxicao on 16/8/22.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMScene : NSObject

@property (assign, nonatomic) NSInteger sceneID;
@property (strong, nonatomic) NSString *sceneName;
@property (strong, nonatomic) UIImage *sceneImageN;
@property (strong, nonatomic) UIImage *sceneImageP;

@end
