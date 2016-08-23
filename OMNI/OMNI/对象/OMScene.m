//
//  OMScene.m
//  OMNI
//
//  Created by changxicao on 16/8/22.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMScene.h"

@implementation OMScene

- (void)setSceneID:(NSInteger)sceneID
{
    _sceneID = sceneID;
    if (sceneID == 14 || sceneID == 15) {
        NSString *imageN = [NSString stringWithFormat:@"s_%ld_n",(long)sceneID + 2];
        self.sceneImageN = [UIImage imageNamed:imageN];

        NSString *imageP = [NSString stringWithFormat:@"s_%ld_p",(long)sceneID + 2];
        self.sceneImageP = [UIImage imageNamed:imageP];
    } else {

        NSString *imageN = [NSString stringWithFormat:@"s_%ld_n",(long)sceneID + 1];
        self.sceneImageN = [UIImage imageNamed:imageN];

        NSString *imageP = [NSString stringWithFormat:@"s_%ld_p",(long)sceneID + 1];
        self.sceneImageP = [UIImage imageNamed:imageP];
    }
}

@end
