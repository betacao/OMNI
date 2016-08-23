//
//  OMSceneViewController.h
//  OMNI
//
//  Created by changxicao on 16/8/22.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseViewController.h"
#import "OMBaseTableViewCell.h"
#import "OMScene.h"

@interface OMSceneViewController : OMBaseViewController

@end


@interface OMSceneTableViewCell : OMBaseTableViewCell

@property (strong, nonatomic) OMScene *scene;

@end