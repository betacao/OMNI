//
//  OMSingleLightViewController.h
//  OMNI
//
//  Created by changxicao on 16/7/7.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMBaseViewController.h"
#import "OMRoomTableViewCell.h"

@interface OMSingleLightViewController : OMBaseViewController

@property (strong, nonatomic) OMRoomDevice *roomDevice;

@property (weak, nonatomic) OMRoomTableViewCell *tableViewCell;

@end
