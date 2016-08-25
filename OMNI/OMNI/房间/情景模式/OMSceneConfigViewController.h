//
//  OMSceneConfigViewController.h
//  OMNI
//
//  Created by changxicao on 16/8/24.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseViewController.h"
#import "OMBaseView.h"
#import "OMRoomScene.h"

@interface OMSceneConfigViewController : OMBaseViewController

@end


@interface OMSceneConfigView : OMBaseView

@property (strong, nonatomic) NSArray <OMRoomScene *>*array;

- (NSString *)requestString;

@end