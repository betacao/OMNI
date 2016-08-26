//
//  OMScene.m
//  OMNI
//
//  Created by changxicao on 16/8/22.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMScene.h"

@implementation OMScene

- (void)setSceneImageID:(NSInteger)sceneImageID
{
    _sceneImageID = sceneImageID;
    if (sceneImageID == 14 || sceneImageID == 15) {
        NSString *imageN = [NSString stringWithFormat:@"s_%ld_n",(long)sceneImageID + 2];
        self.sceneImageN = [UIImage imageNamed:imageN];

        NSString *imageP = [NSString stringWithFormat:@"s_%ld_p",(long)sceneImageID + 2];
        self.sceneImageP = [UIImage imageNamed:imageP];
    } else {

        NSString *imageN = [NSString stringWithFormat:@"s_%ld_n",(long)sceneImageID + 1];
        self.sceneImageN = [UIImage imageNamed:imageN];

        NSString *imageP = [NSString stringWithFormat:@"s_%ld_p",(long)sceneImageID + 1];
        self.sceneImageP = [UIImage imageNamed:imageP];
    }
}

@end
